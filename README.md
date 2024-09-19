# Đồ Án Môn Lập Trình Ứng Dụng Quản Lý 2

- Họ và tên: Lâm Thành Nhân
- MSSV: 22880253

## Các Chức Năng Đã Thực Hiện

### Các Chức Năng Cơ Sở

1. Đăng nhập:

    - Nếu có thông tin đăng nhập lưu từ lần trước thì tự động đăng nhập và đi vào màn hình chính luôn.
    - Thông tin đăng nhập cần phải được mã hóa.
    - Màn hình đăng nhập cần hiển thị thông tin phiên bản của chương trình.
    - Cho phép cấu hình thông tin server từ màn hình Config

    - Chức năng bổ sung:
        - Cụ thể hơn là khi ứng dụng tiến hành tự động đăng nhập thì một hộp thoại sẽ hiện ra để người dùng có thể huỷ trong vòng 3s.

2. Dashboard tổng quan hệ thống:

    - Tổng số sản phẩm.
    - Cho biết top 5 sản phẩm sắp hết hàng (số lượng < 5)
    - Cho biết top 5 sản phẩm bán chạy
    - Tổng số đơn hàng trong ngày
    - Tổng doanh thu trong ngày
    - Chi tiết 3 đơn hàng gần nhất
    - Biểu đồ doanh thu theo ngày trong tháng hiện tại

3. Trang Products:

    - Cho phép xem danh sách sản phẩm theo loại > Xem chi tiết > Xóa / Sửa:
        - Có hỗ trợ phân trang
        - Cho phép sắp xếp theo 1 loại tiêu chí
        - Cho phép lọc lại theo khoảng giá
        - Cho phép tìm kiếm dựa theo từ khóa trong tên sản phẩm
    - Thêm mới sản phẩm.
    - TODO: Thêm mới loại sản phẩm.
    - TODO: Cho phép import dữ liệu từ tập tin Excel hoặc Access.
    - TODO: Bổ sung dữ liệu mẫu:
        - Loại sản phẩm: có ít nhất 3 loại
        - Sản phẩm:
            - Mỗi loại sản phẩm có tối thiểu 22 sản phẩm.
            - Mỗi sản phẩm có tối thiểu 3 hình.
            - Dữ liệu mẫu không cần phải là thật nhưng nên giống thật.
