# chatgpt-imagegen — AI Mockup Generator

## Dự án này làm gì
Tạo ảnh mockup sản phẩm hàng loạt bằng AI (ChatGPT image generation) thông qua CLI `chatgpt-imagegen`.

## Cách sử dụng
Người dùng chỉ cần **mô tả bằng tiếng Việt** những gì họ muốn, ví dụ:
- "Tạo 10 ảnh mockup balo trẻ em với tên khác nhau"
- "Gen 8 ảnh mockup cốc sứ in hình thú cưng"
- "Chạy lại ảnh số 3 với màu khác"

Claude Code sẽ tự viết script PowerShell và chạy.

## Cấu trúc thư mục
- `anh_tham_chieu\` — ảnh tham chiếu đầu vào (đặt ảnh ref vào đây)
- `chatgpt-imagegen` — CLI chính (Python, không sửa)
- `refresh_token.py` — tự động refresh token codex
- `run_*.ps1` — các script gen ảnh (do Claude tạo ra)
- `out_*\` — thư mục output ảnh

## Backend
Dự án dùng **codex backend** (ChatGPT logged-in session).
File auth: `~/.codex/auth.json`
Token tự refresh mỗi 30 phút qua Windows Task Scheduler (task: `CodexTokenRefresh`).

## Xử lý lỗi thường gặp

### "token refresh failed: HTTP 401" hoặc pop-up "Cần đăng nhập lại"
Token hết hạn hoàn toàn, cần login lại:
```
codex login
```

### "No module named fcntl"
Đã fix sẵn trong code (Windows shim).

### Ảnh ra 1254x1254 thay vì 2048
Giới hạn subscription, không thay đổi được.

## Tham số CLI hay dùng
```
python chatgpt-imagegen "prompt" -i ref.png -o output.png --size 1024x1024 --backend codex --quiet
```
- `-i` : ảnh tham chiếu (có thể dùng nhiều lần)
- `-o` : file output
- `--size` : 1024x1024 (recommended)
- `--backend codex` : dùng session ChatGPT
- `--quiet` : ít log hơn

## Lưu ý quan trọng
- Codex backend giới hạn **4 request song song** tối đa
- Mỗi ảnh mất khoảng **60-150 giây**
- Script dùng `Start-Job` + throttle loop, KHÔNG dùng `ForEach-Object -Parallel` (PowerShell 5.1 không hỗ trợ)
- Tránh ký tự đặc biệt như em dash `—` trong file `.ps1` (gây parse error encoding)
