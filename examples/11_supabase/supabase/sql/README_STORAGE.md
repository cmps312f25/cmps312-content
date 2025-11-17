# Supabase Storage Setup for Pet Images

## Overview
This guide explains how to set up Supabase Storage to handle pet image uploads.

## Storage Bucket Setup

### 1. Create the 'pets' Bucket

In your Supabase Dashboard:
1. Go to **Storage** in the left sidebar
2. Click **New bucket**
3. Configure the bucket:
   - **Name**: `pets`
   - **Public bucket**: ✅ Enable (to allow public access to images)
   - **File size limit**: 5 MB (recommended)
   - **Allowed MIME types**: `image/jpeg`, `image/png`, `image/jpg`
4. Click **Create bucket**

### 2. Set Up Storage Policies

By default, storage buckets are private. You need to create policies to allow operations.

#### Option A: Public Read Access (Recommended for Development)

Go to **Storage** → **Policies** and create the following policies:

**Policy 1: Allow Public Read**
```sql
CREATE POLICY "Public read access"
ON storage.objects FOR SELECT
USING (bucket_id = 'pets');
```

**Policy 2: Allow Authenticated Users to Upload**
```sql
CREATE POLICY "Authenticated users can upload"
ON storage.objects FOR INSERT
WITH CHECK (
  bucket_id = 'pets' 
  AND auth.role() = 'authenticated'
);
```

**Policy 3: Allow Authenticated Users to Update**
```sql
CREATE POLICY "Authenticated users can update"
ON storage.objects FOR UPDATE
USING (
  bucket_id = 'pets' 
  AND auth.role() = 'authenticated'
);
```

**Policy 4: Allow Authenticated Users to Delete**
```sql
CREATE POLICY "Authenticated users can delete"
ON storage.objects FOR DELETE
USING (
  bucket_id = 'pets' 
  AND auth.role() = 'authenticated'
);
```

#### Option B: User-Specific Access (Recommended for Production)

For production, you may want users to only manage their own pet images:

```sql
-- Allow users to upload their own pet images
CREATE POLICY "Users can upload their pet images"
ON storage.objects FOR INSERT
WITH CHECK (
  bucket_id = 'pets' 
  AND auth.role() = 'authenticated'
  AND (storage.foldername(name))[1] = 'images'
);

-- Allow users to delete their own pet images
CREATE POLICY "Users can delete their pet images"
ON storage.objects FOR DELETE
USING (
  bucket_id = 'pets' 
  AND auth.role() = 'authenticated'
);

-- Public read access (everyone can view)
CREATE POLICY "Public read access"
ON storage.objects FOR SELECT
USING (bucket_id = 'pets');
```

### 3. Folder Structure

The application stores images in the following structure:
```
pets/
└── images/
    ├── pet_1_1234567890.jpg
    ├── pet_2_1234567891.jpg
    └── pet_3_1234567892.jpg
```

Format: `images/pet_{petId}_{timestamp}.{extension}`

## Testing Storage Setup

After setting up the bucket and policies, test the setup:

### 1. Test Upload via Supabase Dashboard
1. Go to **Storage** → **pets** bucket
2. Click **Upload file**
3. Upload a test image to the `images/` folder
4. Verify the upload succeeded

### 2. Test Public Access
1. Click on the uploaded image
2. Copy the **Public URL**
3. Open the URL in a browser
4. Verify the image displays correctly

### 3. Test from the App
1. Run the Flutter app
2. Navigate to the Pets screen
3. Select an owner
4. Click the camera icon on a pet card
5. Select an image from your device
6. Verify the image uploads and displays

## Troubleshooting

### Issue: "new row violates row-level security policy"
**Solution**: Ensure RLS policies are created for the storage bucket.

### Issue: "Failed to upload: 403 Forbidden"
**Solution**: Check that:
- The bucket is public OR appropriate policies exist
- User is authenticated (for authenticated-only policies)
- Policies allow INSERT operations

### Issue: Image doesn't display
**Solution**: 
- Verify the bucket is marked as **Public**
- Check the image URL is correct
- Ensure the image was uploaded successfully in Supabase Dashboard

### Issue: "Bucket not found"
**Solution**: 
- Verify the bucket name is exactly `pets` (case-sensitive)
- Check the bucket exists in the Supabase Dashboard

## Storage Limits

Supabase Free Tier:
- **Storage**: 1 GB
- **File uploads**: 50 MB per file (by default)
- **Bandwidth**: 2 GB per month

For production apps with many images, consider:
- Upgrading to Supabase Pro
- Implementing image compression
- Setting file size limits
- Cleaning up old/unused images

## Security Best Practices

1. **File Size Limits**: Set maximum file sizes in the bucket configuration
2. **MIME Type Validation**: Restrict allowed file types to images only
3. **User Ownership**: Implement policies that ensure users can only manage their own uploads
4. **Malware Scanning**: Consider implementing virus scanning for uploaded files
5. **CDN Caching**: Use Supabase CDN for better performance and reduced bandwidth

## Image Optimization

For better performance, the app automatically:
- Limits image dimensions to 800x800 pixels
- Compresses images to 85% quality
- Uses JPEG format for smaller file sizes

You can adjust these settings in the `image_picker` configuration in `pets_list.dart`.

## Migration Notes

If you're migrating an existing app:
1. Run migration `006_add_pet_image_path.sql` to add the `image_path` column
2. Set up the storage bucket and policies
3. Optionally migrate existing images to Supabase Storage
4. Update existing pet records with new image paths

## Resources

- [Supabase Storage Documentation](https://supabase.com/docs/guides/storage)
- [Storage RLS Policies](https://supabase.com/docs/guides/storage/security/access-control)
- [Image Optimization Guide](https://supabase.com/docs/guides/storage/serving/image-transformations)
