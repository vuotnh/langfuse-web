# Hướng Dẫn Setup Manual - Không Dùng Scripts

Tài liệu này hướng dẫn setup Langfuse Web **từng bước thủ công** khi không thể chạy PowerShell hoặc Bash scripts.

## Khi Nào Dùng Hướng Dẫn Này?

- ❌ Không thể chạy PowerShell scripts (Windows bị hạn chế)
- ❌ Không thể chạy Bash scripts (permissions bị chặn)
- ✅ Muốn hiểu rõ từng bước đang làm gì
- ✅ Troubleshooting từng bước cụ thể

## Prerequisites

Đảm bảo đã cài đặt:
- ✅ Node.js 24.x
- ✅ pnpm
- ✅ Docker Desktop (đang chạy)
- ✅ Git

Kiểm tra:
```bash
node --version    # Should show v24.x.x
pnpm --version    # Should show version
docker --version  # Should show version
git --version     # Should show version
```

---

## Bước 1: Clone Repository

```bash
# Terminal/Command Prompt
cd langfuse-web
```

---

## Bước 2: Setup Environment Variables

### Windows (Command Prompt)
```cmd
copy .env.dev.example .env
notepad .env
```

### Linux/Mac/WSL
```bash
cp .env.dev.example .env
nano .env
# hoặc
vim .env
```

### Các giá trị cần kiểm tra trong `.env`:

```env
# PostgreSQL - KO THAY ĐỔI (dùng default)
DATABASE_URL="postgresql://postgres:postgres@localhost:5433/postgres"
DIRECT_URL="postgresql://postgres:postgres@localhost:5433/postgres"

# ClickHouse - KO THAY ĐỔI
CLICKHOUSE_URL="http://localhost:8123"
CLICKHOUSE_MIGRATION_URL="clickhouse://localhost:9000"
CLICKHOUSE_USER="clickhouse"
CLICKHOUSE_PASSWORD="clickhouse"
CLICKHOUSE_CLUSTER_ENABLED="false"

# Redis - KO THAY ĐỔI
REDIS_HOST="127.0.0.1"
REDIS_PORT=6379
REDIS_AUTH="myredissecret"

# NextAuth - THAY ĐỔI NGAY
NEXTAUTH_URL="http://localhost:3000"
NEXTAUTH_SECRET="<GENERATE-NEW-SECRET-HERE>"

# Security - THAY ĐỔI NGAY
SALT="<GENERATE-NEW-SALT-HERE>"
ENCRYPTION_KEY="<GENERATE-NEW-KEY-HERE>"
```

### Generate Secrets

#### Trên Linux (Trên Window thì dùng git bash shell):
```bash
# NEXTAUTH_SECRET (32 bytes base64)
openssl rand -base64 32

# ENCRYPTION_KEY (64 hex characters)
openssl rand -hex 32
```

#### Nếu không có OpenSSL/PowerShell:
Dùng online generator (CHỈ cho development):
- https://generate-secret.vercel.app/32 (for NEXTAUTH_SECRET)
- https://generate-secret.vercel.app/64 (for ENCRYPTION_KEY, chọn HEX)

**⚠️ QUAN TRỌNG**: Chép secrets vào file `.env` và save lại

---

## Bước 3: Install Dependencies

```bash
pnpm install
```

**Thời gian**: 2-5 phút tùy tốc độ mạng

**Nếu gặp lỗi**:
- Check Node.js version: `node --version` (phải là v24.x.x)
- Check pnpm installed: `pnpm --version`
- Thử lại: `pnpm install --force`

---

## Bước 4: Start Docker Containers

### Bước 4.1: Start Containers

```bash
docker-compose -f docker-compose.dev.yml up -d
```

**Output mong đợi**:
```
Creating langfuse-postgres ... done
Creating langfuse-clickhouse ... done
Creating langfuse-redis ... done
Creating langfuse-minio ... done
```

### Bước 4.2: Kiểm tra Containers

```bash
docker ps
```

**Output mong đợi** (4 containers):
```
CONTAINER ID   IMAGE                              STATUS
xxx            postgres:17                        Up (healthy)
xxx            clickhouse/clickhouse-server:26.4  Up (healthy)
xxx            redis:7.2.4                        Up
xxx            cgr.dev/chainguard/minio          Up (healthy)
```

**Nếu status không phải "Up"**:
```bash
# Xem logs
docker logs langfuse-postgres
docker logs langfuse-clickhouse
docker logs langfuse-redis

# Restart
docker restart langfuse-postgres langfuse-clickhouse langfuse-redis
```
### Bước 4.3: Verify Connections

