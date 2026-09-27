# 📚 Tài Liệu Hướng Dẫn Setup Langfuse Web

Tổng hợp tài liệu đầy đủ để setup và phát triển Langfuse Web trên Windows.

## 📖 Danh Sách Tài Liệu

### 1. [README_SETUP.md](./README_SETUP.md) - Quick Start Guide
- **Mục đích**: Hướng dẫn nhanh để bắt đầu
- **Platform**: All (Windows/Linux/Mac)
- **Nội dung**:
  - Quick start với automated script
  - Các scripts hữu ích
  - Troubleshooting nhanh
  - Project structure overview
  - Service URLs

**Đọc đầu tiên nếu**: Bạn muốn setup nhanh và đã có kinh nghiệm

---

### 2. Platform-Specific Guides

#### [SETUP_WINDOWS.md](./SETUP_WINDOWS.md) - Windows + PowerShell
- **Platform**: ✅ Windows với PowerShell
- **Mục đích**: Hướng dẫn chi tiết cho Windows
- **Nội dung**:
  - Prerequisites cho Windows
  - PowerShell commands
  - Windows-specific troubleshooting
  - 7 bước setup từ đầu đến cuối

**Đọc đầu tiên nếu**: 
- Windows user với PowerShell enabled
- Lần đầu setup trên Windows

#### [SETUP_UNIX.md](./SETUP_UNIX.md) - Linux/Mac/WSL
- **Platform**: ✅ Linux, ✅ macOS, ✅ WSL
- **Mục đích**: Hướng dẫn chi tiết cho Unix-based systems
- **Nội dung**:
  - Prerequisites cho Linux/Mac/WSL
  - Bash commands
  - golang-migrate setup
  - Unix-specific troubleshooting

**Đọc đầu tiên nếu**: 
- Linux, macOS, hoặc WSL user
- Có bash/zsh terminal

#### [SETUP_MANUAL.md](./SETUP_MANUAL.md) - Manual Setup (No Scripts)
- **Platform**: ✅ All (Không cần scripts)
- **Mục đích**: Setup thủ công từng bước
- **Nội dung**:
  - Manual steps cho mọi platform
  - Không dùng PowerShell hay Bash scripts
  - Chi tiết nhất, giải thích từng lệnh
  - Troubleshooting chi tiết

**Đọc đầu tiên nếu**: 
- Không thể chạy scripts (bị hạn chế permissions)
- Muốn hiểu rõ từng bước làm gì
- Troubleshooting issues cụ thể
- Learning/teaching purposes

---

### 3. [CHEATSHEET.md](./CHEATSHEET.md) - Command Reference
- **Platform**: All
- **Mục đích**: Tra cứu nhanh các lệnh thường dùng
- **Nội dung**:
  - Docker commands
  - Database commands (PostgreSQL + ClickHouse)
  - Testing commands
  - Troubleshooting commands
  - Common workflows

**Đọc đầu tiên nếu**: 
- Đã setup xong, đang phát triển hàng ngày
- Quên lệnh cần chạy
- Cần copy-paste lệnh nhanh

---

## 🚀 Quick Start (Recommended Path)

### Chọn Hướng Dẫn Phù Hợp

| Platform | Script Enabled? | Recommended Guide | Script |
|----------|----------------|-------------------|--------|
| **Windows** | ✅ Yes | [SETUP_WINDOWS.md](./SETUP_WINDOWS.md) | `setup.ps1` |
| **Windows** | ❌ No | [SETUP_MANUAL.md](./SETUP_MANUAL.md) | None |
| **Linux/Mac/WSL** | ✅ Yes | [SETUP_UNIX.md](./SETUP_UNIX.md) | `setup.sh` |
| **Linux/Mac/WSL** | ❌ No | [SETUP_MANUAL.md](./SETUP_MANUAL.md) | None |
| **Any** | ❌ Script blocked | [SETUP_MANUAL.md](./SETUP_MANUAL.md) | None |

### Lần Đầu Setup

#### Option 1: Windows (PowerShell)

