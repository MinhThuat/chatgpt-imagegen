# Hướng dẫn cài đặt

## Yêu cầu
- Windows 10/11
- Tài khoản ChatGPT (bất kỳ loại nào, Pro thì ảnh đẹp hơn)
- Tài khoản Claude (để dùng Claude Code)

---

## Bước 1 — Cài Python

1. Truy cập https://python.org/downloads
2. Tải phiên bản mới nhất (Python 3.11 hoặc 3.12)
3. Chạy installer, **tick vào "Add Python to PATH"** trước khi nhấn Install
4. Kiểm tra: mở terminal, gõ `python --version` → phải thấy `Python 3.x.x`

---

## Bước 2 — Cài Claude Code

1. Truy cập https://claude.ai/code và tải Claude Code Desktop cho Windows
2. Cài đặt và đăng nhập tài khoản Claude
3. Mở thư mục dự án này bằng Claude Code (File → Open Folder)

---

## Bước 3 — Cài Codex CLI

Mở terminal trong Claude Code (hoặc Windows Terminal), chạy:

```
npm install -g @openai/codex
```

> Nếu máy chưa có Node.js: tải tại https://nodejs.org (chọn LTS)

---

## Bước 4 — Đăng nhập ChatGPT

```
codex login
```

Trình duyệt sẽ mở ra → đăng nhập tài khoản ChatGPT bình thường.

---

## Bước 5 — Thiết lập tự động refresh token

Chạy 1 lần trong terminal (quyền Admin):

```powershell
$action  = New-ScheduledTaskAction -Execute "python" -Argument "D:\vsc\chatgpt-imagegen\refresh_token.py"
$trigger = New-ScheduledTaskTrigger -RepetitionInterval (New-TimeSpan -Minutes 30) -Once -At (Get-Date)
Register-ScheduledTask -TaskName "CodexTokenRefresh" -Action $action -Trigger $trigger -RunLevel Highest -Force
```

> Sau khi setup, token sẽ tự gia hạn mỗi 30 phút. Nếu thấy pop-up "Cần đăng nhập lại" → quay lại Bước 4.

---

## Bước 6 — Đặt ảnh tham chiếu

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
