ENTERPRISE JOB ARCHITECTURE PLATFORM 5.0 – HƯỚNG DẪN

1. FILE
- index.html: ứng dụng web độc lập, có thể chạy trực tiếp trên trình duyệt hoặc triển khai như static site trên Vercel.

2. CÁCH MỞ THỬ
- Trên máy tính: mở index.html bằng Chrome hoặc Edge.
- Trên Vercel: thay thế index.html tại thư mục gốc của project và triển khai lại.

3. CHỨC NĂNG ĐÃ CẬP NHẬT
- Sửa lỗi cú pháp JavaScript ở Career Streams & Career Levels.
- Kiểm tra render các màn hình workflow và governance.
- Giữ nguyên dữ liệu gốc 81 dòng (67 PE, 14 SLOT), 22 grade definitions và PC Matrix.
- Tách SLOT khỏi việc tự động gán Career Track / Internal Grade.
- Gắn nhãn Career Track là provisional khi suy luận từ chức danh / PC; cần HR xác nhận theo JD và phạm vi công việc.
- Thêm company workspaces trong cùng trình duyệt; dữ liệu mỗi company được lưu riêng bằng localStorage.
- Thêm Import CSV / JSON, Export CSV, JSON backup và CSV template.
- Thêm Data Quality, Governance & Change Control.
- Mở rộng phần Methodology với các nguyên tắc phân loại theo công việc, kỹ năng, kiến thức, phạm vi và trách nhiệm.

4. ĐỊNH DẠNG IMPORT CSV
Bắt buộc: Division, Title, PC.
Các cột bổ sung: No, Type, Impact, Contribution, Communication, Frame, Innovation, Complexity, Knowledge, Team, Breadth, Comments.
Có thể tải CSV Template từ thanh công cụ trong ứng dụng.

5. GIỚI HẠN QUAN TRỌNG
Đây vẫn là browser prototype, chưa phải hệ thống SaaS production:
- Dữ liệu lưu trong localStorage của trình duyệt hiện tại; không tự đồng bộ giữa các máy hoặc người dùng.
- Company workspaces chỉ tách dữ liệu ở cấp trình duyệt, chưa có tenant isolation phía server.
- Chưa có đăng nhập, phân quyền, cơ sở dữ liệu cloud, audit log server-side hoặc workflow phê duyệt đa cấp.
- Import hiện hỗ trợ CSV và JSON; chưa hỗ trợ đọc trực tiếp XLSX.
- Chưa có chức năng xuất PowerPoint trực tiếp từ ứng dụng.

6. KHUYẾN NGHỊ TRƯỚC KHI DÙNG CHO KHÁCH HÀNG
- Xác nhận Career Track, Job Family, Sub-family và Job Profile bằng JD và phạm vi công việc thực tế.
- Không coi các phân loại gợi ý theo title là kết quả đã được phê duyệt.
- Bổ sung backend, authentication, role-based access, version control, approval workflow và backup trước khi sử dụng dữ liệu nhân sự thật.
