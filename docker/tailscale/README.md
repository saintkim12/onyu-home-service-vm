# Tailscale

Tailscale은 WireGuard 기반의 VPN 서비스로, 안전하고 간편한 네트워크 연결을 제공합니다.

## 서비스 정보

- **서비스 유형**: VPN (WireGuard 기반)
- **네트워크 모드**: Host
- **인증 방식**: Tailscale 인증 키

## 시작하기

### 1. Tailscale 계정 설정
1. [Tailscale 웹사이트](https://tailscale.com/)에서 계정을 생성합니다.
2. 관리자 패널에서 인증 키를 생성합니다.

### 2. 환경 변수 설정
```bash
export TAILSCALE_AUTHKEY=your_tailscale_auth_key_here
```

### 3. 서비스 시작
```bash
docker-compose up -d
```

### 4. 서비스 상태 확인
```bash
docker-compose ps
```

### 5. 로그 확인
```bash
docker-compose logs -f tailscale
```

### 6. 서비스 중지
```bash
docker-compose down
```

## 설정

### 환경 변수

- `TAILSCALE_AUTHKEY`: Tailscale 인증 키 (필수)

### 볼륨

- `tailscale_data`: Tailscale 설정 및 상태 데이터
- `/dev/net/tun`: TUN 디바이스 (네트워크 인터페이스)

### 네트워크 설정

- **네트워크 모드**: `host` (호스트 네트워크 사용)
- **필요한 권한**: `NET_ADMIN`, `NET_RAW`

## 사용법

### 1. 연결 상태 확인
```bash
# 컨테이너 내부에서 Tailscale 상태 확인
docker-compose exec tailscale tailscale status
```

### 2. 네트워크 정보 확인
```bash
# Tailscale IP 주소 확인
docker-compose exec tailscale tailscale ip
```

### 3. 다른 Tailscale 노드에 접속
```bash
# 특정 노드에 ping 테스트
docker-compose exec tailscale ping [tailscale-ip]
```

### 4. 서비스 공유
Tailscale을 통해 다른 서비스들을 안전하게 공유할 수 있습니다:
- 웹 서버
- SSH 서버
- 데이터베이스
- 파일 공유 서비스

## 보안 고려사항

1. **인증 키 보안**: Tailscale 인증 키를 안전하게 보관하세요.
2. **네트워크 권한**: 컨테이너가 호스트 네트워크에 접근하므로 주의하세요.
3. **방화벽 설정**: Tailscale 트래픽을 허용하도록 방화벽을 설정하세요.
4. **정기 업데이트**: Tailscale 클라이언트를 정기적으로 업데이트하세요.

## 문제 해결

### 서비스가 시작되지 않는 경우
```bash
# 로그 확인
docker-compose logs tailscale

# TUN 디바이스 확인
ls -la /dev/net/tun

# 네트워크 권한 확인
docker-compose exec tailscale ip link show
```

### 인증 실패
1. Tailscale 인증 키가 올바른지 확인
2. Tailscale 관리자 패널에서 키 상태 확인
3. 환경 변수가 올바르게 설정되었는지 확인

### 네트워크 연결 문제
```bash
# Tailscale 상태 확인
docker-compose exec tailscale tailscale status

# 네트워크 인터페이스 확인
docker-compose exec tailscale ip addr show

# 라우팅 테이블 확인
docker-compose exec tailscale ip route show
```

### 성능 문제
1. 호스트 시스템의 네트워크 성능 확인
2. Tailscale 노드 간 거리 및 네트워크 품질 확인
3. 시스템 리소스 사용량 확인

## 고급 설정

### 커스텀 네트워크 설정
```yaml
# docker-compose.yaml에 추가
environment:
  - TS_AUTHKEY=${TAILSCALE_AUTHKEY}
  - TS_ROUTES=192.168.1.0/24  # 커스텀 라우트
  - TS_EXTRA_ARGS=--advertise-tags=tag:server  # 태그 설정
```

### 자동 업데이트 설정
```yaml
# docker-compose.yaml에 추가
environment:
  - TS_AUTHKEY=${TAILSCALE_AUTHKEY}
  - TS_EXTRA_ARGS=--update-url=https://update.tailscale.com
```

### 로그 레벨 설정
```yaml
# docker-compose.yaml에 추가
environment:
  - TS_AUTHKEY=${TAILSCALE_AUTHKEY}
  - TS_EXTRA_ARGS=--verbose=1
```

## 모니터링

### 상태 모니터링
```bash
# 정기적인 상태 확인 스크립트
#!/bin/bash
if ! docker-compose exec tailscale tailscale status > /dev/null 2>&1; then
    echo "Tailscale 연결이 끊어졌습니다. 재시작합니다."
    docker-compose restart tailscale
fi
```

### 로그 모니터링
```bash
# 실시간 로그 모니터링
docker-compose logs -f tailscale | grep -E "(error|warning|connected|disconnected)"
```

## 참고 자료

- [Tailscale 공식 문서](https://tailscale.com/kb/)
- [Tailscale Docker Hub](https://hub.docker.com/r/tailscale/tailscale)
- [WireGuard 프로토콜](https://www.wireguard.com/)
