
wget https://dl.min.io/server/minio/release/linux-amd64/minio


chmod +x minio
MINIO_ROOT_USER=admin MINIO_ROOT_PASSWORD=todaygood ./minio server /mnt/data --console-address ":9001"

wget https://dl.min.io/client/mc/release/linux-amd64/mc


chmod +x mc
mc alias set myminio/ http://MINIO-SERVER admin todaygood

