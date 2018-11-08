CarrierWave.configure do |config|
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: ENV["S3_IAM_ACCESS_KEY"],
    aws_secret_access_key: ENV["S3_IAM_SECRET_KEY"],
    region: ENV['AWS_REGION']
  }

  config.fog_directory  = 'rootedlearning'
  config.cache_storage = :fog
end

