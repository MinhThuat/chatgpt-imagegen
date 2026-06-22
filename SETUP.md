# Hướng dẫn cài đặt

## Yêu cầu
- Windows 10/11
- Tài khoản ChatGPT (bất kỳ loại nào, Pro thì ảnh đẹp hơn)
- Tài khoản Claude (để dùng Claude Code)

---

## Bước 1 — Cài Python (không cần quyền Admin)

**Cách A — Microsoft Store (dễ nhất, không cần admin):**
1. Mở Microsoft Store, tìm **Python 3.12**
2. Nhấn **Get** → tự cài, không hỏi quyền admin
3. Kiểm tra: mở terminal, gõ `python --version`

**Cách B — python.org (không cần admin):**
1. Tải tại https://python.org/downloads
2. Chạy installer → chọn **"Install for my user only (recommended)"**
3. **Tick vào "Add Python to PATH"** trước khi nhấn Install

**Cách C — Portable (không cài, chỉ giải nén):**
1. Tải file `python-3.12.x-embed-amd64.zip` tại https://python.org/downloads/windows
2. Giải nén vào thư mục ví dụ `C:\Users\TenBan\python312`
3. Mở `start.bat` → nhập đường dẫn này khi được hỏi

---

## Bước 2 — Cài Node.js (không cần quyền Admin)

**Cách A — Portable ZIP (không cần admin, không cần cài):**
1. Tải `node-v20.x.x-win-x64.zip` tại https://nodejs.org/en/download (chọn tab **Prebuilt Binaries** → **zip**)
2. Giải nén vào `C:\Users\TenBan\nodejs`
3. Thêm vào PATH: mở **Start** → tìm **"Edit environment variables for your account"** → chọn **Path** → **Edit** → **New** → dán đường dẫn thư mục vừa giải nén
4. Mở terminal mới, gõ `node --version` để kiểm tra

**Cách B — Scoop (package manager không cần admin):**
1. Mở PowerShell, chạy:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
```
2. Sau đó:
```
scoop install nodejs python
```
> Scoop cài mọi thứ vào `C:\Users\TenBan\scoop\` — không đụng đến system, không cần admin.

---

## Bước 3 — Cài Claude Code

1. Truy cập https://claude.ai/code và tải Claude Code Desktop cho Windows
2. Cài đặt và đăng nhập tài khoản Claude
3. Mở thư mục dự án này bằng Claude Code (File → Open Folder)

---

## Bước 4 — Cài Codex CLI

Mở terminal trong Claude Code (hoặc Windows Terminal), chạy:

```
npm install -g @openai/codex
```

---

## Bước 5 — Đăng nhập ChatGPT

```
codex login
```

Trình duyệt sẽ mở ra → đăng nhập tài khoản ChatGPT bình thường.

---

## Bước 6 — Thiết lập tự động refresh token

Chạy 1 lần trong terminal (quyền Admin):

```powershell
$action  = New-ScheduledTaskAction -Execute "python" -Argument "D:\vsc\chatgpt-imagegen\refresh_token.py"
$trigger = New-ScheduledTaskTrigger -RepetitionInterval (New-TimeSpan -Minutes 30) -Once -At (Get-Date)
Register-ScheduledTask -TaskName "CodexTokenRefresh" -Action $action -Trigger $trigger -RunLevel Highest -Force
```

> Sau khi setup, token sẽ tự gia hạn mỗi 30 phút. Nếu thấy pop-up "Cần đăng nhập lại" → quay lại Bước 4.

---

## Bước 7 — Đặt ảnh tham chiếu

Đặt các ảnh tham chiếu vào thư mục `anh_tham_chieu\`:

| File | Nội dung |
|------|----------|
| `1.png` | Ảnh phong cách / background mong muốn |
| `2.png` | Bảng màu sản phẩm |
| `3.png` | Bảng màu chữ |
| `4.png` | Bộ icon |

---

## Cách sử dụng hàng ngày

1. Mở thư mục dự án bằng **Claude Code**
2. Chat bằng tiếng Việt, ví dụ:
   - *"Tạo 8 ảnh mockup cốc sứ in hình thú cưng, mỗi ảnh 1-2 cốc, đổi màu và đổi tên"*
   - *"Chạy lại ảnh số 3 với background khác"*
   - *"Xem lại kết quả trong out_pod"*
3. Claude Code tự viết script và chạy, chỉ cần chờ kết quả

---

## Xử lý sự cố

| Triệu chứng | Cách xử lý |
|-------------|------------|
| Pop-up "Cần đăng nhập lại" | Chạy `codex login` trong terminal |
| Ảnh không tạo được | Kiểm tra internet, thử lại |
| Token refresh failed HTTP 401 | Chạy `codex login` |
| Script báo lỗi đỏ | Chụp màn hình và nhờ Claude Code giải thích |
