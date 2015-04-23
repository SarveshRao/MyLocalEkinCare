AssetSync.configure do |config|
  config.fog_provider = 'AWS'
  config.aws_access_key_id = ENV['AWS_S3_KEY_ID']
  config.aws_secret_access_key = ENV['AWS_S3_ACCESS_KEY']
  # To use AWS reduced redundancy storage.
  # config.aws_reduced_redundancy = true
  config.fog_directory = ENV['AWS_S3_BUCKET_NAME']

  # Invalidate a file on a cdn after uploading files
  # config.cdn_distribution_id = "12345"
  # config.invalidate = ['file1.js']

  Fog.credentials = { path_style: true }

  # Increase upload performance by configuring your region
  config.fog_region = 'ap-southeast-1'

  config.enabled = false
  #
  # Don't delete files from the store
  # config.existing_remote_files = "keep"
  #
  # Automatically replace files with their equivalent gzip compressed version
  # config.gzip_compression = true
  #
  # Use the Rails generated 'manifest.yml' file to produce the list of files to
  # upload instead of searching the assets directory.
  # config.manifest = true
  #
  # Fail silently.  Useful for environments such as Heroku
  # config.fail_silently = true
end
