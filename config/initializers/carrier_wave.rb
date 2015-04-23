require 'carrierwave/orm/activerecord'

CarrierWave.configure do |config|
  if Rails.env.development?
    config.root = File.join(Rails.root, 'public')
    config.storage :file
  else
    config.storage :fog
    config.fog_credentials = {
        :provider => 'AWS',
        :aws_access_key_id => ENV['AWS_S3_KEY_ID'],
        :aws_secret_access_key => ENV['AWS_S3_ACCESS_KEY'],
        :region => 'ap-southeast-1',
        :path_style => true
        #:host => ENV['AWS_S3_BUCKET_NAME']
    }

    config.fog_directory = ENV['AWS_S3_BUCKET_NAME']
    config.fog_public = true
    config.fog_attributes = {'Cache-Control' => 'max-age=315576000'}
    config.asset_host = 'http://' + ENV['AWS_S3_BUCKET_NAME']
  end
end
