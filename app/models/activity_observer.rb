class ActivityObserver < ActiveRecord::Observer
  observe :node, :resource

  # After create callback, creates a 'create'-activity for the resource.
  def after_create(resource)
    add_activity(:create, resource)
  end

  # After update callback, creates an 'update'-activity for the resource.
  def after_update(resource)
    add_activity(:update, resource)
  end

  private

  # Add an activity for the specified source with the specified action.
  def add_activity(action, source)

    site = source.site
    source_type = source.respond_to?(:type) && !source.type.blank? ? source.type : source.class.name
    parent_id = source_type == 'BlogPost' ? source.parent_id : nil

    # If we have a matching activity within the same day for this source and
    # author, increase the count.
    query = Activity.where(:site_id => site.id).where(:author_id => source.updater.id)
    query = query.where(:action => action.to_s).where(:source_type => source_type)
    query = query.where(:source_id => source.id)
    query = query.where(['activities.created_at >= ? AND activities.created_at <= ?', Time.zone.now.beginning_of_day, Time.zone.now.end_of_day])
    query = query.first
    if query.blank?
      Activity.create!(:site => site, :parent_id => parent_id, :source_type => source_type, :source_id => source.id, :author => source.updater, :action => action.to_s)
    else
      query.parent_id = parent_id
      query.count = query.count + 1
      query.save!
    end

  end

end
