class Resource < ActiveRecord::Base #:nodoc

  # Mount a CarrierWave uploader on the file attribute.
  mount_uploader :file, ResourceUploader

  # Resources are userstamped so that the creator and updater admins are
  # properly registered.
  include Userstamp
  
  # Resources belongs to a site, and defines an image or file resource used
  # within the site content.
  belongs_to :site

  # Validate that the resource has a site associated with it.
  validates :site, :presence => true
  
  # Validate that the resource has a file associated with it.
  validates :file, :presence => true

  # Before saving the resource, update the file meta data from the CarrierWave
  # uploader.
  before_save :update_file_meta_data

  # By default, resources are sorted by their filename, ascending.
  default_scope order('LOWER(resources.filename) ASC')

  # Returns the url of the file associated with this resource. This returns the
  # value of file.url.
  #
  # @return [ String ] The url of the file.
  def url
    file.url
  end

  # Returns the Liquid representation of this design resource.
  def to_liquid
    {
      'filename' => self.filename,
      'url' => self.url
    }
  end

  private

  # Update the file meta data based on the current CarrierWave uploader.
  def update_file_meta_data
    if file.present? && file_changed?
      self.filename = read_attribute(:file)
      self.content_type = file.file.content_type unless file.file.content_type.blank?
      self.file_size = file.file.size unless file.file.size.blank?
    end
  end

end
