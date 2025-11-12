# Dozzle

Dozzle은 Docker 컨테이너의 실시간 로그를 웹 브라우저에서 확인할 수 있는 도구입니다.

## 서비스 정보

- **웹 인터페이스**: `http://localhost:${DOZZLE_PORT}`
- **기본 포트**: 8080 (환경 변수로 설정 가능)

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
docker-compose logs -f dozzle
```

### 4. 서비스 중지
```bash
docker-compose down
```

## 설정

### 환경 변수

- `DOZZLE_PORT`: Dozzle 웹 인터페이스 포트 (기본값: 8080)

### 볼륨

- `/var/run/docker.sock`: Docker 소켓 마운트 (필수)

### 포트

- `${DOZZLE_PORT}:8080`: 웹 인터페이스 포트

## 사용법

### 1. 웹 인터페이스 접속
브라우저에서 `http://localhost:${DOZZLE_PORT}`에 접속하여 Docker 컨테이너들의 로그를 실시간으로 확인할 수 있습니다.

### 2. 주요 기능

- **실시간 로그 스트리밍**: 모든 컨테이너의 로그를 실시간으로 확인
- **로그 검색**: 특정 컨테이너나 로그 내용으로 필터링
- **로그 레벨별 색상 구분**: INFO, WARN, ERROR 등 로그 레벨별 색상 표시
- **컨테이너 정보**: CPU, 메모리 사용량 등 컨테이너 상태 정보

### 3. 키보드 단축키

- `Ctrl + F`: 로그 검색
- `Ctrl + L`: 로그 지우기
- `Ctrl + R`: 로그 새로고침

## 보안 고려사항

1. **Docker 소켓 접근**: Dozzle은 Docker 소켓에 접근하므로 보안에 주의하세요.
2. **네트워크 접근 제한**: 필요한 경우 방화벽을 설정하여 접근을 제한하세요.
3. **인증**: 프로덕션 환경에서는 프록시 서버를 통해 인증을 추가하는 것을 권장합니다.

## 문제 해결

### 서비스가 시작되지 않는 경우
```bash
# Docker 소켓 권한 확인
ls -la /var/run/docker.sock

# 로그 확인
docker-compose logs dozzle
```

### 포트 충돌이 발생하는 경우
환경 변수 파일에서 `DOZZLE_PORT`를 다른 포트로 변경하세요:
```bash
export DOZZLE_PORT=8081
```

## 참고 자료

- [Dozzle GitHub](https://github.com/amir20/dozzle)
- [Dozzle Docker Hub](https://hub.docker.com/r/amir20/dozzle)
