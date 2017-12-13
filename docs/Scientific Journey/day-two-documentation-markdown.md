# Ghi chú bằng Markdown

Trước khi đến với R có một số kĩ năng chúng ta cần biết khi tham gia một dự án CNTT.

*funfact: Tất cả bài viết trên trang này đều được viết bằng Markdown*.

## Git

Tất cả các dự án CNTT có sự tham gia của 1 số người đều sử dụng 1 phần mềm quản lý phiên bản (version control). Phổ biến nhất trong số này là Git - được dùng trong cả giới khoa học lẫn giới công nghiệp.

Để sử dụng Git, chúng ta chỉ đơn giản download [Git](https://git-scm.com/). Các câu lệnh git có thể tra cứu rất đơn giản bằng câu lệnh `git -- help`. Tuy nhiên để sử dụng hàng ngày thì có một số các câu lệnh sau:

1. `git init` để khởi tạo một thư mục git (được gọi là một repo)
1. `git add .` để thêm tất cả các thay đổi của mình vào repo
1. `git commit -m "Message"` lưu các thay đổi này lại thành 1 version/commit
1. `git push` đẩy một commit lên server github (hoặc một server cá nhân)
1. `git pull` lấy phiên bản mới nhất của branch/repo
1. `git clone "repo-url"` tải một repo github về

Một số từ khóa cần tìm hiểu thêm là branch và fork. 2 khái niệm này giúp ta quản lý các thành phần của dự án dễ hơn, ví dụ như khi làm việc với Markdown và MKDocs ở dưới, chúng ta sẽ có 1 branch để quản lý các bài viết và 1 branch để công bố/render các bài viết này.

## Markdown

Trước khi có Markdown, giới khoa học thường sử dụng LaTex để soạn thảo các văn bản khoa học. Điểm mạnh của LaTex là nó rất nhiều plugin và công cụ hỗ trợ, tuy nhiên cú pháp của LaTex rất phức tạp và khó để học.

Để giải quyết vấn nạn này, Markdown ra đời như một ngôn ngữ đánh dấu nhẹ và dễ sử dụng. Toàn bộ cú pháp của Markdown có thể được tóm lược trong [một hai trang A4](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet). Vấn đề là khi chúng ta có một bài viết Markdown xong rồi thì làm gì? Đón đọc phần 3 (tối viết tiếp).

## Github Pages và MKDocs

Để làm một trang web tương tự trang này có rất nhiều lý do. Một trong số những lý do phổ biến là để làm tài liệu cho dự án (project page). Một lý do khác là do thích viết (như mình).

Trang web này được xây dựng trên Github Pages và MKDocs. Lý do là vì so với Wordpress (nền tảng trước đây mình viết), MKDocs sử dụng Markdown cho phép viết rất nhanh và dễ dàng tùy chỉnh. MKDocs cũng ổn định và tối giản hơn nhiều so với Wordpress.

Để cài đặt MKDocs hết sức đơn giản: `pip install mkdocs`. Mình khuyến khích mọi người tự tìm hiểu thêm về phần mềm này.

Để bắt đầu một trang web MKDocs, ta di chuyển đến folder chứa repo (xem phần dưới) chứa trang web của chúng ta, và dùng câu lệnh

```cmd
mkdocs init .
```

Các folder và file khác ta không cần quá chú trọng, quan trọng nhất lúc này là folder `docs` và file `mkdocs.yml`. Folder `docs` chứa tất cả tài liệu chúng ta sẽ viết. File `mkdocs.yml` chứa các thiết lập cho trang web.

Sau khi viết 1 tài liệu Markdown vào folder `docs`, câu lệnh `mkdocs build` sẽ xây dựng trang web của ta vào folder `site`. Việc cần làm tiếp theo là upload folder này lên server để cung cấp trang web. Đây là việc của câu lệnh `mkdocs gh-deploy`. Sẽ cần một số tùy chỉnh trong file `mkdocs.yml`. Điều này sẽ được nói thêm ở phần dưới.

---

Server của blog này được hỗ trợ bởi Github Pages. Dịch vụ này của Github nhằm cung cấp 1 nền tảng website HTML tĩnh (static HTML pages), dành cho việc công bố tài liệu của dự án, hoặc để mình lợi dụng làm web cá nhân.

Thông thường Github Pages được xây dựng bằng Jekyll. Tuy nhiên vì mình đã sử dụng Python, và không muốn cài thêm NodeJS nên trên này chúng ta sẽ dùng MKDocs để xây dựng 1 trang web.

Để đăng ký 1 trang Github Pages cá nhân, chúng ta cần tạo một repo có tên *`github-username`*`.github.io`, với *`github-username`* là tên Github của chúng ta. Lúc này, Github sẽ tự tạo một trang với tên miền *`github-username`*`.github.io` để chúng ta có thể sử dụng.

Để post MKDocs lên trang cá nhân này, sau khi clone repo trên về và cài đặt MKDocs tại folder của repo, chúng ta cần chỉnh sửa file `mkdocs.yml`. Mặc định MKDocs sẽ post bài theo cấu hình của Github Pages dành cho tổ chức thay vì cá nhân. Điểm khác biệt giữa 2 loại trang này là trang tổ chức cho phép post bài lên branch gp-deploy, trong khi trang cá nhân post bài lên branch master ([xem thêm về git branch](https://git-scm.com/docs/git-branch)).

Để cấu hình cho đúng với trang cá nhân, chỉ đơn giản thêm một dòng:

```yaml
remote_branch: master
```

Vậy thôi :smile: anh em chịu khó đọc thêm tài liệu nha.