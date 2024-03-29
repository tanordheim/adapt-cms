if Rails.env.development?

  CarrierWave.configure do |config|
    config.storage = :file
  end

elsif Rails.env.test? || Rails.env.cucumber?

  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end

elsif Rails.env.production?

  CarrierWave.configure do |config|
    config.storage = :fog
    config.fog_credentials = {
      :provider =>            'Rackspace',
      :rackspace_username =>  '',
      :rackspace_api_key =>   '',
      :rackspace_auth_url =>  '',
      :rackspace_servicenet => true
    }
    config.fog_directory = 'adapt-prod'
    config.fog_host = ''
  end

end
