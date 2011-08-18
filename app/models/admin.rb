# encoding: utf-8

class Admin < ActiveRecord::Base #:nodoc

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable,
  # :registerable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable,
    :validatable

  # Validate that the admin has a name set.
  validates :name, :presence => true

  # Admins can have several site privileges, connecting the administrator to
  # sites to give them administrative access.
  has_many :site_privileges, :dependent => :destroy
  has_many :sites, :through => :site_privileges

  # Returns true if this administrator has administrative privileges for the
  # specified site.
  def has_privileges_for?(site)
    sites.include?(site)
  end

end