1. **Đọc prerequisites** trong [SETUP_WINDOWS.md](./SETUP_WINDOWS.md#prerequisites)
2. **Clone và setup**:
   ```powershell
   git clone <repo-url>
   cd langfuse-web
   .\setup.ps1
   ```
3. **Review .env**: Update NEXTAUTH_SECRET, SALT, ENCRYPTION_KEY
4. **Start dev server**: `pnpm --filter web run dev`
5. **Open browser**: http://localhost:3000

#### Option 2: Linux/Mac/WSL (Bash)

1. **Đọc prerequisites** trong [SETUP_UNIX.md](./SETUP_UNIX.md#prerequisites)
2. **Clone và setup**:
   ```bash
   git clone <repo-url>
   cd langfuse-web
   chmod +x setup.sh
   ./setup.sh
   ```
3. **Review .env**: Update secrets
4. **Start dev server**: `pnpm --filter web run dev`
5. **Open browser**: http://localhost:3000

#### Option 3: Manual (Any Platform)

1. **Follow step-by-step**: [SETUP_MANUAL.md](./SETUP_MANUAL.md)
2. Không cần scripts, làm từng bước thủ công
3. Phù hợp khi scripts bị block hoặc muốn học chi tiết

### Lần Sau (Đã Setup Rồi)

1. **Start Docker services**:
   ```powershell
   docker-compose -f docker-compose.dev.yml up -d
   ```

2. **Start dev server**:
   ```powershell
   pnpm --filter web run dev
   ```

3. **Mở browser**: http://localhost:3000
---

## 📋 Checklist Sau Setup

- [ ] Docker containers đang chạy: `docker ps`
- [ ] PostgreSQL có schema: Check có file trong `packages/shared/prisma/migrations/`
- [ ] ClickHouse có 12 tables: `.\migrate-clickhouse.ps1 -Verify`
- [ ] Shared package đã build: Check có folder `packages/shared/dist/`
- [ ] Dev server chạy được: http://localhost:3000
- [ ] Không có error trong console

---

## 📂 Cấu Trúc Tài Liệu

```
langfuse-web/
├── README_SETUP.md          # ⭐ Quick start (all platforms)
├── SETUP_WINDOWS.md         # ⭐ Windows + PowerShell detailed
├── SETUP_UNIX.md            # ⭐ Linux/Mac/WSL detailed
├── SETUP_MANUAL.md          # ⭐ Manual setup (no scripts)
├── CHEATSHEET.md            # ⭐ Command reference
├── DOCS_INDEX.md            # ← Bạn đang đọc file này
│
├── setup.ps1                # 🔧 Windows automated setup
├── setup.sh                 # 🔧 Unix automated setup
├── migrate-clickhouse.ps1   # 🔧 Windows ClickHouse migrations
├── migrate-clickhouse.sh    # 🔧 Unix ClickHouse migrations
│
├── .env                     # Environment variables
├── docker-compose.dev.yml   # Docker services
│
├── packages/shared/         # Shared code
│   ├── AGENTS.md           # Shared package guidelines
│   ├── prisma/             # PostgreSQL schema
│   └── clickhouse/         # ClickHouse migrations
│
└── web/                    # Next.js app
    └── AGENTS.md           # Web package guidelines
```

---

## 💡 Tips

### Productivity Tips

1. **Pin CHEATSHEET.md** trong editor để tra cứu nhanh
2. **Tạo alias** trong PowerShell profile:
   ```powershell
   # File: $PROFILE (notepad $PROFILE)
   function lf-dev { cd D:\workspace\langfuse-web; pnpm --filter web run dev }
   function lf-docker { cd D:\workspace\langfuse-web; docker-compose -f docker-compose.dev.yml up -d }
   function lf-ch { cd D:\workspace\langfuse-web; .\migrate-clickhouse.ps1 }
   ```
3. **Bookmark** localhost URLs trong browser
4. **Setup VS Code tasks** cho các lệnh thường dùng

### Learning Path

1. **Week 1**: Focus on [README_SETUP.md](./README_SETUP.md) và [CHEATSHEET.md](./CHEATSHEET.md)
2. **Week 2**: Đọc `web/AGENTS.md` và `packages/shared/AGENTS.md` để hiểu conventions
3. **Ongoing**: Reference [SETUP_WINDOWS.md](./SETUP_WINDOWS.md) khi gặp vấn đề

---

## 🆘 Khi Cần Help

### Tài Liệu Nội Bộ

1. [SETUP_WINDOWS.md#troubleshooting](./SETUP_WINDOWS.md#troubleshooting)
2. [CHEATSHEET.md#troubleshooting](./CHEATSHEET.md#troubleshooting)
3. `web/AGENTS.md` - Web package conventions
4. `packages/shared/AGENTS.md` - Shared package conventions

### External Resources

- **Next.js Docs**: https://nextjs.org/docs
- **Prisma Docs**: https://www.prisma.io/docs
- **ClickHouse Docs**: https://clickhouse.com/docs
- **Docker Docs**: https://docs.docker.com

---

## 📝 Cập Nhật Tài Liệu

Nếu bạn phát hiện:
- Bước setup không đúng
- Lỗi mới chưa được document
- Có cách tốt hơn để làm việc gì đó

→ **Cập nhật tài liệu này!** Tài liệu tốt giúp cả team.

### Guidelines Cập Nhật

1. **SETUP_WINDOWS.md**: Thêm vào section Troubleshooting
2. **CHEATSHEET.md**: Thêm command vào section phù hợp
3. **README_SETUP.md**: Update quick reference
4. **DOCS_INDEX.md**: Thêm note về thay đổi

---

**Last Updated**: 2026-09-26
**Version**: 1.0
**Maintainer**: Development Team
