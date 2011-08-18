# encoding: utf-8

# Add user stamping to an ActiveRecord model.
module Userstamp

  extend ActiveSupport::Concern

  included do

    # Userstamped models are associated with a creator-admin and an
    # updater-admin.
    belongs_to :creator, :class_name => 'Admin'
    belongs_to :updater, :class_name => 'Admin'

    # Validate that the userstamped model are associated with a creator.
    validates :creator, :presence => true

    # Validate that the userstamped model are associated with an updater.
    validates :updater, :presence => true

  end

end
