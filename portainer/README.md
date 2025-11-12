# Portainer

Portainer는 Docker 환경을 웹 기반 GUI로 관리할 수 있는 도구입니다.

## 서비스 정보

- **웹 인터페이스**: `http://localhost:${PORTAINER_PORT}`
- **기본 포트**: 9000 (환경 변수로 설정 가능)
- **관리 대상**: Docker 컨테이너, 이미지, 볼륨, 네트워크

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
docker-compose logs -f portainer
```

### 4. 서비스 중지
```bash
docker-compose down
```

## 설정

### 환경 변수

- `PORTAINER_PORT`: Portainer 웹 인터페이스 포트 (기본값: 9000)
- `PORTAINER_ADMIN_PASS`: 관리자 비밀번호 (선택사항, 주석 처리됨)

### 볼륨

- `/var/run/docker.sock`: Docker 소켓 마운트 (필수)
- `portainer_data`: Portainer 설정 및 데이터 저장소

### 포트

- `${PORTAINER_PORT}:9000`: 웹 인터페이스 포트

## 사용법

### 1. 초기 설정
1. 브라우저에서 `http://localhost:${PORTAINER_PORT}`에 접속
2. 관리자 계정 생성 (사용자명과 비밀번호 설정)
3. 로컬 Docker 환경 선택

### 2. 주요 기능

#### 컨테이너 관리
- **컨테이너 목록**: 모든 컨테이너 상태 확인
- **컨테이너 시작/중지**: 개별 컨테이너 제어
- **컨테이너 로그**: 실시간 로그 확인
- **컨테이너 콘솔**: 터미널 접속
- **컨테이너 설정**: 환경 변수, 포트, 볼륨 설정

#### 이미지 관리
- **이미지 목록**: 로컬 Docker 이미지 확인
- **이미지 풀**: Docker Hub에서 이미지 다운로드
- **이미지 빌드**: Dockerfile로 이미지 빌드
- **이미지 삭제**: 불필요한 이미지 정리

#### 볼륨 관리
- **볼륨 목록**: Docker 볼륨 확인
- **볼륨 생성**: 새 볼륨 생성
- **볼륨 삭제**: 불필요한 볼륨 정리

#### 네트워크 관리
- **네트워크 목록**: Docker 네트워크 확인
- **네트워크 생성**: 커스텀 네트워크 생성
- **네트워크 설정**: 네트워크 구성 관리

### 3. 고급 기능

#### 스택 관리
- **Docker Compose 스택**: YAML 파일로 스택 배포
- **스택 편집**: 웹 인터페이스에서 스택 수정
- **스택 롤백**: 이전 버전으로 복원

#### 사용자 관리
- **사용자 생성**: 추가 관리자 계정 생성
- **권한 설정**: 사용자별 권한 관리
- **팀 관리**: 팀 단위 권한 관리

## 보안 고려사항

1. **Docker 소켓 접근**: Portainer는 Docker 소켓에 접근하므로 보안에 주의하세요.
2. **강력한 비밀번호**: 관리자 계정에 강력한 비밀번호를 설정하세요.
3. **HTTPS 사용**: 프로덕션 환경에서는 HTTPS를 사용하세요.
4. **방화벽 설정**: 필요한 포트만 외부에 노출하세요.
5. **정기 업데이트**: Portainer를 정기적으로 업데이트하세요.

## 문제 해결

### 서비스가 시작되지 않는 경우
```bash
# Docker 소켓 권한 확인
ls -la /var/run/docker.sock

# 로그 확인
docker-compose logs portainer

# 포트 충돌 확인
netstat -tulpn | grep :${PORTAINER_PORT}
```

### 웹 인터페이스에 접속할 수 없는 경우
1. 브라우저 캐시를 지우고 다시 시도하세요.
2. 다른 브라우저로 접속해보세요.
3. 방화벽 설정을 확인하세요.

### 로그인 문제
1. 관리자 계정 정보를 확인하세요.
2. 비밀번호를 재설정하세요.
3. 데이터베이스를 초기화하세요.

### 성능 문제
1. 시스템 리소스 사용량을 확인하세요.
2. 불필요한 컨테이너를 정리하세요.
3. Docker 데몬 설정을 최적화하세요.

## 고급 설정

### 관리자 비밀번호 설정
```yaml
# docker-compose.yaml에서 주석 해제
environment:
  - ADMIN_PASS=${PORTAINER_ADMIN_PASS}
```

### SSL/TLS 설정
```yaml
# docker-compose.yaml에 추가
volumes:
  - /var/run/docker.sock:/var/run/docker.sock
  - portainer_data:/data
  - ./certs:/certs  # SSL 인증서
environment:
  - SSL_CERT_FILE=/certs/cert.pem
  - SSL_KEY_FILE=/certs/key.pem
```

### 백업 설정
```bash
# Portainer 데이터 백업
docker run --rm -v portainer_data:/data -v $(pwd):/backup alpine tar czf /backup/portainer_backup.tar.gz -C /data .

# Portainer 데이터 복원
docker run --rm -v portainer_data:/data -v $(pwd):/backup alpine tar xzf /backup/portainer_backup.tar.gz -C /data
```

## 모니터링

### 상태 모니터링
```bash
#!/bin/bash
# Portainer 상태 확인 스크립트
if ! curl -f http://localhost:${PORTAINER_PORT} > /dev/null 2>&1; then
    echo "Portainer가 응답하지 않습니다. 재시작합니다."
    docker-compose restart portainer
fi
```

### 로그 모니터링
```bash
# 실시간 로그 모니터링
docker-compose logs -f portainer | grep -E "(error|warning|failed)"
```

## 참고 자료

- [Portainer 공식 문서](https://docs.portainer.io/)
- [Portainer GitHub](https://github.com/portainer/portainer)
- [Portainer Docker Hub](https://hub.docker.com/r/portainer/portainer-ce)
