class Api::PingController < ApplicationController

  skip_before_filter :assign_site
  skip_before_filter :check_for_maintenance_mode

  def show
    render :text => "Pong: #{Time.now.to_s}"
  end

end
