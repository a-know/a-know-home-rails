require 'rsvg2'
require 'mini_magick'

class GrassGraphController < SendToFluentController
  class BadDateString < StandardError; end

  def show
    svg_data = extract_svg('a-know')
    png_data = generate_png(svg_data, params[:rotate], params[:height], params[:width], params[:background])

    send_data png_data, :type => 'image/png', :disposition => 'inline'
  end

  def service
    begin
      if params['date']
        svg_data = past_svg_data(params['github_id'], params['date'])
      else
        svg_data = extract_svg(params['github_id'])
      end
      png_data = generate_png(svg_data, params[:rotate], params[:height], params[:width], params[:background])

      send_data png_data, :type => 'image/png', :disposition => 'inline'
    rescue BadDateString
      head 400
    rescue
      head 404
    end
  end

  def past_svg_data(github_id, date_str)
    date = check_date(date_str)
    path = tmpfile_path(github_id, date)

    unless File.exists?(path)
      file = bucket.file("#{gcs_dir(github_id, date)}/#{File.basename(path)}")
      file.download path
    end

    File.open(path).read
  end

  def check_date(date_str)
    begin
      Date.strptime(date_str,'%Y%m%d')
    rescue
      raise BadDateString
    end
  end

  def extract_svg(github_id)
    retry_count = 0
    while !( File.exists?(tmpfile_path(github_id)) && File.size(tmpfile_path(github_id)) != 0)
      # ページが取得できたら、「その日のリクエストが初めてのユーザー」かつ「常連ユーザーではない場合」に通知する
      notify(github_id) unless is_regular_users?(github_id)

      begin
        target_uri = URI.parse("https://github.com/#{github_id}")
      rescue
        github_id = 'a-know'
        target_uri = URI.parse("https://github.com/#{github_id}")
      end

      page_response = Net::HTTP.get(target_uri)
      contributions_info = page_response.scan(%r|<span class="contrib-number">(.+)</span>|)
      page_response.gsub!(
        /^[\s\S]+<svg.+class="js-calendar-graph-svg">/,
        %Q|<svg xmlns="http://www.w3.org/2000/svg" width="720" height="#{svg_height}" class="js-calendar-graph-svg"><rect x="0" y="0" width="720" height="#{svg_height}" fill="white" stroke="none"/>|)

        # Legend
      page_response.gsub!(
        /dy="81" style="display: none;">Sat<\/text>[\s\S]+<\/g>[\s\S]+<\/svg>[.\s\S]+\z/,
        'dy="81" style="display: none;">Sat</text><text x="535" y="110">Less</text><g transform="translate(569 , 0)"><rect class="day" width="11" height="11" y="99" fill="#eeeeee"/></g><g transform="translate(584 , 0)"><rect class="day" width="11" height="11" y="99" fill="#d6e685"/></g><g transform="translate(599 , 0)"><rect class="day" width="11" height="11" y="99" fill="#8cc665"/></g><g transform="translate(614 , 0)"><rect class="day" width="11" height="11" y="99" fill="#44a340"/></g><g transform="translate(629 , 0)"><rect class="day" width="11" height="11" y="99" fill="#1e6823"/></g><text x="648" y="110">More</text></g></svg>')

      # font-family
      page_response.gsub!('<text', '<text font-family="Helvetica"')

      begin
        File.open(tmpfile_path(github_id), 'w') { |f| f.puts page_response }
        upload_gcs(github_id, tmpfile_path(github_id))
      rescue
        # GitHub の profile ページ取得に失敗するとファイル書き出しにも失敗する
      ensure
        retry_count += 1
        break if retry_count > 5
      end
    end
    File.open(tmpfile_path(github_id)).read
  end

  def notify(github_id)
    fluent_logger('knock').post('slack',
      {
        message: [
          "GitHub ID : #{github_id}'s Grass-Graph Generated!!",
          "https://github.com/#{github_id}"
        ].join("\n")
      }
    )
  end

  def is_regular_users?(github_id)
    Rails.application.secrets.gg_regular_users.split(',').include?(github_id)
  end

  # experimental
  def type
    params['type'] == 'detail' ? 'detail' : 'graph'
  end

  def tmpfile_path(github_id, date = nil)
    case github_id
    when 'a-know'
      dir_name = 'gg_svg'
      "./tmp/#{dir_name}/#{github_id}_#{date_string(date)}_#{type}.svg"
    else
      dir_name = 'gg_others_svg'
      tmp_dirname = "tmp/#{dir_name}/#{date_string(date)}"
      FileUtils.mkdir_p(tmp_dirname) unless File.exists?(tmp_dirname)
      "./#{tmp_dirname}/#{github_id}_#{date_string(date)}_#{type}.svg"
    end
  end

  private

  def detail_type?
    type == 'detail'
  end

  def date_string(date = nil)
    date ||= now
    @date_string ||= date.strftime('%Y-%m-%d')
  end

  def svg_height
    detail_type? ? 375 : 135
  end

  def upload_gcs(github_id, path)
    return unless Rails.env.production?
    file = bucket.create_file(path, "#{gcs_dir(github_id)}/#{File.basename(path)}")
  end

  def gcloud
    require 'gcloud'
    @gcloud ||= Gcloud.new('a-know-home', Rails.application.secrets.gcp_json_file_path)
  end

  def bucket
    @bucket ||= gcloud.storage.bucket('gg-on-a-know-home')
  end

  def gcs_dir(github_id, date = nil)
    date ||= now
    initial = github_id[0]
    "gg-svg-data/#{date.strftime('%Y')}/#{date.strftime('%m')}/#{date.strftime('%d')}/#{initial}"
  end

  def now
    # against issue #137
    Time.now - 10.minutes
  end

  def integer_string?(str)
    Integer(str)
    true
  rescue ArgumentError
    false
  end

  def generate_png(svg_data, rotate, height, width, background)
    png_data = ImageConvert.svg_to_png(svg_data, 720, svg_height)

    if rotate || width || height || background || detail_type?
      width  = width  ? width.to_i : resize_width
      height = height ? height.to_i : svg_height

      image = MiniMagick::Image.read(png_data)
      image.combine_options do |b|
        b.resize "#{width}x#{height}>" if width || height
        b.rotate rotate if rotate && integer_string?(rotate)
        b.transparent('white') unless background.empty?
      end
      png_data = image.to_blob
    end
    png_data
  end

  def resize_width
    detail_type? ? 560 : 720
  end

  class ImageConvert
    def self.svg_to_png(svg, width, height)
      svg = RSVG::Handle.new_from_data(svg)

      b = StringIO.new
      Cairo::ImageSurface.new(Cairo::FORMAT_ARGB32, width, height) do |surface|
        context = Cairo::Context.new(surface)
        context.render_rsvg_handle(svg)
        surface.write_to_png(b)
        surface.finish
      end

      return b.string
    end
  end
end
