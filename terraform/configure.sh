#!/bin/bash
dnf -y install ansible-core
dnf -y install python3.9-pip
pip3.9 install s3cmd
echo "[default]
access_key = UDS3Q87WSNGYQCY9YOD3
access_token = 
add_encoding_exts = 
add_headers = 
bucket_location = US
ca_certs_file = 
cache_file = 
check_ssl_certificate = True
check_ssl_hostname = True
cloudfront_host = cloudfront.amazonaws.com
connection_max_age = 5
connection_pooling = True
content_disposition = 
content_type = 
default_mime_type = binary/octet-stream
delay_updates = False
delete_after = False
delete_after_fetch = False
delete_removed = False
dry_run = False
enable_multipart = True
encoding = UTF-8
encrypt = False
expiry_date = 
expiry_days = 
expiry_prefix = 
follow_symlinks = False
force = False
get_continue = False
gpg_command = /usr/bin/gpg
gpg_decrypt = %(gpg_command)s -d --verbose --no-use-agent --batch --yes --passphrase-fd %(passphrase_fd)s -o %(output_file)s %(input_file)s
gpg_encrypt = %(gpg_command)s -c --verbose --no-use-agent --batch --yes --passphrase-fd %(passphrase_fd)s -o %(output_file)s %(input_file)s
gpg_passphrase = 
guess_mime_type = True
host_base = object.pscloud.io
host_bucket = %(bucket)s.object.pscloud.io
human_readable_sizes = False
invalidate_default_index_on_cf = False
invalidate_default_index_root_on_cf = True
invalidate_on_cf = False
kms_key = 
limit = -1
limitrate = 0
list_allow_unordered = False
list_md5 = False
log_target_prefix = 
long_listing = False
max_delete = -1
mime_type = 
multipart_chunk_size_mb = 15
multipart_copy_chunk_size_mb = 1024
multipart_max_chunks = 10000
preserve_attrs = True
progress_meter = True
proxy_host = 
proxy_port = 0
public_url_use_https = False
put_continue = False
recursive = False
recv_chunk = 65536
reduced_redundancy = False
requester_pays = False
restore_days = 1
restore_priority = Standard
secret_key = qcAOHZsN00saWFYU2lh4oDdmIU4RQ15WMN4dXyBE
send_chunk = 65536
server_side_encryption = False
signature_v2 = False
signurl_use_https = False
simpledb_host = sdb.amazonaws.com
skip_existing = False
socket_timeout = 300
ssl_client_cert_file = 
ssl_client_key_file = 
stats = False
stop_on_error = False
storage_class = 
throttle_max = 100
upload_id = 
urlencoding_mode = normal
use_http_expect = False
use_https = True
use_mime_magic = True
verbosity = WARNING
website_endpoint = http://%(bucket)s.s3-website-%(location)s.amazonaws.com/
website_error = 
website_index = index.html
" > /root/.s3cfg
# There is PRIVATE KEY which is use only in private cloud network.
echo "-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAhHZZp2XxzqnzCMeGNsNRN1o1YtuLmQaTIyPNXwzgbUjzCv/j
/QbvHJk9CLOZPBfpCKMey3WhqEyHvGnuHE842jONouCt+6zSB2qCaKk9AgRSp/Aa
iR4MYb78a94svLwE+YYl8ZoM34TQjbMWoobwkwTQr+1WctGA0/h2bLRbQJ+sfw0e
9VSAwL1yuqWqZWSZ7K8raf8Ck/O9BRtrJxGmyiplJJ1i5FYyvveTZvLNwrd6tu9I
Tp7aTd5EUYXb/GzeiBhWaS/QW3KP2dv49xuKkhgM7Snzv+WjwlMzh+uAa3YsxBPO
JmxxaDxhf+19iWdc3X49rkg/YfV7VbePQy4wgQIDAQABAoIBAET9MuKJqO/++bJH
4LIi9ejDVey/9avkjbuOiQcJONYSWWsQLVj6RIz7jps6lwOCXH+AHajQAjsaaNOL
xFUAOdcDZLBBHrxmnRj5syP5iOnFAJuw5NEnUkGSa/tuQpSlxF2FLbvwhOXhUZGL
ha1uZFvd9Sa7kPvJ+7PqwxsIsEIuZ4lXsgGA1EUhG5nkjw+MqbO7aNegecGFBssp
YpHujoAtyFMOUwNN7Fx+Rt+Sq66r2BxXM8UOKbEd4ODhcrCwdx8NK3BgqYTMOT4W
E3mxbH2AW2KMe5YbBrFut4eJGZfzq6jJKVjsk8Z9NxIeKBDz2UrZ2RYlgp6VTvtZ
Ed0/g/ECgYEAvh2YL05zsmgI2BnpVVtI93oLzTZGG4OT8prX8pasZSwoUlqaC7w/
gHsTUdgs9yw7gRQbZjKH9iCfL4lbt8avjD486j53xvxj0LiNk/WYN8kKF8uWO1nX
JnTPIU0tnDGdCFz/ULTyeNy8JSKz7GoLjwyDC3Y8FRGf2RlGj7i9mm0CgYEAsl3z
157BvhBsqGfPFSzwu3UkcJ8368Q8LZCM0tzQFYilUPNwR0v2RL76YOi9Vrdtm0x6
G0X6U0+MJudkeQUMQtl3YgPh/Dw4wRPqjKNV13CR3qOfLe2Kc8JfGJwxaBtbwkaZ
O5l3p9YNPY/J5ZwpFEJfsKuS/QUpbI+G3eh3IeUCgYABud0O2OR+AynJZHrU1o5U
CNygkVSTnV8zfapmPm30QTFghggOATiGXxeuz4qg99rWcitJgz3uwx8O3G1jvr8L
Q+ljqwuFV/dEBtjqNfma0A1yZ9vGUCt+4uKah8vZNi4ZzFZZEjt9U2u13pnJlLDk
LJXn/bvP6SgNXYhhd6jpBQKBgDoAIS3JWxjyAFNWxlkNbw6WDg5tR+LrweHTMmfT
E/scnx1OvAEDK4a5T3O52u/a39JzMPWzcK4snNd9wQc1ZAJM8uw1dQPvlUj7r/ah
mmVfHp/2NunZZ38zAndfOxWuZ80p5eQiiG1URqPxIOcAO79xweoSMM8EIa9CkMmS
MUMdAoGBAKT6Ay/cA9uiCgNYPBiNsSJHb8F8FvJ6daRrnQ2SpDQ4fj+Y9UO3iiwI
FMgOKU3DitCysc41T3q1BR9pN9hSV8+G+9JehbNfnsRWYkyqWGuw0hvA3U9y9OL7
/7RzNICrP26/HxJKY39J7g05XB4T1u/1H/8hZGnb6fvzGO3axcKn
-----END RSA PRIVATE KEY-----
" > /root/.ssh/id_rsa
chmod 600 /root/.ssh/id_rsa
mkdir -p /root/ansible
/usr/local/bin/s3cmd sync --no-preserve s3://neon-15/ansible.cfg /etc/ansible/
/usr/local/bin/s3cmd sync --no-preserve s3://neon-15/gusevvs /etc/ansible/
/usr/local/bin/s3cmd sync --no-preserve s3://neon-15/hosts /etc/ansible/
/usr/local/bin/s3cmd sync --no-preserve s3://neon-15/main.yml /etc/ansible/
sleep 120
ansible-playbook /etc/ansible/main.yml