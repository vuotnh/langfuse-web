# Hướng dẫn Setup Local Langfuse

## ✅ Các Services Đã Dựng

Tất cả các services đã được khởi động thành công:

### 🐘 PostgreSQL
- **URL**: `localhost:5433`
- **User**: `postgres`
- **Password**: `postgres`
- **Database**: `postgres`
- **Status**: ✅ Healthy (442 migrations đã áp dụng)

### 🗄️ ClickHouse
- **HTTP**: `http://localhost:8123`
- **Native**: `localhost:9000`
- **User**: `clickhouse`
- **Password**: `clickhouse`
- **Status**: ✅ Healthy

### 🔴 Redis
- **URL**: `localhost:6379`
- **Password**: `myredissecret`
- **Status**: ✅ Running

### 🪣 MinIO (S3-compatible)
- **API**: `http://localhost:9090`
- **Console**: `http://localhost:9091`
- **User**: `minio`
- **Password**: `miniosecret`
- **Status**: ✅ Healthy
- **Bucket**: `langfuse` (tự động tạo)

## 📋 Các Lệnh Quản Lý Services

### Start services
```powershell
docker compose -f docker-compose.dev.yml up -d
```

### Stop services
```powershell
docker compose -f docker-compose.dev.yml down
```

### Xem logs
```powershell
# Tất cả services
docker compose -f docker-compose.dev.yml logs -f

# Service cụ thể
docker logs -f langfuse-postgres
docker logs -f langfuse-clickhouse
docker logs -f langfuse-redis
docker logs -f langfuse-minio
```

### Kiểm tra status
```powershell
docker compose -f docker-compose.dev.yml ps
```

### Restart service
```powershell
docker compose -f docker-compose.dev.yml restart <service_name>
```

## 🔧 Cài Đặt ClickHouse Migrations (Optional)

ClickHouse migrations cần `golang-migrate` tool:

### Cài đặt golang-migrate:

**Option 1: Chocolatey**
```powershell
choco install golang-migrate
```

**Option 2: Download binary**
1. Tải từ: https://github.com/golang-migrate/migrate/releases
2. Giải nén và thêm vào PATH

### Chạy migrations:
```powershell
cd packages\shared
pnpm run ch:up
```

## 🚀 Chạy Application

### Development Server

```powershell
# Start web app
pnpm --filter web run dev
# App sẽ chạy tại: http://localhost:3000
```

### Build Production

```powershell
pnpm --filter web run build
pnpm --filter web run start
```

### Các lệnh khác

```powershell
# TypeCheck
pnpm --filter web run typecheck

# Lint
pnpm --filter web run lint

# Tests
pnpm --filter web run test
```

## 📁 File Cấu Hình Quan Trọng

- **`.env`** - Environment variables cho application
- **`pnpm-workspace.yaml`** - Workspace configuration
- **`.npmrc`** - NPM/PNPM settings
- **`docker-compose.dev.yml`** - Docker services configuration

## 🔐 Security Notes

⚠️ **QUAN TRỌNG**: File `.env` hiện tại sử dụng giá trị mặc định cho dev.

Trước khi deploy production, hãy thay đổi:
- `NEXTAUTH_SECRET` - Generate: `openssl rand -base64 32`
- `SALT` - Dùng salt khác
- `ENCRYPTION_KEY` - Generate: `openssl rand -hex 32`
- Tất cả passwords của databases

## 🛠️ Troubleshooting

### Port đã được sử dụng
Nếu gặp lỗi port conflict, sửa trong file `.env`:
```env
POSTGRES_HOST_PORT=5433  # Đổi sang port khác
REDIS_HOST_PORT=6379
CLICKHOUSE_HTTP_PORT=8123
MINIO_API_PORT=9090
```

### Database connection failed
Kiểm tra services đang chạy:
```powershell
docker ps
```

Restart services nếu cần:
```powershell
docker compose -f docker-compose.dev.yml restart
```

### Xóa toàn bộ và bắt đầu lại
```powershell
# Stop và xóa containers + volumes
docker compose -f docker-compose.dev.yml down -v

# Start lại
docker compose -f docker-compose.dev.yml up -d

# Chạy lại migrations
cd packages\shared
pnpm exec dotenv -e ../../.env -- npx prisma migrate deploy
```

## 🌐 Access URLs

Sau khi start application:

- **Web App**: http://localhost:3000
- **MinIO Console**: http://localhost:9091
- **ClickHouse**: http://localhost:8123/play (UI để query)

## 📚 Tài Liệu Thêm

- [Langfuse Documentation](https://langfuse.com/docs)
- [Docker Compose Docs](https://docs.docker.com/compose/)
- [Prisma Docs](https://www.prisma.io/docs/)
