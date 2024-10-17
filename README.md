# Đồ Án Môn Lập Trình Ứng Dụng Quản Lý 2

- Họ và tên: Lâm Thành Nhân
- MSSV: 22880253

## Các Chức Năng Đã Thực Hiện

### Các Chức Năng Cơ Sở

1. Trang Đăng nhập (Login):

    - Thông tin đăng nhập:
    - Tên đăng nhập: `postgres` (Đây cũng là tên đăng nhập mặc định của Postgres).
    - Mật khẩu: `sales`.
    - Nếu có thông tin đăng nhập lưu từ lần trước thì tự động đăng nhập và đi vào màn hình chính luôn.
    - Thông tin đăng nhập cần phải được mã hóa.
    - Màn hình đăng nhập cần hiển thị thông tin phiên bản của chương trình.
    - Cho phép cấu hình thông tin server từ màn hình Config

    - Chức năng bổ sung:
        - Cụ thể hơn là khi ứng dụng tiến hành tự động đăng nhập thì một hộp thoại sẽ hiện ra để người dùng có thể huỷ trong vòng 3s.

2. Trang tổng quan hệ thống (Dashboard):

    - Tổng số sản phẩm.
    - Cho biết top 5 sản phẩm sắp hết hàng (số lượng < 5)
    - Cho biết top 5 sản phẩm bán chạy
    - Tổng số đơn hàng trong ngày
    - Tổng doanh thu trong ngày
    - Chi tiết 3 đơn hàng gần nhất
    - Biểu đồ doanh thu theo ngày trong tháng hiện tại

3. Trang Sản Phẩm (Products):

    - Cho phép xem danh sách sản phẩm theo loại > Xem chi tiết > Xóa / Sửa:
        - Có hỗ trợ phân trang
        - Cho phép sắp xếp theo 1 loại tiêu chí
        - Cho phép lọc lại theo khoảng giá:
            - Khoảng giá thấp sẽ có giá trị mặc định là `0` và có nút chọn riêng.
            - Khoảng giá cao sẽ có giá trị mặc định là `Tối đa` và có nút chọn riêng.
        - Cho phép tìm kiếm dựa theo từ khóa trong tên sản phẩm:
    - Thêm mới sản phẩm.
    - Thêm mới loại sản phẩm.
    - Cho phép import dữ liệu từ tập tin Excel.
    - Dữ liệu mẫu:
        - Loại sản phẩm: có 3 loại
        - Sản phẩm:
            - Mỗi loại sản phẩm có tối thiểu 22 sản phẩm.
            - Mỗi sản phẩm có tối thiểu 3 hình.
            - Dữ liệu mẫu là thật (từ trang thegioididong.com).
    - Dữ liệu từ 3 nguồn:
        - Memory.
        - Shared Preferences.
        - Postgres:
            - Tìm hiểu cách sử dụng pgAdmin:
                - Cách tạo bảng thông qua GUI (ERD tool).
                - Cách để tự động tạo id (tự động tăng số) thông qua sequence.
            - Tìm hiểu cách sử dụng postgres:
                - Cách để lấy được số hiện tại của trình tự động tạo số.
        - Có 3 loại sản phẩm: Điện Thoại, Máy Tính, Màn Hình.
        - Mỗi loại sản phẩm có 22 sản phẩm.
        - Mỗi sản phẩm có ít nhất 3 hình (hình ảnh có thể là đường dẫn từ máy tính hoặc URL).
        - Dữ liệu thật lấy từ thegioididong.com.

4. Trang Đơn Hàng (Orders):

    - Tạo ra các đơn hàng.
    - Cho phép xóa một đơn hàng, cập nhật một đơn hàng.
    - Cho phép xem danh sách các đơn hàng có phân trang, xem chi tiết một đơn hàng.
    - Tìm kiếm các đơn hàng từ ngày đến ngày.

5. Trang Cài Đặt (Settings):

    - Chọn ngôn ngữ: Anh, Việt.
    - Chế độ sáng tối.
    - Cài đặt số dòng mỗi trang khi phân trang.
    - Cho phép lưu chức năng lần cuối mở.
    - Sao lưu/Khôi phục Database.

### Các Chức Năng Tự Chọn

- Auto save khi tạo đơn hàng, thêm mới sản phẩm (0.25): Khi người dùng mở trang đơn hàng và sản phẩm thì có 1 thông báo hiện lên nếu có đơn hàng nháp để người dùng tiếp tục tạo đơn hoặc huỷ đơn nháp.
- Tự động thay đổi sắp xếp hợp lí các thành phần theo độ rộng màn hình (responsive layout) (0.5 điểm)
- TODO: Bổ sung khuyến mãi giảm giá (1 điểm)
- Thêm chế độ dùng thử - cho phép xài full phần mềm trong 15 ngày. Hết 15 ngày bắt đăng kí (mã code hay cách kích hoạt nào đó) (0.5 điểm):
  - Kiểm tra người dùng có đã sử dụng trial chưa, nếu chưa thì hiển thị hộp thoại để kích hoạt.
  - Nếu người dùng đã hết hạn dùng thử thì hiển thị hộp thoại để người dùng nhập mã kích hoạt. Khi người dùng nhập đúng mã là `22880253` thì người dùng sẽ được sử dụng thêm 30 ngày.
- Backup / restore database (0.25 điểm):
  - Backup: Encode toàn bộ dữ liệu sang dạng JSON và lưu dạng tệp vào ổ cứng.
  - Restore: Chọn tệp đã sao lưu và decode để có thể lưu vào CSDL.
- Làm rối mã nguồn (obfuscator) chống dịch ngược (0.25 điểm):
  - Sử dụng trình obfusactor của framework.
- Sử dụng Dependency Injection (0.5 điểm)
- Hỗ trợ onboarding (0.5 điểm)
- In đơn hàng PDF (0.5 điểm):
  - In đơn hàng chỉ có ở chế độ "Xem chi tiết đơn hàng".

### Phần Tự Tìm Hiểu

- **Sử dụng kiến trúc Clean Architecture**.
- Màn hình Đăng Nhập:
  - Khi ứng dụng tiến hành tự động đăng nhập thì một hộp thoại sẽ hiện ra để người dùng có thể huỷ trong vòng 3s.
- Màn hình Sản Phẩm:
  - Sao chép một sản phẩm.
  - Tạo một khoảng delay khi người dùng nhập vào ô tìm kiếm để đảm bảo người dùng hoàn thiện nhập liệu nhằm giảm số lần request lên server.
- Màn hình Đơn Hàng:
  - Sao chép một đơn hàng.
- Màn hình Cài Đặt:
  - Chọn ngôn ngữ: Anh, Việt.
  - Chế độ sáng/tối.
- CSDL:
  - Sử dụng Postgres.app để quản lý server.
  - Sử dụng pgAdmin 4 để quản lý dữ liệu.
