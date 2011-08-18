# encoding: utf-8

class DesignResourceUploader < CarrierWave::Uploader::Base #:nodoc

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "design_resources/#{model.id}"
  end

end
