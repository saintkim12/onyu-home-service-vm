# Watchtower

Watchtower는 Docker 컨테이너를 자동으로 최신 버전으로 업데이트하는 도구입니다.

## 서비스 정보

- **서비스 유형**: 컨테이너 자동 업데이트
- **업데이트 주기**: 기본 24시간마다
- **시간대**: Asia/Seoul

## 시작하기

### 1. 서비스 시작
```bash
docker-compose up -d
```

### 2. 서비스 상태 확인
```bash
docker-compose ps
```

### 3. 로그 확인
```bash
docker-compose logs -f watchtower
```

### 4. 서비스 중지
```bash
docker-compose down
```

## 설정

### 환경 변수

- `TZ`: 시간대 설정 (기본값: Asia/Seoul)

### 볼륨

- `/var/run/docker.sock`: Docker 소켓 마운트 (필수)

### 기본 동작

- **업데이트 주기**: 24시간마다
- **업데이트 방식**: 새로운 이미지가 있으면 자동으로 컨테이너 재시작
- **로그 보존**: 업데이트 후 이전 컨테이너 로그 보존

## 사용법

### 1. 모든 컨테이너 자동 업데이트
기본 설정으로 실행하면 모든 컨테이너가 자동으로 업데이트됩니다.

### 2. 특정 컨테이너만 업데이트
```bash
# 특정 컨테이너만 업데이트하려면 라벨 추가
docker run -d \
  --name watchtower \
  -v /var/run/docker.sock:/var/run/docker.sock \
  containrrr/watchtower \
  --label-enable \
  container1 container2
```

### 3. 수동 업데이트 실행
```bash
# 특정 컨테이너 수동 업데이트
docker-compose exec watchtower watchtower --run-once container_name
```

## 고급 설정

### 업데이트 주기 변경
```yaml
# docker-compose.yaml 수정
services:
  watchtower:
    image: containrrr/watchtower
    container_name: watchtower
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - TZ=Asia/Seoul
    command: --interval 3600  # 1시간마다 업데이트
    restart: unless-stopped
```

### 특정 컨테이너만 업데이트
```yaml
# docker-compose.yaml 수정
services:
  watchtower:
    image: containrrr/watchtower
    container_name: watchtower
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - TZ=Asia/Seoul
    command: --label-enable container1 container2
    restart: unless-stopped
```

### 업데이트 알림 설정
```yaml
# docker-compose.yaml 수정
services:
  watchtower:
    image: containrrr/watchtower
    container_name: watchtower
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - TZ=Asia/Seoul
      - WATCHTOWER_NOTIFICATIONS=email
      - WATCHTOWER_NOTIFICATION_EMAIL_FROM=watchtower@example.com
      - WATCHTOWER_NOTIFICATION_EMAIL_TO=admin@example.com
      - WATCHTOWER_NOTIFICATION_EMAIL_SERVER=smtp.gmail.com
      - WATCHTOWER_NOTIFICATION_EMAIL_SERVER_PORT=587
      - WATCHTOWER_NOTIFICATION_EMAIL_SERVER_USER=your_email@gmail.com
      - WATCHTOWER_NOTIFICATION_EMAIL_SERVER_PASSWORD=your_password
    restart: unless-stopped
```

## 보안 고려사항

1. **Docker 소켓 접근**: Watchtower는 Docker 소켓에 접근하므로 보안에 주의하세요.
2. **업데이트 검증**: 중요한 서비스는 업데이트 전 백업을 권장합니다.
3. **네트워크 보안**: 외부 접근을 제한하고 내부 네트워크에서만 실행하세요.
4. **로그 모니터링**: 업데이트 로그를 정기적으로 확인하세요.

## 문제 해결

### 서비스가 시작되지 않는 경우
```bash
# Docker 소켓 권한 확인
ls -la /var/run/docker.sock

# 로그 확인
docker-compose logs watchtower
```

### 업데이트가 되지 않는 경우
```bash
# 수동 업데이트 테스트
docker-compose exec watchtower watchtower --run-once --debug

# 이미지 태그 확인
docker images
```

### 업데이트 후 서비스가 작동하지 않는 경우
```bash
# 이전 컨테이너 확인
docker ps -a

# 이전 버전으로 롤백
docker tag image:previous image:latest
docker-compose up -d
```

## 모니터링

### 업데이트 로그 모니터링
```bash
# 실시간 업데이트 로그 확인
docker-compose logs -f watchtower | grep -E "(updating|updated|error)"

# 업데이트 이력 확인
docker-compose logs watchtower | grep "updating"
```

### 상태 확인 스크립트
```bash
#!/bin/bash
# Watchtower 상태 확인 스크립트
if ! docker-compose ps watchtower | grep -q "Up"; then
    echo "Watchtower가 중지되었습니다. 재시작합니다."
    docker-compose restart watchtower
fi
```

## 고급 옵션

### 주요 명령행 옵션

- `--interval`: 업데이트 주기 설정 (초 단위)
- `--schedule`: cron 스타일 스케줄 설정
- `--label-enable`: 라벨이 있는 컨테이너만 업데이트
- `--run-once`: 한 번만 실행하고 종료
- `--cleanup`: 업데이트 후 이전 이미지 삭제
- `--include-stopped`: 중지된 컨테이너도 업데이트
- `--revive-stopped`: 업데이트 후 중지된 컨테이너 재시작

### 예시 설정
```yaml
# 매일 새벽 2시에 업데이트
command: --schedule "0 0 2 * * *"

# 6시간마다 업데이트하고 이전 이미지 정리
command: --interval 21600 --cleanup

# 특정 컨테이너만 업데이트하고 알림
command: --label-enable --notifications=email container1 container2
```

## 참고 자료

- [Watchtower GitHub](https://github.com/containrrr/watchtower)
- [Watchtower Docker Hub](https://hub.docker.com/r/containrrr/watchtower)
- [Watchtower 문서](https://containrrr.dev/watchtower/)
