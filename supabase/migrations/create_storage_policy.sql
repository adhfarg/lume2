-- Create a stored procedure to set up storage policies
create or replace function create_storage_policy(bucket_name text)
returns void as $$
begin
  -- Enable RLS on storage.objects
  alter table storage.objects enable row level security;

  -- Create policy for authenticated users to upload their own files
  create policy "Users can upload their own files"
  on storage.objects for insert
  to authenticated
  with check (
    bucket_id = bucket_name
    and (storage.foldername(name))[1] = auth.uid()::text
  );

  -- Create policy for authenticated users to read their own files
  create policy "Users can read their own files"
  on storage.objects for select
  to authenticated
  using (
    bucket_id = bucket_name
    and (storage.foldername(name))[1] = auth.uid()::text
  );
end;
$$ language plpgsql security definer;

-- Execute the function to create policies for the health_certifications bucket
select create_storage_policy('health_certifications');

