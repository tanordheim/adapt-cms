require 'mime/types'

class RawFileUpload

  def initialize(app)
    @app = app
  end

  def call(env)
    if raw_file_post?(env)
      convert_and_call(env)
    else
      @app.call(env)
    end
  end

  private

  def raw_file_post?(env)
    env['HTTP_X_FILE_NAME'] && env['CONTENT_TYPE'] == 'application/octet-stream' && env['HTTP_X_REQUESTED_WITH'] == 'XMLHttpRequest'
  end

  def convert_and_call(env)

    request = Rack::Request.new(env)
    field_name = request.params['_field_name']

    tempfile = Tempfile.new('raw-upload.')

    env['rack.input'].each do |chunk|
      tempfile << chunk.force_encoding('UTF-8')
    end

    tempfile.flush
    tempfile.rewind

    mime_type = MIME::Types.type_for(env['HTTP_X_FILE_NAME']).first
    if mime_type.nil?
      mime_type = 'application/octet-stream'
    else
      mime_type = mime_type.to_s
    end

    multipart_hash = {
      :filename => env['HTTP_X_FILE_NAME'],
      :type => mime_type,
      :tempfile => tempfile
    }

    env['rack.request.form_input'] = env['rack.input']

    env['rack.request.form_hash'] ||= {}
    env['rack.request.query_hash'] ||= {}

    env['rack.request.form_hash'][field_name] = multipart_hash
    env['rack.request.query_hash'][field_name] = multipart_hash

    @app.call(env)

  end
end
