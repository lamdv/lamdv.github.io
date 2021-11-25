# (Những) ngày đầu tiên

!["Icon Python"](../img/day-one-python-icon.png)

Thật ra mình đã làm trong dự án này được đến nay chắc cũng gần 3 tuần rồi. Không thế nói là ngày đầu tiên được, những thì may ra.

Trong bước đầu của dự án đang làm, công việc chính của mình là phát triển một module/engine Python để thu thập dữ liệu từ một vài cơ sở dữ liệu. Việc này được thực hiện bằng một số thư viện cơ bản của Python. Các thư viện này bao gồm pandas (xử lý dữ liệu dạng bảng), bs4 (xử lý dữ liệu DOM), requests (thực thi truy vấn HTTPS) và json (xử lý dữ liệu dạng JSON và chuyển hóa dữ liệu dạng từ điển - Dictionary sang dạng JSON trả về)

## Phương pháp ban đầu

Cách truyền thống để thực hiện các truy vấn này là viết các đoạn script để truy cập vào các trang web của các cơ sở dữ liệu nói trên và lấy kết quả trả về. Với phương pháp này, mỗi cơ sở dữ liệu mới sẽ có một đoạn script riêng để thực thi truy vấn và xử lý dữ liệu trả về. Phương pháp này khá đơn giản và hiệu quả với một số lượng nhỏ các cơ sở dữ liệu ít liên hệ với nhau. Code cũng sẽ minh bạch và tính bao đóng được đảm bảo.

Vấn đề với phương pháp này bắt đầu nảy sinh khi một số lượng lớn các cơ sở dữ liệu có quan hệ chồng chéo cần được xử lý. Sẽ không có cách nào hiệu quả để tìm hiểu mối quan hệ giữa các cơ sở dữ liệu này, DB nào truy vấn từ đâu những thông tin nào... Lượng code trùng lặp sẽ trở nên rất lớn khi đạt con số 10 - 12 cơ sở dữ liệu. Phần lớn khối lượng code sẽ là giống nhau: Thực hiện các truy vấn HTTPS, phân tách dữ liệu trả về, ghi dữ liệu vào các từ điển của Python và xuất chúng ra dưới dạng JSON. Người sử dụng các module này lại là các nhà sinh học với yêu cầu một giao diện dễ dàng giữa R và Python, trong khi hệ thống này không có cách nào sử dụng từ khóa như là 1 cách để truy cập các cơ sở dữ liệu.

Các vấn đề này đòi hỏi tái cấu trúc lại module Python sang một kiến trúc mới mạnh và tổng quan hơn.

## Đặc tả cơ sở dữ liệu

Đối mặt với các cơ sở dữ liệu, một cách tự nhiên ta nghĩ đến việc gom các phần code trùng lặp giữa các sript truy vấn cơ sở dữ liệu với nhau thành một máy truy vấn (query engine) mạnh và tổng quan. Các thành phần liên quan đến truy vấn mạng, HTTPS được hỗ trợ bởi thư viện requests hoàn toàn là trùng nhau qua các thành phần, và đã được gom lại vào module helper - đây là cách đặt tên theo quy ước dành cho một module chứa các hàm phụ trợ, không sử dụng như một thành phần của các đối tượng. Việc cần làm là viết các exception thông báo lỗi từ phía server để người dùng có thể tiến hành sửa chữa lỗi. Các thành phần phân tách dữ liệu cần được tổ chức lại hoàn toàn để có thể:

1. Phân giải dữ liệu chính xác giữa các cơ sở dữ liệu có cùng công nghệ trả về,
1. Chuyển đổi chế độ phân tách dữ liệu giữa các công nghệ khác nhau.

Để phân biệt giữa các chế độ phân tách khác nhau đòi hỏi cần có một phương pháp để phân biệt giữa các cơ sở dữ liệu, phân tích và phân loại chúng vào các nhóm khác nhau. Điều này cũng có lợi cho các truy vấn HTTPS, vì chúng ta cần phải có các đường dẫn đến các cơ sở dữ liệu. Các truy vấn HTTPS cũng được phân loại thành 2 method: POST và GET, điều này cũng cần được ghi chú lại và chuyển đổi giữa 2 chế độ.

Bài toán đặt ra trước mắt đòi hỏi thiết kế một cơ sở dữ liệu phụ trợ, lưu trữ thông tin về tất cả các cơ sở dữ liệu có trong truy vấn. Đây là một dạng siêu dữ liệu (metadata). Từ khóa này có vẻ cao siêu, nhưng thực tế chúng khá đơn giản. Chúng chứa các đặc tả về cấu trúc, các thông tin cần thiết và liên quan đến cơ sở dữ liệu chúng ta đang cần truy vấn.

Mình không muốn công bố đặc tả này ra trong bài này, vì đã đủ nặng về kỹ thuật. Tuy vậy một điều cần đặc biệt với việc sử dụng các metadata này là nó cho phép ta mở rộng số lượng các cơ sở dữ liệu có thể truy vấn lên theo cấp số cộng. Mỗi cơ sở dữ liệu mới giờ chỉ cần viết các mô tả này để có thể truy cập theo tên và các thông số truy vấn phù hợp. Điều này thỏa mãn các yêu cầu về tính tổng quan của engine truy vấn dữ liệu đang được xây dựng. Đây cũng là lý do tại sao trong ngành học máy có những nội dung rất quan trọng về khai phá siêu dữ liệu.

## Cấu trúc tối ưu

Công việc thiết kế đặc tả cơ sở dữ liệu phải được thực hiện song song với quá trình thiết kế kiến trúc máy truy vấn. Mỗi phần của cấu trúc đặc tả được viết ra khớp với giải thuật tương ứng của máy truy vấn.

Hiện tại cấu trúc máy truy vấn ổn định được thực hiện theo giải thuật sau:

1. Nhận chuỗi tên cơ sở dữ liệu cần truy vấn
1. Truy xuất cơ sở dữ liệu tương ứng với DOM cung cấp bởi bs4
1. Truy vấn cơ sở dữ liệu thông qua đường dẫn lưu trữ trong đặc tả
1. Xác định loại dữ liệu trả về - được lưu lại trước trong đặc tả
1. Phân giải dữ liệu theo cấu hình đã lưu trữ sẵn
1. Dịch kết quả sang cấu trúc JSON để R có thể phân tích

Kết thúc giai đoạn này của dự án, ta đã có thể truy cập các cơ sở dữ liệu với độ ổn định và đồng nhất cao cả về kết quả trả về lẫn hiệu năng truy xuất. Nền tảng này cũng dễ dàng được đưa vào áp dụng trong các bài toán khác ngoài ngành Tin sinh học.

Bài tiếp theo sẽ nói về R và các bài đầu tiên liên quan đến R. Giờ thì nghỉ thôi :wink: