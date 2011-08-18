require 'tmpdir'
require 'sass/plugin'

class StylesheetsController < StaticResourceController

  expose(:stylesheet) { requested_stylesheet }

  protected

  # Load the requested stylesheet
  def requested_stylesheet
    design = Site.current.designs.find(params[:design_id])
    stylesheet = design.stylesheets.find_by_filename!(params[:filename])
  end

  # Return the compiled CSS.
  def resource_data

    # Parse the template through Liquid first
    renderer = StylesheetRenderer.new(stylesheet)
    data = renderer.css

    # If we want SASS or SCSS, compile those with Compass.
    if %w(sass scss).include?(stylesheet.processor)
      data = compile_compass_stylesheet(data, stylesheet.processor)
    end

    data
    
  end

  # Return the content type used to serve stylesheets.
  def content_type
    'text/css'
  end

  # Compile a SASS/SCSS stylesheet using Compass
  def compile_compass_stylesheet(css, format)

    compiled_css = ''
    Dir.mktmpdir do |directory|

      input_filename = File.join(directory, "stylesheet.#{format}")
      compiled_filename = File.join(directory, "compiled.css")

      File.open(input_filename, 'w') { |f| f.puts css }

      cache_store = Sass::CacheStores::Memory.new
      compiler_options = {
        :sass => Compass.sass_engine_options,
        :cache_location => directory,
        :cache_store => cache_store,
      }

      compiler = Compass::Compiler.new(
        directory, # Working directory
        directory, # SCSS/SASS input directory
        directory, # CSS output directory
        compiler_options
      )
      compiler.compile(input_filename, compiled_filename)

      compiled_css = File.open(compiled_filename) { |f| f.read }

    end

    compiled_css

  end

end
