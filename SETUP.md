# Hướng dẫn cài đặt

## Yêu cầu
- Windows 10/11
- Tài khoản ChatGPT (Pro thì ảnh đẹp hơn)
- Tài khoản Claude (để dùng Claude Code)

---

## Cài đặt lần đầu (1 lần duy nhất)

1. Vào https://github.com/MinhThuat/chatgpt-imagegen
2. Nhấn **Code** → **Download ZIP** → giải nén ra thư mục tùy chọn
3. Vào thư mục vừa giải nén → double-click **`setup.bat`**
4. Làm theo hướng dẫn trên màn hình (tự cài Python, Node.js, Codex, Claude Code)
5. Đăng nhập ChatGPT khi trình duyệt mở ra

> `setup.bat` tự phát hiện những gì đã cài và bỏ qua — chạy lại cũng không sao.

---

## Cách sử dụng hàng ngày

1. Double-click **`start.bat`** (tự cập nhật + mở Claude Code)
2. Chat bằng tiếng Việt, ví dụ:
   - *"Tạo 8 ảnh mockup cốc sứ in hình thú cưng, mỗi ảnh 1-2 cốc"*
   - *"Chạy lại ảnh số 3 với background khác"*
3. Claude Code tự viết script và chạy — chỉ cần chờ kết quả

---

## Đặt ảnh tham chiếu

Tạo thư mục `anh_tham_chieu\` trong thư mục dự án và đặt ảnh vào:

| File | Nội dung |
|------|----------|
| `1.png` | Ảnh phong cách / background mong muốn |
| `2.png` | Bảng màu sản phẩm |
| `3.png` | Bảng màu chữ |
| `4.png` | Bộ icon |

---

## Xử lý sự cố

| Triệu chứng | Cách xử lý |
|-------------|------------|
| Pop-up "Can dang nhap lai" | Mở terminal → `codex login` |
| Lỗi `Cannot find module graceful-fs` | Node.js v24 bị lỗi — xóa đi, cài lại v20 LTS hoặc chạy lại `setup.bat` |
| `python` / `node` không nhận ra | Đóng terminal, mở lại (PATH cần refresh) |
| Ảnh không tạo được | Kiểm tra internet; token hết → `codex login` |
| Script báo lỗi đỏ | Chụp màn hình và nhờ Claude Code giải thích |
