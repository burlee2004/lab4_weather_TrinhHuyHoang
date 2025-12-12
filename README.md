**Weather Forecast App – Flutter**
**Trịnh Huy Hoàng – 2224802010159**

Link video demo: [https://drive.google.com/file/d/1G7Ia7MZJC-OvzuTcPERwXyON5V-vpdAf/view?usp=sharing](https://drive.google.com/file/d/1G7Ia7MZJC-OvzuTcPERwXyON5V-vpdAf/view?usp=sharing)

Ứng dụng Weather Forecast App được phát triển bằng Flutter và sử dụng OpenWeatherMap API để lấy dữ liệu thời tiết theo thời gian thực. Giao diện được thiết kế theo phong cách **Glassmorphism** trên nền **Gradient**, tạo cảm giác hiện đại và dễ theo dõi.

---

## **1. Chức năng chính**

### **1.1. Thời tiết hiện tại**

Ứng dụng cung cấp đầy đủ thông tin thời tiết tại vị trí người dùng chọn:

* **Nhiệt độ hiện tại**, cảm nhận thực tế, trạng thái thời tiết.
* **Độ ẩm**, **áp suất**, **tầm nhìn**.
* **Tốc độ gió và hướng gió**.
* **Chỉ số UV**.
* **Thời gian mặt trời mọc – lặn**.
* Giao diện có thể **thay đổi theo điều kiện thời tiết** (nắng, mưa, nhiều mây, ban đêm).

### **1.2. Dự báo theo giờ và 5 ngày**

* **Dự báo theo giờ** với thanh cuộn ngang, hiển thị nhiệt độ và trạng thái từng mốc thời gian.
* **Dự báo 5 ngày** với mức nhiệt cao/thấp và mô tả chi tiết từng ngày.

### **1.3. Tìm kiếm và quản lý địa điểm**

* Tìm kiếm bằng **tên thành phố**.
* Lưu **địa điểm yêu thích** và **lịch sử tìm kiếm**.
* Tự động lấy vị trí hiện tại bằng **GPS**.

### **1.4. Thiết lập**

* Chuyển đổi **đơn vị nhiệt độ**: °C / °F.
* Chọn **ngôn ngữ** giao diện.
* Chỉnh **12h / 24h**.
* Hỗ trợ **Dark Mode**.

### **1.5. Hoạt động Offline**

* Dữ liệu được **lưu cache** khi mất mạng.
* Ứng dụng **tự cập nhật** khi có Internet trở lại.

---

## **2. Hình ảnh giao diện**

### **Giao diện trang chủ**

<img width="647" height="1342" alt="image" src="https://github.com/user-attachments/assets/b05de994-f483-4400-ac6c-1f4f97078141" />
<img width="617" height="1333" alt="image" src="https://github.com/user-attachments/assets/110f413a-6af7-4ca7-bd51-bb72374e11ac" />

**Mô tả:**
Giao diện có nền gradient xanh dịu mắt. Các thành phần được bo tròn mềm mại. Phần hiển thị nhiệt độ được đặt nổi bật ở vị trí trung tâm, bên dưới là dự báo theo giờ và các chỉ số chi tiết. Tổng thể gọn gàng và hiện đại.

---

### **Dark Mode**

<img width="733" height="1349" alt="image" src="https://github.com/user-attachments/assets/197eabd1-2864-4a57-a0b3-73f6923274f8" />
<img width="656" height="1345" alt="image" src="https://github.com/user-attachments/assets/261d3261-ccd6-48a7-844c-1d07a0742b26" />

**Mô tả:**
Chế độ tối giúp người dùng dễ nhìn khi sử dụng vào ban đêm hoặc nơi thiếu sáng.

---

### **Dự báo 5 ngày**

<img width="625" height="1330" alt="image" src="https://github.com/user-attachments/assets/7784fee9-0291-4a73-9304-f3c500136646" />

**Mô tả:**
Hiển thị thông tin dự báo theo từng khung giờ và từng ngày, giúp người dùng chủ động cho các kế hoạch như đi học, đi làm hoặc du lịch.

---

### **Giao diện cài đặt**

<img width="642" height="1330" alt="image" src="https://github.com/user-attachments/assets/8c331615-9e36-4db9-a4e8-4b365144c400" />

**Mô tả:**
Màn hình cho phép điều chỉnh đơn vị đo, định dạng thời gian và giao diện. Nút Reset ở cuối giúp đưa ứng dụng về mặc định.

---

### **Giao diện tìm kiếm**

<img width="651" height="1350" alt="image" src="https://github.com/user-attachments/assets/e22b9af3-62ec-495b-a9cb-ba6b37b3a80b" />

**Mô tả:**
Thiết kế tối, liệt kê sẵn một số thành phố phổ biến và hiển thị lịch sử tìm kiếm ngay bên dưới. Người dùng có thể tra cứu nhanh mà không cần nhập lại nhiều lần.

---

## **3. Cài đặt và chạy dự án**

```
flutter pub get
flutter run
```

---

## **4. Cấu trúc thư mục**

```
D:.
│   main.dart
│
├───config
│       api_config.dart
│
├───models
│       forecast_model.dart
│       hourly_weather_model.dart
│       location_model.dart
│       weather_model.dart
│
├───providers
│       location_provider.dart
│       settings_provider.dart
│       weather_provider.dart
│
├───screens
│       forecast_screen.dart
│       home_screen.dart
│       search_screen.dart
│       settings_screen.dart
│
├───services
│       connectivity_service.dart
│       location_service.dart
│       storage_service.dart
│       weather_service.dart
│
├───utils
│       constants.dart
│       date_formatter.dart
│       weather_icons.dart
│
└───widgets
        current_weather_card.dart
        daily_forecast_card.dart
        error_widget.dart
        hourly_forecast_list.dart
        loading_shimmer.dart
        weather_detail_item.dart
```
