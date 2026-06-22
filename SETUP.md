# Hướng dẫn cài đặt

## Yêu cầu
- Windows 10/11
- Tài khoản ChatGPT (bất kỳ loại nào, Pro thì ảnh đẹp hơn)
- Tài khoản Claude (để dùng Claude Code)

---

## Bước 1 — Cài Python (không cần quyền Admin)

1. Tải installer tại https://python.org/downloads (chọn phiên bản mới nhất)
2. Chạy file `.exe` vừa tải
3. **Quan trọng:** Ở màn hình đầu tiên:
   - Tick vào **"Add Python to PATH"**
   - Chọn **"Install for my user only"** (không cần admin)
4. Nhấn Install và chờ xong
5. Kiểm tra: mở terminal, gõ `python --version` → thấy `Python 3.x.x` là OK

---

## Bước 2 — Cài Node.js (không cần quyền Admin)

1. Vào https://nodejs.org/en/download → chọn tab **Prebuilt Binaries**
2. Chọn **Windows** / **x64** / **zip** → tải file `.zip` về
3. Giải nén vào thư mục bất kỳ trong máy, ví dụ: `C:\Users\TenBan\nodejs`
4. Thêm vào PATH của user (không phải system):
   - Nhấn **Start** → gõ tìm **"Edit environment variables for your account"** → mở ra
   - Ở phần **User variables** (phía trên), chọn dòng **Path** → nhấn **Edit**
   - Nhấn **New** → dán đường dẫn thư mục nodejs vừa giải nén vào
   - Nhấn **OK** → **OK**
5. Mở terminal **mới**, gõ `node --version` → thấy `v20.x.x` là OK

---

## Bước 3 — Cài Claude Code

1. Tải Claude Code Desktop tại https://claude.ai/code
2. Cài đặt và đăng nhập tài khoản Claude

---

## Bước 4 — Cài Codex CLI

Mở terminal (hoặc terminal trong Claude Code), chạy:

```
npm install -g @openai/codex
```

---

## Bước 5 — Đăng nhập ChatGPT

```
codex login
```

Trình duyệt tự mở → đăng nhập tài khoản ChatGPT bình thường → đóng lại.

---

## Bước 6 — Thiết lập tự động refresh token

Mở terminal, chạy lệnh sau (không cần admin):

```powershell
$action  = New-ScheduledTaskAction -Execute "python" -Argument "$PSScriptRoot\refresh_token.py"
$trigger = New-ScheduledTaskTrigger -RepetitionInterval (New-TimeSpan -Minutes 30) -Once -At (Get-Date)
Register-ScheduledTask -TaskName "CodexTokenRefresh" -Action $action -Trigger $trigger -Force
```

> Token sẽ tự gia hạn mỗi 30 phút. Nếu thấy pop-up "Cần đăng nhập lại" → quay lại Bước 5.

---

## Bước 7 — Lấy code về và chạy lần đầu

1. Vào https://github.com/MinhThuat/chatgpt-imagegen
2. Nhấn **Code** → **Download ZIP** → giải nén ra thư mục tùy chọn
3. Vào thư mục vừa giải nén → double-click **`start.bat`**
4. Lần tiếp theo chỉ cần double-click `start.bat` — tự cập nhật và mở Claude Code

---

## Bước 8 — Đặt ảnh tham chiếu

Tạo thư mục `anh_tham_chieu\` trong thư mục dự án và đặt ảnh vào:

| File | Nội dung |
|------|----------|
| `1.png` | Ảnh phong cách / background mong muốn |
| `2.png` | Bảng màu sản phẩm |
| `3.png` | Bảng màu chữ |
| `4.png` | Bộ icon |

---

## Cách sử dụng hàng ngày

1. Double-click **`start.bat`**
2. Claude Code mở ra → chat bằng tiếng Việt, ví dụ:
   - *"Tạo 8 ảnh mockup cốc sứ in hình thú cưng, mỗi ảnh 1-2 cốc, đổi màu và đổi tên"*
   - *"Chạy lại ảnh số 3 với background khác"*
3. Claude Code tự viết script và chạy, chỉ cần chờ kết quả

---

## Xử lý sự cố

| Triệu chứng | Cách xử lý |
|-------------|------------|
| Pop-up "Cần đăng nhập lại" | Mở terminal, chạy `codex login` |
| `python` không nhận ra | Cài lại Python, nhớ tick "Add to PATH" và chọn "for my user only" |
| `node` không nhận ra | Kiểm tra lại đường dẫn trong PATH (Bước 2) |
| Ảnh không tạo được | Kiểm tra internet, thử lại |
| Script báo lỗi đỏ | Chụp màn hình và nhờ Claude Code giải thích |
