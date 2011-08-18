# Upload a file using the ActionDispatch::TestProcess.fixture_file_upload
# method.
# 
# @return [ Rack::Test::UploadedFile ] The uploaded file object
def upload_file(filename, content_type)
  fixture_file_upload(File.join(Rails.root, 'spec', 'resources', filename), content_type)
end
