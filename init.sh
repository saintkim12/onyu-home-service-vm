#!/bin/sh
set -e

GIT_USER=saintkim12
GIT_REPO=onyu-home-service-vm
GIT_BRANCH=main
GIT_URL=https://github.com/${GIT_USER}/${GIT_REPO}.git
SERVICE_VM_DIR=/opt/setup/service-vm
YOUR_SERVER_IP='<your-server-ip>'

mkdir -p /opt/setup
cd /opt/setup

### [1] Alpine 패키지 및 Docker, rclone 설치
echo "📦 Installing Docker..."
apk update
# apk add --no-cache docker docker-compose git curl openrc rsync rclone fuse3
apk add --no-cache docker docker-compose git curl openrc rsync

### [2] rclone 초기화
# echo fuse >> /etc/modules # fuse 등록: modprobe fuse

### [3] docker 초기화
echo "🔌 Enabling docker service..."
rc-update add docker boot
service docker start

echo "📥 Cloning Git repository..."

### [4] Git 저장소 클론
if [ ! -d "$SERVICE_VM_DIR" ]; then
  git clone -b "$GIT_BRANCH" "$GIT_URL" "$SERVICE_VM_DIR"
else
  echo "📦 Repo exists, pulling latest..."
  cd "$SERVICE_VM_DIR" && git pull && cd ..
fi

### [5] 메인 디렉토리로 이동
cd "$SERVICE_VM_DIR"

### [6] rclone 서비스 등록
# cp rclone.conf ~/.config/rclone/rclone.conf # rclone.conf 파일 변경 필요!(key)
# cp rclone.start /etc/local.d/rclone.start
# chmod +x /etc/local.d/rclone.start
# rc-update add local

### [7] Portainer Docker 컨테이너 실행
echo "🚀 Starting Portainer..."
cd portainer
export PORTAINER_PORT=8100
docker-compose up -d

echo "✅ Portainer started on :$PORTAINER_PORT"
echo "👉 Access at: http://$YOUR_SERVER_IP:$PORTAINER_PORT"

echo ""
echo "📝 Next Step:"
echo "1. Open Portainer UI"
echo "2. Set Stack and Run Container"
