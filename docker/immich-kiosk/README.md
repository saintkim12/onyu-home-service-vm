# Immich

Immich는 Google Photos와 유사한 자체 호스팅 사진 및 비디오 백업 솔루션입니다.

## 서비스 정보

- **웹 인터페이스**: `http://localhost:${IMMICH_PORT}`
- **Kiosk 모드**: `http://localhost:${IMMICH_KIOSK_PORT}`
- **API 엔드포인트**: `http://localhost:${IMMICH_PORT}/api`

## 시작하기

### 1. 환경 변수 설정
Immich를 시작하기 전에 환경 변수 파일을 설정해야 합니다:

```bash
# .env 파일 생성
cp ../../stack.env .env
```

필수 환경 변수:
- `IMMICH_VERSION`: Immich 버전 (기본값: release)
- `IMMICH_PORT`: 웹 인터페이스 포트
- `IMMICH_KIOSK_PORT`: Kiosk 모드 포트
- `IMMICH_DB_HOSTNAME`: 데이터베이스 호스트명
- `UPLOAD_LOCATION`: 업로드 파일 저장 경로
- `DB_PASSWORD`: PostgreSQL 비밀번호
- `DB_USERNAME`: PostgreSQL 사용자명
- `DB_DATABASE_NAME`: PostgreSQL 데이터베이스명
- `DB_DATA_LOCATION`: 데이터베이스 저장 경로

### 2. 서비스 시작
```bash
docker-compose up -d
```

### 3. 서비스 상태 확인
```bash
docker-compose ps
```

### 4. 로그 확인
```bash
docker-compose logs -f immich-server
```

### 5. 서비스 중지
```bash
docker-compose down
```

## 구성 요소

### 1. Immich Server
- **컨테이너명**: `immich_server`
- **포트**: `${IMMICH_PORT}:2283`
- **기능**: 메인 웹 서버 및 API

### 2. Machine Learning
- **컨테이너명**: `immich_machine_learning`
- **기능**: 얼굴 인식, 객체 감지, AI 기능

### 3. Redis
- **컨테이너명**: `immich_redis`
- **기능**: 캐싱 및 세션 관리

### 4. PostgreSQL
- **컨테이너명**: `immich_postgres`
- **기능**: 메타데이터 및 사용자 데이터 저장

### 5. Kiosk Mode
- **컨테이너명**: `immich_kiosk`
- **포트**: `${IMMICH_KIOSK_PORT}:3000`
- **기능**: 디지털 액자 모드

## 사용법

### 1. 초기 설정
1. 웹 브라우저에서 `http://localhost:${IMMICH_PORT}`에 접속
2. 관리자 계정 생성
3. 사진 업로드 시작

### 2. 모바일 앱
- **Android**: Google Play Store에서 "Immich" 검색
- **iOS**: App Store에서 "Immich" 검색

### 3. 주요 기능
- **자동 백업**: 모바일 앱에서 자동 사진/비디오 백업
- **얼굴 인식**: AI 기반 얼굴 인식 및 그룹화
- **객체 감지**: 사진 내 객체 자동 태깅
- **지도 보기**: GPS 데이터 기반 지도 표시
- **공유 앨범**: 가족/친구와 사진 공유
- **웹 인터페이스**: 브라우저에서 사진 관리

## 설정

### 하드웨어 가속화 (선택사항)

#### GPU 가속화 (NVIDIA)
```yaml
# docker-compose.yaml에서 주석 해제
extends:
  file: hwaccel.transcoding.yml
  service: nvenc  # 또는 cuda
```

#### CPU 가속화
```yaml
extends:
  file: hwaccel.transcoding.yml
  service: cpu
```

### 백업 설정
- **업로드 위치**: `${UPLOAD_LOCATION}` 환경 변수로 설정
- **데이터베이스**: `${DB_DATA_LOCATION}` 환경 변수로 설정

## 보안 고려사항

1. **기본 인증**: 초기 설정 후 강력한 비밀번호 설정
2. **네트워크 보안**: 외부 접근 시 HTTPS 사용 권장
3. **데이터 백업**: 정기적인 데이터베이스 및 업로드 폴더 백업
4. **방화벽 설정**: 필요한 포트만 외부에 노출

## 문제 해결

### 서비스가 시작되지 않는 경우
```bash
# 모든 서비스 로그 확인
docker-compose logs

# 특정 서비스 로그 확인
docker-compose logs immich-server
docker-compose logs immich-database
```

### 데이터베이스 연결 오류
1. PostgreSQL 컨테이너 상태 확인
2. 환경 변수 설정 확인
3. 데이터베이스 볼륨 권한 확인

### 업로드 실패
1. 업로드 폴더 권한 확인
2. 디스크 공간 확인
3. 네트워크 연결 확인

### 성능 문제
1. 하드웨어 가속화 설정 확인
2. 시스템 리소스 사용량 확인
3. 데이터베이스 인덱스 최적화

## 백업 및 복원

### 데이터 백업
```bash
# 데이터베이스 백업
docker-compose exec immich-database pg_dump -U $DB_USERNAME $DB_DATABASE_NAME > backup.sql

# 업로드 폴더 백업
tar -czf uploads_backup.tar.gz $UPLOAD_LOCATION
```

### 데이터 복원
```bash
# 데이터베이스 복원
docker-compose exec -T immich-database psql -U $DB_USERNAME $DB_DATABASE_NAME < backup.sql

# 업로드 폴더 복원
tar -xzf uploads_backup.tar.gz
```

## 참고 자료

- [Immich 공식 문서](https://immich.app/docs/)
- [Immich GitHub](https://github.com/immich-app/immich)
- [Immich 설치 가이드](https://immich.app/docs/install/docker-compose) 