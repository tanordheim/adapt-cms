# encoding: utf-8

class DesignResource < ActiveRecord::Base #:nodoc

  # Mount a CarrierWave uploader on the file attribute.
  mount_uploader :file, DesignResourceUploader
  
  # Design resources belong to designs, and define assets used in the design.
  belongs_to :design

  # Validate that the design resource has a design associated with it.
  validates :design, :presence => true
  
  # Validate that the design resource has a file associated with it.
  validates :file, :presence => true

  # Before saving the design resource, update the file meta data from the
  # CarrierWave uploader.
  before_save :update_file_meta_data

  # By default, design resources are sorted by their filename, ascending.
  default_scope order('LOWER(design_resources.filename) ASC')

  # Returns the url of the file associated with this design resource. This
  # returns the value of file.url.
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
