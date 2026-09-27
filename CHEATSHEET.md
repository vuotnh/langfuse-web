# Langfuse Web - Command Cheat Sheet

Quick reference for common commands during development.

## ⚡ Quick Start

```powershell
# First time setup (automated)
.\setup.ps1

# Start dev server
pnpm --filter web run dev

# Open browser
start http://localhost:3000
```

## 🐳 Docker

```powershell
# Start all services
docker-compose -f docker-compose.dev.yml up -d

# Stop all services
docker-compose -f docker-compose.dev.yml down

# Restart specific service
docker restart langfuse-postgres
docker restart langfuse-clickhouse
docker restart langfuse-redis

# View logs
docker logs langfuse-postgres -f
docker logs langfuse-clickhouse -f
docker logs langfuse-redis -f

# Check running containers
docker ps --filter "name=langfuse"

# Execute commands in container
docker exec -it langfuse-postgres psql -U postgres
docker exec -it langfuse-clickhouse clickhouse-client --user=clickhouse --password=clickhouse
docker exec -it langfuse-redis redis-cli -a myredissecret
```

## 📦 Package Management

```powershell
# Install dependencies
pnpm install

# Install specific package
pnpm add <package-name>
pnpm add -D <package-name>  # Dev dependency

# Update dependencies
pnpm update

# Clean install
Remove-Item -Recurse -Force node_modules
pnpm install
```

## 🏗️ Build & Dev

```powershell
# Development server
pnpm --filter web run dev

# Build for production
pnpm --filter web run build

# Build shared package
pnpm --filter @langfuse/shared run build

# Type checking
pnpm --filter web run typecheck

# Clean build cache
Remove-Item -Recurse -Force .next, .next-check
```

## 🗄️ Database - PostgreSQL

```powershell
cd packages\shared

# Generate Prisma client
pnpm run db:generate

# Create migration
pnpm run db:migrate

# Push schema changes (dev only)
pnpm run db:push

# Reset database
pnpm run db:reset

# Seed database
pnpm run db:seed

# View migration status
pnpm exec prisma migrate status

# Open Prisma Studio
pnpm exec prisma studio

cd ..\..
```

## 📊 Database - ClickHouse

```powershell
# Run migrations
.\migrate-clickhouse.ps1

# Force recreate all tables
.\migrate-clickhouse.ps1 -Force

# Verify tables
.\migrate-clickhouse.ps1 -Verify

# Manual queries
docker exec langfuse-clickhouse clickhouse-client --user=clickhouse --password=clickhouse --database=default --query="SHOW TABLES"

docker exec langfuse-clickhouse clickhouse-client --user=clickhouse --password=clickhouse --database=default --query="SELECT count() FROM traces"

# Drop all tables
docker exec langfuse-clickhouse clickhouse-client --user=clickhouse --password=clickhouse --database=default --query="DROP TABLE IF EXISTS traces, observations, scores, events_core, events_full, events_core_mv, analytics_traces, analytics_observations, analytics_scores, dataset_run_items_rmt, blob_storage_file_log, observations_batch_staging"
```

## 🧪 Testing

```powershell
# Run all server tests
pnpm --filter web run test

# Run specific test file
pnpm --filter web run test src/__tests__/server/your-test.servertest.ts

# Run tests in watch mode
pnpm --filter web run test:watch

# Run client tests
pnpm --filter web run test-client

# Run E2E tests
pnpm --filter web run test:e2e

# Run E2E tests for AI Gateway
pnpm --filter web run test:e2e:ai-gateway
```

## 🔍 Linting & Formatting

```powershell
# Lint code
pnpm --filter web run lint

# Fix linting issues
pnpm --filter web run lint:fix

# Type check
pnpm --filter web run typecheck
```

## 🔧 Troubleshooting

```powershell
# Clear all caches
Remove-Item -Recurse -Force .next, .next-check, node_modules, packages\shared\dist
pnpm install

# Restart everything
docker-compose -f docker-compose.dev.yml restart
Remove-Item -Recurse -Force .next
pnpm --filter web run dev

# Kill process on port 3000
netstat -ano | findstr :3000
taskkill /PID <PID> /F

# Check Docker status
docker ps
docker logs langfuse-postgres --tail 50
docker logs langfuse-clickhouse --tail 50

# Rebuild Prisma client
cd packages\shared
pnpm run db:generate
pnpm run build
cd ..\..

# Check environment variables
Get-Content .env | Select-String "DATABASE_URL|CLICKHOUSE|REDIS"
```

## 🌐 URLs

```powershell
# Open in browser
start http://localhost:3000           # Web app
start http://localhost:9091           # MinIO console

# Test endpoints
curl http://localhost:3000/api/health
curl http://localhost:8123/ping       # ClickHouse
```

## 📝 Git

```powershell
# Create feature branch
git checkout -b feature/your-feature

# Commit changes
git add .
git commit -m "Your commit message"

# Push to remote
git push origin feature/your-feature

# Pull latest changes
git pull origin main
```

## 🔐 Security

```powershell
# Generate secrets
openssl rand -base64 32  # For NEXTAUTH_SECRET
openssl rand -hex 32     # For ENCRYPTION_KEY

# Check sensitive files are not committed
git status --ignored
```

## 📊 Performance

```powershell
# Analyze bundle size
pnpm --filter web run analyze

# Build with trace
pnpm --filter web run build:trace

# Profile build
pnpm --filter web run build -- --profile
```

## 🔄 Common Workflows

### Start working
```powershell
docker-compose -f docker-compose.dev.yml up -d
pnpm --filter web run dev
```

### After pulling changes
```powershell
pnpm install
cd packages\shared
pnpm run db:migrate
pnpm run build
cd ..\..
pnpm --filter web run dev
```

### Clean restart
```powershell
docker-compose -f docker-compose.dev.yml down
docker-compose -f docker-compose.dev.yml up -d
Start-Sleep -Seconds 15
Remove-Item -Recurse -Force .next
pnpm --filter web run dev
```

### End of day
```powershell
# Stop dev server (Ctrl+C)
docker-compose -f docker-compose.dev.yml down
```

---

**Tip**: Save this file and keep it open in a separate editor window for quick reference!
