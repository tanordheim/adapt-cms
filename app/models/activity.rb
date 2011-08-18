# encoding: utf-8

# Describes an activity logged when an administrator performs an action within
# the administration UI or through the rest API.
class Activity < ActiveRecord::Base

  ACTIONS = %w(create update)

  # Activities are associated with the site that the modified content is
  # associated with.
  belongs_to :site

  # Activities are associated with the administrator that performed the content
  # change.
  belongs_to :author, :class_name => 'Admin'

  # Activities are associated with the content that was changed through a
  # polymorphic association.
  belongs_to :source, :polymorphic => true

  # Validate that the activity is associated with a site.
  validates :site, :presence => true

  # Validate that the activity is associated with an author.
  validates :author, :presence => true

  # Validate that the activity is associated with a source.
  validates :source, :presence => true

  # Validate that the activity has a source name set.
  validates :source_name, :presence => true

  # Validate that the activity has an action set, and that the action is one of
  # the valid values.
  validates :action, :presence => true, :inclusion => { :in => ACTIONS }

  # By default, activities are ordered by their modification time, descending.
  default_scope order('activities.updated_at DESC')

  # Before validation, assign the source name based on the source.
  before_validation :assign_source_name_from_source

  # Returns the name of the author that generated this activity.
  def author_name
    self.author.name
  end

  # Returns the e-mail address of the author that generated this activity.
  def author_email
    self.author.email
  end

  private

  # Assign the source name based on the source assigned to the activity, if any.
  def assign_source_name_from_source
    self.source_name = self.source.filename if self.source.is_a?(Resource)
    self.source_name = self.source.name if self.source.is_a?(Node)
  end

end
