require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

if Rails.env.production?
  CarrierWave.configure do |config|
    config.storage = :fog
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
        :provider              => 'AWS',
        :aws_access_key_id     => ENV['S3_IAM_ACCESS_KEY'],
        :aws_secret_access_key => ENV['S3_IAM_SECRET_KEY'],
        :region                => ENV['AWS_REGION']
    }

    config.fog_directory = 'quantity-teaches-quality' # バケット名
    config.fog_public = true

  end
else
  CarrierWave.configure do |config|
    config.storage = :file
  end
end
