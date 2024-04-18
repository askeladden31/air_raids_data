#!/bin/bash

mkdir -p /opt/final-project
cd /opt/final-project

echo "Current directory: $(pwd)"

# Install Docker
{
  echo "Starting Docker installation..."
  sudo apt update
  sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
  sudo apt update
  sudo apt install -y docker-ce
  echo "Finished Docker installation."


# Install Git
sudo apt install git -y

# Clone the mage and project repositories
git clone https://github.com/mage-ai/compose-quickstart.git mage-quickstart
git clone https://github.com/askeladden31/air_raids_data.git

# Copy project folder into mage folder
cp -r ./air_raids_data/mage/magic-zoomcamp ./mage-quickstart/magic-zoomcamp

# Create .env
cat <<EOF > ./mage-quickstart/.env
PROJECT_NAME=magic-zoomcamp

GCP_PROJECT=${project}
GCP_REGION=${region}
GCP_LOCATION=${location}
GCP_BUCKET=${gcs_bucket_name}
GCP_DWH=${bq_dwh}
GCP_DEV=${bq_dbt_dev}
GCP_PROD=${bq_dbt_prod}

EOF

# Create credentiials
cat <<EOF > ./mage-quickstart/secrets.json
${credentials}
EOF

cd mage-quickstart
docker compose up -d

} &> /var/log/startup.log
