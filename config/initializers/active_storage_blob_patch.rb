# config/initializers/active_storage_blob_patch.rb
ActiveSupport.on_load(:active_storage_blob) do
  unless instance_methods.include?(:download_to_tempfile)
    require 'tempfile'

    class ActiveStorage::Blob
      def download_to_tempfile
        tempfile = Tempfile.new([filename.base, filename.extension_with_delimiter], binmode: true)
        download { |chunk| tempfile.write(chunk) }
        tempfile.rewind
        tempfile
      end
    end
  end
end