#### PostgreSQL:
```bash
docker exec -it langfuse-postgres psql -U postgres -c "SELECT version();"
```
✅ Nếu hiện version → OK

#### ClickHouse:
```bash
docker exec langfuse-clickhouse clickhouse-client --query="SELECT 1"
```
✅ Nếu hiện "1" → OK

#### Redis:
```bash
docker exec langfuse-redis redis-cli -a myredissecret PING
```
✅ Nếu hiện "PONG" → OK

---

## Bước 5: PostgreSQL Migrations (trên Window dùng Git Bash Shell)

### Bước 5.1: Navigate to shared package

```bash
cd packages/shared
```

### Bước 5.2: Run migrations

```bash
pnpm run db:migrate
```

**Sẽ hỏi tên migration**:
- Option 1: Nhấn **Enter** (skip, không tạo migration mới)
- Option 2: Gõ tên bất kỳ nếu muốn tạo migration

**Output mong đợi**:
```
The following migration(s) have been applied:

migrations/
  └─ 20xxxxxx_initial_migration/
    └─ migration.sql
```

### Bước 5.3: Generate Prisma Client

```bash
pnpm run db:generate
```

**Output**: Prisma client generated

### Bước 5.4: Return to root

```bash
cd ../..
```

---

## Bước 6: ClickHouse Migrations (Manual Method)

ClickHouse migrations cần được apply thủ công vì script phức tạp.

### Bước 6.1: Navigate to migrations folder

```bash
cd packages/shared/clickhouse/migrations/canonical
```

### Bước 6.2: List migrations

```bash
# Dùng git bash shell
ls *.up.sql | sort
```

**Output**: 50 files từ `0001_traces.up.sql` đến `0050_*.up.sql`

### Bước 6.3: Apply Each Migration

#### Trên Linux (Trên Windows chạy trên Git Bash Shell):

Tạo file script tạm:

```bash
cat > apply-migrations.sh << 'EOF'
#!/bin/bash
for migration in $(ls *.up.sql | sort); do
    echo "Applying: $migration"
    
    content=$(cat "$migration")
    content=$(echo "$content" | sed 's/{CLICKHOUSE_CLUSTER_CLAUSE}//g')
    content=$(echo "$content" | sed 's/{CLICKHOUSE_REPLICATION_PREFIX}//g')
    content=$(echo "$content" | sed 's/{CLICKHOUSE_HISTORICAL_FINAL_NEWLINES:[^}]*}//g')
    content=$(echo "$content" | sed 's/{CLICKHOUSE_UNCLUSTERED_ONLY:\([^}]*\)}/\1/g')
    content=$(echo "$content" | sed 's/{CLICKHOUSE_CLUSTERED_ONLY:[^}]*}//g')
    
    echo "$content" | docker exec -i langfuse-clickhouse clickhouse-client \
        --user=clickhouse \
        --password=clickhouse \
        --database=default \
        --multiquery 2>&1 | grep -v "already exists" || true
done
EOF

chmod +x apply-migrations.sh
./apply-migrations.sh
```


### Bước 6.4: Verify Tables

```bash
docker exec langfuse-clickhouse clickhouse-client \
    --user=clickhouse \
    --password=clickhouse \
    --database=default \
    --query="SHOW TABLES"
```

**Output mong đợi** (12 tables):
```
analytics_observations
analytics_scores
analytics_traces
blob_storage_file_log
dataset_run_items_rmt
events_core
events_core_mv
events_full
observations
observations_batch_staging
scores
traces
```

✅ **Nếu thấy 12 tables** → ClickHouse migrations thành công!

❌ **Nếu thiếu tables** → Xem [Troubleshooting ClickHouse](#troubleshooting-clickhouse)

### Bước 6.6: Return to root

```bash
cd ../../../..
```
---

## Bước 7: Build Shared Package

```bash
pnpm --filter @langfuse/shared run build
```

**Output mong đợi**:
```
src/index.ts -> dist/src/index.js
...
Build completed
```

**Verify**: Check folder `packages/shared/dist` tồn tại và có nhiều files

---

## Bước 8: Start Development Server

```bash
pnpm --filter web run dev
```

**Thời gian khởi động**: ~30-60 giây

**Output mong đợi**:
```
▲ Next.js 16.3.6 (Turbopack)
- Local:         http://localhost:3000
- Network:       http://172.x.x.x:3000

✓ Ready in 8.4s
```

✅ **Khi thấy "Ready"** → Mở browser: http://localhost:3000

## Bước 9: Start Production Server
```bash
pnpm add -D cross-env -w
pnpm --filter @langfuse/shared run build
pnpm --filter web run build
pnpm --filter web run start
```