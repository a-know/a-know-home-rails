require 'rsvg2'
require 'mini_magick'

class GrassGraphController < ActionController::API
  def show
    tmpfile_path = "./tmp/gg_svg/a-know_#{Time.now.strftime('%Y-%m-%d')}.svg"
    unless ( File.exists?(tmpfile_path) && File.size(tmpfile_path) != 0)
      `curl https://github.com/a-know | awk '/<svg.+class="js-calendar-graph-svg"/,/svg>/' | \
      sed -e 's@<svg@<svg xmlns="http://www.w3.org/2000/svg"@' > #{tmpfile_path}`
    end

    svg_data = File.open(tmpfile_path).read
    png_data = ImageConvert.svg_to_png(svg_data, 720, 115)

    if params[:rotate] || params[:width] || params[:height]
      width  = params[:width]  ? params[:width].to_i : 720
      height = params[:height] ? params[:height].to_i : 115

      image = MiniMagick::Image.read(png_data)
      image.combine_options do |b|
        b.resize "#{width}x#{height}>" if params[:width] || params[:height]
        b.rotate params[:rotate] if params[:rotate] && integer_string?(params[:rotate])
      end
      png_data = image.to_blob
    end

    send_data png_data, :type => 'image/png', :disposition => 'inline'
  end

  def service

  end

  private

  def integer_string?(str)
    Integer(str)
    true
  rescue ArgumentError
    false
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