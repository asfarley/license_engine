# encoding: utf-8

##
# Backup Generated: production_backup
# Once configured, you can run the backup with the following command:
#
# $ backup perform -t production_backup [-c <path_to_configuration_file>]
#
Backup::Model.new(:production_backup, 'Description for production_backup') do
  split_into_chunks_of 250
  compress_with Gzip

  ##
  # MySQL [Database]
  #
  database PostgreSQL  do |db|
    # To dump all databases, set `db.name = :all` (or leave blank)
    db.name               = "vsls_server_production"
    db.username           = "rails"
    db.password           = "vitalsim"
    db.host               = "localhost"
    db.port               = 5432
  end

  ##
  # Store on Amazon S3
  #
  store_with S3 do |s3|
    s3.region = "us-west-2"
    s3.bucket = "vitalsim-backup"
  end

  ##
  # Mail [Notifier]
  #
  notify_by Mail do |mail|
    mail.on_success           = true
    mail.on_warning           = true
    mail.on_failure           = true
  end

end
