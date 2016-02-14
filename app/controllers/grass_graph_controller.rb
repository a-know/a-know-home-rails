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
    while !( File.exists?(tmpfile_path(github_id)) && File.size(tmpfile_path(github_id)) != 0)
      page_response = Net::HTTP.get(URI.parse("https://github.com/#{github_id}"))
      page_response.gsub!(
        /^[\s\S]+<svg.+class="js-calendar-graph-svg">/,
        '<svg xmlns="http://www.w3.org/2000/svg" width="721" height="110" class="js-calendar-graph-svg">')
      page_response.gsub!(/<\/svg>[\s\S]+\z/, '</svg>')
      page_response.gsub!('<text', '<text font-family="Helvetica"')
      begin
        File.open(tmpfile_path(github_id), 'w') { |f| f.puts page_response }
      rescue
        # GitHub の profile ページ取得に失敗するとファイル書き出しにも失敗するので、その場合には再試行する
        next
      end
    end
    File.open(tmpfile_path(github_id)).read
  end

  private

  def tmpfile_path(github_id)
    dir_name = github_id == 'a-know' ? 'gg_svg' : 'gg_others_svg'
    "./tmp/#{dir_name}/#{github_id}_#{Time.now.strftime('%Y-%m-%d')}.svg"
  end

  def integer_string?(str)
    Integer(str)
    true
  rescue ArgumentError
    false
  end

  def generate_png(svg_data, rotate, height, width)
    png_data = ImageConvert.svg_to_png(svg_data, 720, 115)

    if rotate || width || height
      width  = width  ? width.to_i : 720
      height = height ? height.to_i : 115

      image = MiniMagick::Image.read(png_data)
      image.combine_options do |b|
        b.resize "#{width}x#{height}>" if width || height
        b.rotate rotate if rotate && integer_string?(rotate)
      end
      png_data = image.to_blob
    end
    png_data
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