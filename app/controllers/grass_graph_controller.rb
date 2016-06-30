require 'rsvg2'
require 'mini_magick'

class GrassGraphController < ActionController::API
  def show
    svg_data = extract_svg('a-know')
    png_data = generate_png(svg_data, params[:rotate], params[:height], params[:width])

    send_data png_data, :type => 'image/png', :disposition => 'inline'
  end

  def service
    svg_data = extract_svg(params['github_id'])
    png_data = generate_png(svg_data, params[:rotate], params[:height], params[:width])

    send_data png_data, :type => 'image/png', :disposition => 'inline'
  end

  def extract_svg(github_id)
    retry_count = 0
    while !( File.exists?(tmpfile_path(github_id)) && File.size(tmpfile_path(github_id)) != 0)
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
        /dy="87" style="display: none;">S<\/text>[\s\S]+<\/g>[\s\S]+<\/svg>[\s\S]+\z/,
        'dy="87" style="display: none;">S</text><text x="535" y="110">Less</text><g transform="translate(569 , 0)"><rect class="day" width="11" height="11" y="99" fill="#eeeeee"/></g><g transform="translate(584 , 0)"><rect class="day" width="11" height="11" y="99" fill="#d6e685"/></g><g transform="translate(599 , 0)"><rect class="day" width="11" height="11" y="99" fill="#8cc665"/></g><g transform="translate(614 , 0)"><rect class="day" width="11" height="11" y="99" fill="#44a340"/></g><g transform="translate(629 , 0)"><rect class="day" width="11" height="11" y="99" fill="#1e6823"/></g><text x="648" y="110">More</text></g></svg>')

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

  # experimental
  def type
    params['type'] == 'detail' ? 'detail' : 'graph'
  end

  def tmpfile_path(github_id)
    case github_id
    when 'a-know'
      dir_name = 'gg_svg'
      "./tmp/#{dir_name}/#{github_id}_#{date_string}_#{type}.svg"
    else
      dir_name = 'gg_others_svg'
      tmp_dirname = "tmp/#{dir_name}/#{date_string}"
      FileUtils.mkdir_p(tmp_dirname) unless File.exists?(tmp_dirname)
      "./#{tmp_dirname}/#{github_id}_#{date_string}_#{type}.svg"
    end
  end

  private

  def detail_type?
    type == 'detail'
  end

  def date_string
    @date_string ||= Time.now.strftime('%Y-%m-%d')
  end

  def svg_height
    detail_type? ? 375 : 135
  end

  def upload_gcs(github_id, path)
    return unless Rails.env.production?
    require 'gcloud'
    dir_name = github_id == 'a-know' ? 'my-gg-svg' : 'others-gg-svg'
    gcloud = Gcloud.new('a-know-home', Rails.application.secrets.gcp_json_file_path)
    bucket = gcloud.storage.bucket('gg-on-a-know-home')
    file = bucket.create_file(path, "#{dir_name}/#{Time.now.strftime('%Y-%m')}/#{File.basename(path)}")
  end

  def integer_string?(str)
    Integer(str)
    true
  rescue ArgumentError
    false
  end

  def generate_png(svg_data, rotate, height, width)
    png_data = ImageConvert.svg_to_png(svg_data, 720, svg_height)

    if rotate || width || height || detail_type?
      width  = width  ? width.to_i : resize_width
      height = height ? height.to_i : svg_height

      image = MiniMagick::Image.read(png_data)
      image.combine_options do |b|
        b.resize "#{width}x#{height}>" if width || height
        b.rotate rotate if rotate && integer_string?(rotate)
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