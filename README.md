# Đồ Án Môn Lập Trình Ứng Dụng Quản Lý 2

- Họ và tên: Lâm Thành Nhân
- MSSV: 22880253

- Tự chấm điểm: 9.5

## Các Chức Năng Đã Thực Hiện

### Mã nguồn

- [Video Youtube](https://youtu.be/orKD1-g8RyY)
- [Github](https://github.com/lamnhan066/sales)

### Các Chức Năng Cơ Sở (5.0)

1. Trang Đăng nhập (Login):

    - Thông tin đăng nhập:
        - Tên đăng nhập: `postgres` (Đây cũng là tên đăng nhập mặc định của Postgres).
        - Mật khẩu: `sales`.
    - Thông tin server Postgres:
        - Host: `localhost`.
        - Database: `sales`.
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
        - Loại sản phẩm: có 3 loại là Điện Thoại, Máy Tính, Màn Hình.
        - Sản phẩm:
            - Mỗi loại sản phẩm có tối thiểu 22 sản phẩm.
            - Mỗi sản phẩm có tối thiểu 3 hình.
            - Dữ liệu mẫu là thật (từ trang thegioididong.com).
    - Dữ liệu:
        - Postgres:
            - Tìm hiểu cách sử dụng pgAdmin:
                - Cách tạo bảng thông qua GUI (ERD tool).
                - Cách để tự động tạo id (tự động tăng số) thông qua sequence.
            - Tìm hiểu cách sử dụng postgres:
                - Cách để lấy được số hiện tại của trình tự động tạo số.

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

### Các Chức Năng Tự Chọn (4.25)

- Auto save khi tạo đơn hàng, thêm mới sản phẩm (0.25):
  - Khi người dùng mở trang đơn hàng và sản phẩm thì có 1 thông báo hiện lên nếu có đơn hàng nháp để người dùng tiếp tục tạo đơn hoặc huỷ đơn nháp.
- Tự động thay đổi sắp xếp hợp lí các thành phần theo độ rộng màn hình (responsive layout) (0.5 điểm)
- Bổ sung khuyến mãi giảm giá (1 điểm):
  - Khuyến mãi sẽ ở dưới dạng phần trăm giảm và có thể xác định số tiền giảm tối đa.
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
  - Sử dụng pgAdmin 4 để quản lý server và dữ liệu.
- Sử dụng Git và Github để quản lý và lưu trữ mã nguồn.
- Build bản cài đặt cho macos và windows.

## Build

### Windows

- dart run msix:create

### MacOS

- dart run dmg --sign-certificate "Developer ID Application: [Company Name]"

## Database

### Tạo Database

```sql
CREATE DATABASE sales
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LOCALE_PROVIDER = 'libc'
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
```

### Tạo Bảng

```sql
SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;
ALTER SCHEMA public OWNER TO pg_database_owner;
COMMENT ON SCHEMA public IS 'standard public schema';
SET default_tablespace = '';
SET default_table_access_method = heap;
CREATE TABLE public.categories (
    c_id integer NOT NULL,
    c_name character varying(50) NOT NULL,
    c_description character varying(1000) NOT NULL,
    c_deleted boolean DEFAULT false NOT NULL
);
ALTER TABLE public.categories OWNER TO postgres;
CREATE SEQUENCE public.categories_sequence
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.categories_sequence OWNER TO postgres;
ALTER SEQUENCE public.categories_sequence OWNED BY public.categories.c_id;
CREATE TABLE public.discounts (
    dc_id integer NOT NULL,
    dc_code character(6) NOT NULL,
    dc_percent integer NOT NULL,
    dc_order_id integer DEFAULT '-1'::integer NOT NULL,
    dc_max_price integer DEFAULT 0 NOT NULL
);
ALTER TABLE public.discounts OWNER TO postgres;
CREATE SEQUENCE public.discounts_sequence
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.discounts_sequence OWNER TO postgres;
ALTER SEQUENCE public.discounts_sequence OWNED BY public.discounts.dc_id;
CREATE TABLE public.order_items (
    oi_id integer NOT NULL,
    oi_quantity integer NOT NULL,
    oi_unit_sale_price integer NOT NULL,
    oi_total_price integer NOT NULL,
    oi_product_id integer NOT NULL,
    oi_order_id integer NOT NULL,
    oi_deleted boolean DEFAULT false NOT NULL
);
ALTER TABLE public.order_items OWNER TO postgres;
CREATE SEQUENCE public.order_items_sequence
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.order_items_sequence OWNER TO postgres;
ALTER SEQUENCE public.order_items_sequence OWNED BY public.order_items.oi_id;
CREATE TABLE public.orders (
    o_id integer NOT NULL,
    o_status character(10) NOT NULL,
    o_date timestamp with time zone NOT NULL,
    o_deleted boolean DEFAULT false NOT NULL
);
ALTER TABLE public.orders OWNER TO postgres;
CREATE SEQUENCE public.orders_sequence
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.orders_sequence OWNER TO postgres;
ALTER SEQUENCE public.orders_sequence OWNED BY public.orders.o_id;
CREATE TABLE public.products (
    p_id integer NOT NULL,
    p_name character varying(1000) NOT NULL,
    p_sku character(10) NOT NULL,
    p_image_path character varying[] NOT NULL,
    p_import_price integer NOT NULL,
    p_unit_sale_price integer NOT NULL,
    p_count integer NOT NULL,
    p_description character varying NOT NULL,
    p_category_id integer NOT NULL,
    p_deleted boolean DEFAULT false NOT NULL
);
ALTER TABLE public.products OWNER TO postgres;
CREATE SEQUENCE public.products_sequence
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.products_sequence OWNER TO postgres;
ALTER SEQUENCE public.products_sequence OWNED BY public.products.p_id;
ALTER TABLE ONLY public.categories ALTER COLUMN c_id SET DEFAULT nextval('public.categories_sequence'::regclass);
ALTER TABLE ONLY public.discounts ALTER COLUMN dc_id SET DEFAULT nextval('public.discounts_sequence'::regclass);
ALTER TABLE ONLY public.order_items ALTER COLUMN oi_id SET DEFAULT nextval('public.order_items_sequence'::regclass);
ALTER TABLE ONLY public.orders ALTER COLUMN o_id SET DEFAULT nextval('public.orders_sequence'::regclass);
ALTER TABLE ONLY public.products ALTER COLUMN p_id SET DEFAULT nextval('public.products_sequence'::regclass);
ALTER TABLE ONLY public.categories
    ADD CONSTRAINT "Categories_pkey" PRIMARY KEY (c_id);
ALTER TABLE ONLY public.discounts
    ADD CONSTRAINT "Discounts_pkey" PRIMARY KEY (dc_id);
ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT "OrderItems_pkey" PRIMARY KEY (oi_id);
ALTER TABLE ONLY public.orders
    ADD CONSTRAINT "Orders_pkey" PRIMARY KEY (o_id);
ALTER TABLE ONLY public.products
    ADD CONSTRAINT "Products_pkey" PRIMARY KEY (p_id);
ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT "OrderItems_oi_orderId_fkey" FOREIGN KEY (oi_order_id) REFERENCES public.orders(o_id) NOT VALID;
ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT "OrderItems_oi_productId_fkey" FOREIGN KEY (oi_product_id) REFERENCES public.products(p_id) NOT VALID;
ALTER TABLE ONLY public.products
    ADD CONSTRAINT "Products_d_categoryId_fkey" FOREIGN KEY (p_category_id) REFERENCES public.categories(c_id) NOT VALID;
```
