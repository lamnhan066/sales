import 'package:language_helper/language_helper.dart';

final en = <String, dynamic>{
  ///===========================================================================
  /// Path: ./lib/core/utils/price_utils.dart
  ///===========================================================================
  '@path_./lib/core/utils/price_utils.dart': '',
  'Tối đa': 'Maximum',

  ///===========================================================================
  /// Path: ./lib/di.dart
  ///===========================================================================
  '@path_./lib/di.dart': '',
  'Giới Thiệu': 'Introduction',
  'Trang này có một số chức năng mới mà bạn có thể muốn khám phá.\n\n'
      'Bạn có muốn khám phá không?': 'This page has some new features that you might want to explore.\n\n'
      'Would you like to explore them?',
  'Áp dụng với tất cả các trang': 'Apply to all pages',
  'Chấp nhận': 'Accept',
  'Để sau': 'Later',
  'Bỏ qua': 'Skip',
  'Bỏ Qua': 'Skip',
  'Tiếp': 'Next',
  'Hoàn Thành': 'Complete',

  ///===========================================================================
  /// Path: ./lib/infrastructure/respositories/local_auth_repository_impl.dart
  ///===========================================================================
  '@path_./lib/infrastructure/respositories/local_auth_repository_impl.dart': '',
  'Sai tên đăng nhập hoặc mật khẩu': 'Incorrect username or password',
  'Không có thông tin đăng nhập được lưu': 'No login information is saved',

  ///===========================================================================
  /// Path: ./lib/infrastructure/respositories/backup_restore_repository_impl.dart
  ///===========================================================================
  '@path_./lib/infrastructure/respositories/backup_restore_repository_impl.dart': '',
  'Lưu Bản Sao Lưu': 'Save Backup',
  'Không có đường dẫn được chọn': 'No path selected',
  'Không thể ghi bản sao lưu vào tệp': 'Cannot write the backup to file',
  'Chọn Bản Sao Lưu': 'Select Backup',
  'Không chọn được bản sao lưu': 'Unable to select backup',
  'Bản sao lưu không đúng định dạng': 'Backup is not in the correct format',

  ///===========================================================================
  /// Path: ./lib/infrastructure/exceptions/backup_exception.dart
  ///===========================================================================
  '@path_./lib/infrastructure/exceptions/backup_exception.dart': '',
  'Sao lưu lỗi': 'Backup Error',

  ///===========================================================================
  /// Path: ./lib/infrastructure/exceptions/server_exception.dart
  ///===========================================================================
  '@path_./lib/infrastructure/exceptions/server_exception.dart': '',
  'Lỗi máy chủ': 'Server Error',

  ///===========================================================================
  /// Path: ./lib/infrastructure/exceptions/restore_exception.dart
  ///===========================================================================
  '@path_./lib/infrastructure/exceptions/restore_exception.dart': '',
  'Khôi phục lỗi': 'Restore Error',

  ///===========================================================================
  /// Path: ./lib/infrastructure/exceptions/data_import_exception.dart
  ///===========================================================================
  '@path_./lib/infrastructure/exceptions/data_import_exception.dart': '',
  'Lỗi nhập dữ liệu': 'Data Import Error',

  ///===========================================================================
  /// Path: ./lib/infrastructure/services/database_service_impl.dart
  ///===========================================================================
  '@path_./lib/infrastructure/services/database_service_impl.dart': '',
  'Không thể kết nối được với máy chủ': 'Unable to connect to the server',
  'Lưu Danh Sách Sản Phẩm Mẫu': 'Save Template Product List',
  // 'Không có đường dẫn được chọn': 'Không có đường dẫn được chọn',  // Duplicated
  'Không thể ghi sản phẩm mẫu vào tệp': 'Cannot write template product to file',

  ///===========================================================================
  /// Path: ./lib/domain/usecases/data_services/import_data_usecase.dart
  ///===========================================================================
  '@path_./lib/domain/usecases/data_services/import_data_usecase.dart': '',
  'Đã có lỗi xảy ra khi nhập dữ liệu, vui lòng kiểm tra lại dữ liệu mẫu':
      'An error occurred while importing data, please check the sample data',

  ///===========================================================================
  /// Path: ./lib/domain/entities/order_status.dart
  ///===========================================================================
  '@path_./lib/domain/entities/order_status.dart': '',
  'Đã tạo': 'Created',
  'Đã thanh toán': 'Paid',
  'Đã huỷ': 'Cancelled',

  ///===========================================================================
  /// Path: ./lib/presentation/riverpod/notifiers/login_provider.dart
  ///===========================================================================
  '@path_./lib/presentation/riverpod/notifiers/login_provider.dart': '',
  'Vui lòng kích hoạt bản quyền để tiếp tục sử dụng': 'Please activate the license to continue using',
  'Đã có lỗi không xác định!': 'An unknown error occurred!',
  // 'Vui lòng kích hoạt bản quyền để tiếp tục sử dụng': 'Please activate the license to continue using',  // Duplicated
  // 'Đã có lỗi không xác định!': 'An unknown error occurred!',  // Duplicated
  'Không thể kích hoạt bản dùng thử': 'Unable to activate the trial version',
  // 'Không thể kích hoạt bản dùng thử': 'Unable to activate the trial version',  // Duplicated
  'Không thể kích hoạt với mã đã nhập': 'Unable to activate with the entered code',

  ///===========================================================================
  /// Path: ./lib/presentation/riverpod/notifiers/settings_provider.dart
  ///===========================================================================
  '@path_./lib/presentation/riverpod/notifiers/settings_provider.dart': '',
  'Đang chuẩn bị dữ liệu...': 'Preparing data...',
  'Chọn vị trí lưu và lưu bản sao lưu...': 'Select the save location and save the backup...',
  'Sao lưu đã hoàn tất tại': 'Backup completed at',
  'Đang lấy dữ liệu đã sao lưu...': 'Retrieving backed-up data...',
  'Xoá tất cả dữ liệu hiện tại...': 'Delete all current data...',
  'Đang tiến hành khôi phục Loại Hàng...': 'Restoring Categories...',
  'Đang tiến hành khôi phục Sản Phẩm...': 'Restoring Products...',
  'Đang tiến hành khôi phục Đơn Hàng và Chi Tiết Đơn hàng...': 'Restoring Orders and Order Details...',
  'Đang tiếm hành khôi phục Khuyến Mãi': 'Restoring Promotion in Progress',
  'Khôi phục đã hoàn tất': 'Restore completed',

  ///===========================================================================
  /// Path: ./lib/presentation/views/home_view.dart
  ///===========================================================================
  '@path_./lib/presentation/views/home_view.dart': '',
  'Tổng Quan': 'Overview',
  'Đơn Hàng': 'Orders',
  'Sản Phẩm': 'Products',
  'Báo Cáo': 'Reports',
  'Cài Đặt': 'Settings',
  'Khuyến Mãi': 'Promotion',
  'Đăng Xuất': 'Logout',

  ///===========================================================================
  /// Path: ./lib/presentation/views/products_view.dart
  ///===========================================================================
  '@path_./lib/presentation/views/products_view.dart': '',
  'Error: @{error}': 'Lỗi: @{error}',
  'Nhấn vào đây để thêm sản phẩm mới': 'Click here to add a new product',
  'Thêm sản phẩm mới': 'Add new product',
  'Nhấn vào đây để tải xuống mẫu dữ liệu': 'Click here to download sample data',
  'Tải xuống dữ liệu mẫu': 'Download sample data',
  'Nhấn vào đây để tải lên dữ liệu từ Excel': 'Click here to upload data from Excel',
  'Tải lên dữ liệu từ Excel': 'Upload data from Excel',
  'Tìm kiếm sản phẩm theo tên tại đây': 'Search for products by name here',
  'Tìm Kiếm': 'Search',
  'Nhấn vào đây để hiển thị tuỳ chọn lọc sản phẩm': 'Click here to display product filter options',
  'Lọc sản phẩm': 'Filter products',
  'Nhấn vào đây để hiển thị tuỳ chọn sắp xếp sản phẩm': 'Tap here to display product sorting options',
  'Sắp xếp sản phẩm': 'Sort products',
  'STT': 'No.',
  'ID': 'ID',
  'Tên': 'Name',
  'Giá nhập': 'Purchase Price',
  'Giá bán': 'Selling Price',
  'Loại hàng': 'Category',
  'Số lượng': 'Quantity',
  'Hành động': 'Action',
  'Nhấn vào đây để thêm sản phẩm vào giỏ hàng': 'Click here to add the product to the cart',
  'Nhấn vào đây để xem chi tiết sản phẩm': 'Click here to view product details',
  'Nhấn vào đây để cập nhật sản phẩm': 'Click here to update the product',
  'Nhấn vào đây để sao chép sản phẩm': 'Click here to duplicate the product',
  'Nhấn vào đây để xoá sản phẩm': 'Click here to delete the product',
  'Thông báo': 'Notification',
  'Bạn cần có it nhất một loại hàng để có thể thêm sản phẩm.\n\n'
      'Bạn có muốn thêm loại hàng không?': 'You need at least one category to add a product.\n\n'
      'Do you want to add a category?',
  'Đồng ý': 'Agree',
  'Huỷ': 'Cancel',
  'Xác nhận': 'Confirm',
  'Bạn có chắc muốn xoá sản phẩm @{name} không?': 'Are you sure you want to delete the product @{name}?',
  // 'Đồng ý': 'Agree',  // Duplicated
  // 'Huỷ': 'Cancel',  // Duplicated
  'Bộ lọc': 'Filter',
  'OK': 'OK',
  // 'Huỷ': 'Cancel',  // Duplicated
  'Sắp xếp': 'Sort',
  // 'OK': 'OK',  // Duplicated
  // 'Huỷ': 'Cancel',  // Duplicated
  'Nhập Excel': 'Import Excel',
  // 'Nhập Excel': 'Import Excel',  // Duplicated
  'Bạn chưa chọn tệp hoặc tệp chưa được hỗ trợ': 'You have not selected a file or the file is not supported',
  // 'Nhập Excel': 'Import Excel',  // Duplicated
  'Dữ liệu bạn đang chọn trống!': 'The data you selected is empty!',
  'Ok': 'Ok',
  // 'Nhập Excel': 'Import Excel',  // Duplicated
  'Có @{count} sản phẩm trong dữ liệu cần nhập. '
      'Dữ liệu mới sẽ thay thế dữ liệu cũ và không thể hoàn tác.\n\n'
      'Bạn có muốn tiếp tục không?': const LanguageConditions(
    param: 'count',
    conditions: {
      '0': 'There are 0 products in the data to be imported. '
          'The new data will replace the old data and cannot be undone.\n\n'
          'Do you want to continue?',
      '1': 'There is 1 product in the data to be imported. '
          'The new data will replace the old data and cannot be undone.\n\n'
          'Do you want to continue?',
      '_': 'There are @{count} products in the data to be imported. '
          'The new data will replace the old data and cannot be undone.\n\n'
          'Do you want to continue?',
    },
  ),
  // 'Đồng ý': 'Agree',  // Duplicated
  // 'Huỷ': 'Cancel',  // Duplicated
  // 'Thông báo': 'Notification',  // Duplicated
  // 'Bạn cần có it nhất một loại hàng để có thể thêm sản phẩm.\n\n' 'Bạn có muốn thêm loại hàng không?': 'You need at least one category to add a product.\n\n' 'Do you want to add a category?',  // Duplicated
  // 'Đồng ý': 'Agree',  // Duplicated
  // 'Huỷ': 'Cancel',  // Duplicated
  'Không': 'No',
  'Tên tăng dần': 'Name Ascending',
  'Tên giảm dần': 'Name Descending',
  'Giá tăng dần': 'Price Ascending',
  'Giá giảm dần': 'Price Descending',
  'Số lượng tăng đần': 'Quantity Ascending',
  'Số lượng giảm đần': 'Quantity Descending',
  'Trở về': 'Go Back',
  'Sản Phẩm Nháp': 'Draft Product',
  'Hiện tại bạn đang có một sản phẩm nháp, bạn có muốn tiếp tục chỉnh sửa và thêm sản phẩm không?':
      'You currently have a draft product, would you like to continue editing and adding the product?',
  'Tiếp tục': 'Continue',
  'Huỷ sản phẩm': 'Cancel product',

  ///===========================================================================
  /// Path: ./lib/presentation/views/login_view.dart
  ///===========================================================================
  '@path_./lib/presentation/views/login_view.dart': '',
  'Chào mừng bạn trở lại!': 'Welcome back!',
  'Đăng nhập': 'Login',
  'Chào mừng bạn đã trở lại! Vui lòng đăng nhập để tiếp tục': 'Welcome back! Please log in to continue',
  'Tên tài khoản': 'Username',
  'Mật khẩu': 'Password',
  'Nhớ thông tin của tôi': 'Remember me',
  'Đăng Nhập': 'Login',
  'Cấu hình máy chủ': 'Server Configuration',
  'Phiên bản: @{version}': 'Version: @{version}',
  'Cấu Hình Máy Chủ': 'Server Configuration',
  'Lưu': 'Save',
  // 'Huỷ': 'Cancel',  // Duplicated
  'Đang tự động đăng nhập...': 'Logging in automatically...',
  // 'Huỷ': 'Cancel',  // Duplicated
  'Bạn đang sử dụng bản quyền. Còn @{day} ngày.': 'You are using a licensed version. @{day} days remaining.',
  'Kích Hoạt': 'Activate',
  'Bạn đã hết thời gian dùng thử.\nVui lòng nhập mã để kích hoạt ứng dụng':
      'Your trial period has ended.\nPlease enter a code to activate the application.',
  'Bạn đang sử dụng bản dùng thử. Còn @{day} ngày.': 'You are using a trial version. @{day} days remaining.',
  // 'Kích Hoạt': 'Kích Hoạt',  // Duplicated
  'Bạn đã hết thời gian sử dụng.\nVui lòng nhập mã để kích hoạt ứng dụng':
      'Your usage period has ended.\nPlease enter a code to activate the application.',
  'Bạn có 15 ngày để dùng thử.\nVui lòng nhấn Kích Hoạt để tiếp tục':
      'You have 15 days to try.\nPlease press Activate to continue.',
  // 'Kích Hoạt': 'Kích Hoạt',  // Duplicated
  'Mã kích hoạt': 'Activation Code',
  // 'Kích Hoạt': 'Kích Hoạt',  // Duplicated

  ///===========================================================================
  /// Path: ./lib/presentation/views/settings_view.dart
  ///===========================================================================
  '@path_./lib/presentation/views/settings_view.dart': '',
  'Ngôn Ngữ': 'Language',
  'Chế Độ Tối': 'Dark Mode',
  'Lưu màn hình cuối cho lần mở tiếp theo': 'Save the last screen for the next time',
  'Mặc định sẽ mở trang Tổng Quan': 'The Overview page will open by default',
  'Số dòng mỗi trang khi phân trang': 'Rows per page during pagination',
  'Sao Lưu và Khôi Phục': 'Backup and Restore',
  'Sao Lưu': 'Backup',
  'Khôi Phục': 'Restore',

  ///===========================================================================
  /// Path: ./lib/presentation/views/dashboard_view.dart
  ///===========================================================================
  '@path_./lib/presentation/views/dashboard_view.dart': '',
  // 'Error: @{error}': 'Error: @{error}',  // Duplicated
  'Nhấn vào đây để chọn ngày thống kê ở trang tổng quan': 'Click here to select a date for statistics on the dashboard',
  'Biểu đồ doanh thu theo ngày trong tháng @{month}': 'Revenue chart by day in the month of @{month}',
  'Chi tiết 3 đơn hàng gần nhất': 'Details of the 3 most recent orders',
  'Tên Sản Phẩm': 'Product Name',
  'Số Lượng': 'Quantity',
  'Thành Tiền': 'Total Amount',
  'Tổng cộng': 'Total',
  'Top 5 sản phẩm bán chạy': 'Top 5 Bestselling Products',
  'Tên sản phẩm': 'Product Name',
  // 'Số lượng': 'Số lượng',  // Duplicated
  'Top 5 sản phẩm sắp hết hàng': 'Top 5 Products Nearly Out of Stock',
  // 'Tên sản phẩm': 'Tên sản phẩm',  // Duplicated
  // 'Số lượng': 'Số lượng',  // Duplicated
  'Tổng doanh thu trong ngày': 'Total revenue per day',
  '@{dailyRevenue} đồng': '@{dailyRevenue} VND',
  'Tổng số đơn hàng trong ngày': 'Total orders per day',
  '@{count} đơn': const LanguageConditions(
    param: 'count',
    conditions: {
      '0': '0 orders',
      '1': '1 order',
      '_': '@{count} orders',
    },
  ),
  'Tổng số sản phẩm': 'Total number of products',
  '@{count} sản phẩm': const LanguageConditions(
    param: 'count',
    conditions: {
      '0': '0 products',
      '1': '1 product',
      '_': '@{count} products',
    },
  ),

  ///===========================================================================
  /// Path: ./lib/presentation/views/discount_view.dart
  ///===========================================================================
  '@path_./lib/presentation/views/discount_view.dart': '',
  'Nhấn vào đây để thêm mã giảm giá': 'Tap here to add a discount code',
  'Thêm khuyến mãi': 'Thêm khuyến mãi',
  // 'STT': 'STT',  // Duplicated
  'Mã': 'Code',
  'Phần trăm': 'Percentage',
  // 'Tối đa': 'Tối đa',  // Duplicated
  // 'Hành động': 'Action',  // Duplicated
  // 'Không': 'No',  // Duplicated
  'Nhấn vào đây để chép mã giảm giá': 'Nhấn vào đây để chép mã giảm giá',
  'Nhấn vào đây để xoá mã giảm giá': 'Nhấn vào đây để xoá mã giảm giá',
  'Đã sao chép mã: @{code}': 'Code copied: @{code}',
  // 'Xác nhận': 'Confirm',  // Duplicated
  'Bạn có chắc muốn xoá mã giảm giá @{code} không?': 'Are you sure you want to delete the discount code @{code}?',
  // 'Đồng ý': 'Agree',  // Duplicated
  // 'Huỷ': 'Cancel',  // Duplicated

  ///===========================================================================
  /// Path: ./lib/presentation/views/orders_view.dart
  ///===========================================================================
  '@path_./lib/presentation/views/orders_view.dart': '',
  'Nhấn vào đây để thêm đơn hàng': 'Click here to add an order',
  'Thêm đơn hàng mới': 'Add new order',
  'Nhấn vào đây để mở tuỳ chọn lọc đơn hàng': 'Tap here to open order filter options',
  'Bộ lọc đơn hàng': 'Order filter',
  // 'Error: @{error}': 'Error: @{error}',  // Duplicated
  // 'STT': 'No.',  // Duplicated
  'Ngày Giờ': 'Date & Time',
  'Trạng Thái': 'Status',
  // 'Hành động': 'Action',  // Duplicated
  'Nhấn vào đây để xem chi tiết đơn hàng': 'Click here to view order details',
  'Nhấn vào đây để cập nhật chi tiết đơn hàng': 'Click here to update order details',
  'Nhấn vào đây để sao chép chi tiết đơn hàng': 'Click here to duplicate order details',
  'Nhấn vào đây để xoá đơn hàng': 'Click here to delete the order',
  // 'Xác nhận': 'Confirm',  // Duplicated
  'Bạn có chắc muốn xoá đơn này không?': 'Are you sure you want to delete this order?',
  // 'Đồng ý': 'Agree',  // Duplicated
  // 'Huỷ': 'Cancel',  // Duplicated
  // 'Bộ lọc': 'Filter',  // Duplicated
  // 'OK': 'OK',  // Duplicated
  // 'Huỷ': 'Cancel',  // Duplicated
  'Đơn Hàng Nháp': 'Draft Order',
  'Hiện tại bạn đang có một đơn hàng nháp, bạn có muốn tiếp tục chỉnh sửa và thêm đơn hàng không?':
      'You currently have a draft order, would you like to continue editing and adding the order?',
  // 'Tiếp tục': 'Continue',  // Duplicated
  'Huỷ đơn': 'Cancel order',

  ///===========================================================================
  /// Path: ./lib/presentation/views/report_view.dart
  ///===========================================================================
  '@path_./lib/presentation/views/report_view.dart': '',
  'Nhấn vào đây để hiển thị tuỳ chọn bộ lọc cho báo cáo': 'Click here to display filter options for the report',
  'Lọc báo cáo theo thời gian': 'Filter report by time',
  'Sản phẩm và số lượng bán tương ứng:': 'Products and corresponding sales quantities:',
  // 'Tên Sản Phẩm': 'Product Name',  // Duplicated
  // 'Số Lượng': 'Quantity',  // Duplicated
  'Doanh thu và lợi nhuận:': 'Revenue and Profit:',
  'Doanh thu': 'Revenue',
  'Lợi nhuận': 'Profit',
  'Doanh thu: @{price}': 'Revenue: @{price}',
  'Lợi nhuận: @{price}': 'Profit: @{price}',
  // 'Bộ lọc': 'Filter',  // Duplicated
  // 'OK': 'OK',  // Duplicated
  // 'Huỷ': 'Cancel',  // Duplicated
  'Báo cáo trong tuần hiện tại từ @{fromDate} đến @{toDate}':
      'Report for the current week from @{fromDate} to @{toDate}',
  'Báo cáo trong tháng hiện tại từ @{fromDate} to @{toDate}':
      'Report for the current month from @{fromDate} to @{toDate}',
  'Báo cáo từ @{fromDate} đến @{toDate}': 'Report from @{fromDate} to @{toDate}',

  ///===========================================================================
  /// Path: ./lib/presentation/widgets/image_dialog.dart
  ///===========================================================================
  '@path_./lib/presentation/widgets/image_dialog.dart': '',
  'Thêm Ảnh': 'Add Image',
  'Thêm': 'Add',
  // 'Huỷ': 'Cancel',  // Duplicated
  'Xoá Ảnh': 'Delete Image',
  'Bạn có chắc muốn xoá ảnh này không?': 'Are you sure you want to delete this image?',
  'Có': 'Yes',
  // 'Không': 'No',  // Duplicated
  'Vui lòng chọn ảnh từ đường dẫn\ntừ máy hoặc internet':
      'Please select an image from a path\nfrom the device or the internet',
  'Đường dẫn': 'Path',
  'Chọn ảnh từ máy': 'Select image from device',

  ///===========================================================================
  /// Path: ./lib/presentation/widgets/category_dialog.dart
  ///===========================================================================
  '@path_./lib/presentation/widgets/category_dialog.dart': '',
  'Chi Tiết Loại Hàng': 'Category Details',
  'Thêm Loại Hàng': 'Add Category',
  'Sửa Loại Hàng': 'Edit Category',
  // 'Xác nhận': 'Confirm',  // Duplicated
  'Bạn có chắc muốn xoá loại hàng @{name} không?': 'Are you sure you want to delete the category @{name}?',
  // 'Đồng ý': 'Agree',  // Duplicated
  // 'Huỷ': 'Cancel',  // Duplicated
  // 'Tên': 'Name',  // Duplicated
  'Mô tả': 'Description',
  // 'OK': 'OK',  // Duplicated
  // 'Huỷ': 'Cancel',  // Duplicated

  ///===========================================================================
  /// Path: ./lib/presentation/widgets/discount_dialogs.dart
  ///===========================================================================
  '@path_./lib/presentation/widgets/discount_dialogs.dart': '',
  'Vui lòng chỉ nhập số': 'Please enter only numbers',
  'Số phải lớn hơn 0': 'The number must be greater than 0',
  'Số phải <= 100': 'The number must be <= 100',
  // 'Vui lòng chỉ nhập số': 'Please enter only numbers',  // Duplicated
  'Thêm Mã Giảm Giá': 'Add Discount Code',
  'Số % giảm (0 - 100)': 'Discount percentage (0 - 100)',
  'Số lượng mã': 'Number of codes',
  'Giá giảm tối đa': 'Maximum discount amount',
  'Không giới hạn giá giảm': 'No discount limit',
  // 'Thêm': 'Add',  // Duplicated

  ///===========================================================================
  /// Path: ./lib/presentation/widgets/order_filter_dialog.dart
  ///===========================================================================
  '@path_./lib/presentation/widgets/order_filter_dialog.dart': '',
  'Lọc theo khoảng thời gian': 'Filter by time period',
  'Từ': 'From',
  'Đến': 'To',

  ///===========================================================================
  /// Path: ./lib/presentation/widgets/order_form_dialog.dart
  ///===========================================================================
  '@path_./lib/presentation/widgets/order_form_dialog.dart': '',
  'Chọn Sản Phẩm': 'Select Product',
  'Mã đã nhập không tồn tại hoặc đã được sử dụng': 'The entered code does not exist or has already been used',
  'Có sản phẩm không đủ số lượng trong kho nên không thể Sao chép.\n'
      'Vui lòng cập nhật thêm sản phẩm để tiếp tục!': 'Some products do not have enough stock to duplicate.\n'
      'Please update the product stock to continue!',
  // 'Ngày Giờ': 'Date & Time',  // Duplicated
  'Trạng thái': 'Status',
  // 'Trạng thái': 'Status',  // Duplicated
  // 'STT': 'No.',  // Duplicated
  // 'Tên Sản Phẩm': 'Product Name',
  // 'Số Lượng': 'Quantity',
  'Đơn Giá': 'Unit Price',
  // 'Thành Tiền': 'Total Price',
  'Hành Động': 'Action',
  'Giảm giá': 'Giảm giá',
  // 'Tối đa': 'Tối đa',  // Duplicated
  // 'Giảm giá': 'Giảm giá',  // Duplicated
  'Tổng': 'Tổng',
  'Mã Giảm Giá': 'Mã Giảm Giá',
  'Kiểm Tra': 'Kiểm Tra',

  ///===========================================================================
  /// Path: ./lib/presentation/widgets/product_form_dialog.dart
  ///===========================================================================
  '@path_./lib/presentation/widgets/product_form_dialog.dart': '',
  'Mã sản phẩm': 'Product Code',
  // 'Tên sản phẩm': 'Product Name',
  // 'Giá nhập': 'Purchase Price',  // Duplicated
  // 'Vui lòng chỉ nhập số': 'Please enter numbers only',
  // 'Giá bán': 'Selling Price',  // Duplicated
  // 'Vui lòng chỉ nhập số': 'Please enter numbers only',  // Duplicated
  // 'Số lượng': 'Quantity',  // Duplicated
  // 'Vui lòng chỉ nhập số': 'Please enter numbers only',  // Duplicated
  // 'Loại hàng': 'Category',  // Duplicated
  // 'Loại hàng': 'Category',  // Duplicated
  'Hình ảnh': 'Image',
  'Chưa có hình ảnh': 'No image available',
  // 'Mô tả': 'Description',  // Duplicated

  ///===========================================================================
  /// Path: ./lib/presentation/widgets/order_dialog.dart
  ///===========================================================================
  '@path_./lib/presentation/widgets/order_dialog.dart': '',
  'Thông Tin Đơn': 'Order Information',
  'Thêm Đơn': 'Add Order',
  'Sửa Đơn': 'Edit Order',
  'Chép Đơn': 'Duplicate Order',
  // 'OK': 'OK',  // Duplicated
  // 'Huỷ': 'Cancel',  // Duplicated
  // 'OK': 'OK',  // Duplicated

  ///===========================================================================
  /// Path: ./lib/presentation/widgets/page_chooser_dialog.dart
  ///===========================================================================
  '@path_./lib/presentation/widgets/page_chooser_dialog.dart': '',
  'Bạn cần nhập số trang': 'You need to enter a page number',
  'Số trang phải là số nguyên': 'The page number must be an integer',
  'Số trang phải >= 1': 'The page number must be >= 1',
  'Số trang phải <= @{totalPage}': 'The page number must be <= @{totalPage}',
  'Chọn trang': 'Select page',
  // 'OK': 'OK',  // Duplicated
  // 'Huỷ': 'Cancel',  // Duplicated

  ///===========================================================================
  /// Path: ./lib/presentation/widgets/common_components.dart
  ///===========================================================================
  '@path_./lib/presentation/widgets/common_components.dart': '',
  // 'Xác nhận': 'Xác nhận',  // Duplicated
  // 'Trở về': 'Trở về',  // Duplicated

  ///===========================================================================
  /// Path: ./lib/presentation/widgets/product_dialog.dart
  ///===========================================================================
  '@path_./lib/presentation/widgets/product_dialog.dart': '',
  'Thông Tin Sản Phẩm': 'Product Information',
  'Thêm Sản Phẩm': 'Add Product',
  'Sửa Sản Phẩm': 'Edit Product',
  'Chép Sản Phẩm': 'Duplicate Product',
  // 'Xác nhận': 'Confirm',  // Duplicated
  // 'Bạn có chắc muốn xoá sản phẩm @{name} không?': 'Are you sure you want to delete the product @{name}?',  // Duplicated
  // 'Đồng ý': 'Agree',  // Duplicated
  // 'Huỷ': 'Cancel',  // Duplicated
  // 'OK': 'OK',  // Duplicated
  // 'Huỷ': 'Cancel',  // Duplicated

  ///===========================================================================
  /// Path: ./lib/presentation/widgets/report_filter_dialog.dart
  ///===========================================================================
  '@path_./lib/presentation/widgets/report_filter_dialog.dart': '',
  // 'Lọc theo khoảng thời gian': 'Filter by time period',  // Duplicated
  '7 ngày gần đây nhất': 'Last 7 days',
  '30 ngày gần đây nhất': 'Last 30 days',
  'Tuỳ chọn': 'Options',
  // 'Từ': 'From',  // Duplicated
  // 'Đến': 'To',  // Duplicated

  ///===========================================================================
  /// Path: ./lib/presentation/widgets/product_filter_dialog.dart
  ///===========================================================================
  '@path_./lib/presentation/widgets/product_filter_dialog.dart': '',
  'Lọc theo mức giá': 'Filter by price range',
  // 'Từ': 'From',  // Duplicated
  'Không được bỏ trống': 'Cannot be empty',
  'Phải là số nguyên': 'Must be an integer',
  // 'Đến': 'To',  // Duplicated
  // 'Tối đa': 'Maximum',  // Duplicated
  // 'Không được bỏ trống': 'Cannot be empty',  // Duplicated
  // 'Phải là số nguyên': 'Must be an integer',  // Duplicated
  'Lọc theo loại hàng': 'Filter by category',
  // 'Loại hàng': 'Category',  // Duplicated
  'Tất cả': 'All',
};
