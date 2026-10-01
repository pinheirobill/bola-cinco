namespace :active_storage do
  desc "Copy existing Active Storage blobs to Cloudflare R2 and update their service"
  task migrate_to_cloudflare_r2: :environment do
    target_service = ActiveStorage::Blob.services.fetch("cloudflare_r2")
    blobs = ActiveStorage::Blob.where.not(service_name: "cloudflare_r2")
    total = blobs.count

    puts "Migrating #{total} Active Storage blob(s) to Cloudflare R2..."

    blobs.find_each.with_index(1) do |blob, index|
      blob.open do |file|
        target_service.upload(
          blob.key,
          file,
          checksum: blob.checksum,
          content_type: blob.content_type,
          disposition: blob.content_disposition,
          filename: blob.filename,
          custom_metadata: blob.custom_metadata
        )
      end

      blob.update!(service_name: "cloudflare_r2")
      puts "Migrated #{index}/#{total} blob(s)" if (index % 25).zero? || index == total
    end

    puts "Cloudflare R2 migration complete."
  end
end
