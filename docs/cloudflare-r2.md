# Cloudflare R2 for uploaded media

Production Active Storage uses the `cloudflare_r2` service. Development and test continue to use local disk storage.

Create an R2 bucket, then create an R2 S3 API token scoped to that bucket with Object Read & Write permissions. Configure these variables in the production app environment:

- `CLOUDFLARE_R2_ACCOUNT_ID`
- `CLOUDFLARE_R2_ACCESS_KEY_ID`
- `CLOUDFLARE_R2_SECRET_ACCESS_KEY`
- `CLOUDFLARE_R2_BUCKET`

The S3 endpoint is built from the account ID as `https://<account-id>.r2.cloudflarestorage.com`; the SDK region is `auto`.
The S3 client calculates request checksums only when required, avoiding incompatible multiple checksum headers on R2 uploads.

For the Dokku app named `bola5`, set the variables with `dokku config:set bola5` and provide their values through the server's secure shell. Do not put credentials in this repository, a command history, or chat. For Kamal, add the same four variable names and values to `.kamal/secrets`.

Once the app has the R2 credentials and can still read its current storage volume, run this one-off task to copy existing Active Storage files and switch their blob records to R2:

```sh
dokku run bola5 bin/rails active_storage:migrate_to_cloudflare_r2
```

The task can be rerun: blobs already marked `cloudflare_r2` are skipped. Existing external athlete photo URLs continue to work; new athlete photo uploads and partner logos are stored as Active Storage files.
