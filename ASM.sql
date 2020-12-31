CREATE DATABASE ASM
GO
USE ASM
GO
CREATE TABLE PhoneBook
(
	PhoneBookID INT IDENTITY,
	Name NVARCHAR(50),
	[Address] NVARCHAR(100),
	DateBirth DATETIME,
	CONSTRAINT PK_PhoneBookID PRIMARY KEY (PhoneBookID)
)
CREATE TABLE Phone
(
	PhoneID INT IDENTITY,
	PhoneBookID INT,
	NetWork VARCHAR(50),
	CONSTRAINT PK_PhoneID PRIMARY KEY (PhoneID),
	CONSTRAINT FK_PhoneBookID FOREIGN KEY (PhoneBookID) REFERENCES PhoneBook(PhoneBookID)
)

--3. Viết các câu lệnh để thêm dữ liệu vào các bảng
INSERT INTO PhoneBook
VALUES
(N'Nguyễn Văn Nam',N'30 Xuân Thủy, Cầu Giấy, Hà Nội','12/12/2009'),
(N'Nguyễn Văn An',N'111 Nguyễn Trãi, Thanh Xuân, Hà Nội','11/18/1987'),
(N'Nguyễn Thị Hoa',N'123 Kiều Mai, Bắc Từ Liêm, Hà Nội','05/28/1993'),
(N'Bùi Thị Xuân',N'37 Kim Mã, Ba Đình, Hà Nội','01/09/1987'),
(N'Trần Văn Thuyên',N'78 Lạch Tray, Hải Phòng','11/18/1995'),
(N'Trần Thị Tươi',N'23 Xuân Thủy, Cầu Giấy, Hà Nội','12/15/1977')
SELECT * FROM PhoneBook
ALTER TABLE Phone
	ADD Phone VARCHAR(10);
INSERT INTO Phone
VALUES(2,'Viettel','987654321'),
(2,'Mobifone','09873452'),
(2,'Mobifone','09832323'),
(2,'Vinaphone','09434343'),
(3,'Mobifone','98995699'),
(4,'Viettel','90989796'),
(4,'Mobifone','09871234'),
(5,'Viettel','123456789'),
(6,'Viettel','981234567'),
(6,'Mobifone','123467898'),
(7,'Vinaphone','123321123')
SELECT * FROM Phone

--4. Viết các câu lênh truy vấn để
--a) Liệt kê danh sách những người trong danh bạ
SELECT * FROM PhoneBook
--b) Liệt kê danh sách số điện thoại có trong danh bạ
SELECT * FROM Phone

--5. Viết các câu lệnh truy vấn để lấy
--a) Liệt kê danh sách người trong danh bạ theo thứ thự alphabet.
SELECT * FROM PhoneBook
ORDER BY PhoneBook.Name ASC
--b) Liệt kê các số điện thoại của người có thên là Nguyễn Văn An.
SELECT b.PhoneBookID,pb.Name,pb.[Address],b.Phone
FROM PhoneBook pb JOIN Phone AS b ON pb.PhoneBookID = b.PhoneBookID
WHERE pb.Name LIKE N'Nguyễn Văn An'
--c) Liệt kê những người có ngày sinh là 12/12/09

--6. Viết các câu lệnh truy vấn để
--a) Tìm số lượng số điện thoại của mỗi người trong danh bạ.
SELECT p.PhoneBookID, pb.Name, COUNT(p.Phone) AS 'So Luong So DT'
FROM Phone p JOIN PhoneBook AS pb ON p.PhoneBookID = pb.PhoneBookID
GROUP BY p.PhoneBookID, pb.Name
--b) Tìm tổng số người trong danh bạ sinh vào thang 12.
SELECT COUNT(PhoneBook.PhoneBookID) AS 'So nguoi sinh thang 12'
FROM PhoneBook
WHERE DATEPART(MONTH,PhoneBook.DateBirth) = 12
--c) Hiển thị toàn bộ thông tin về người, của từng số điện thoại.
SELECT p.PhoneID,p.Phone, pb.Name,pb.[Address],pb.DateBirth
FROM Phone p JOIN PhoneBook AS pb ON p.PhoneBookID = pb.PhoneBookID
--d) Hiển thị toàn bộ thông tin về người, của số điện thoại 123456789.
SELECT * 
FROM Phone p JOIN PhoneBook AS pb ON p.PhoneBookID = pb.PhoneBookID
WHERE p.Phone = '123456789'

--7. Thay đổi những thư sau từ cơ sở dữ liệu
--a) Viết câu lệnh để thay đổi trường ngày sinh là trước ngày hiện tại.
ALTER TABLE PhoneBook
ADD CONSTRAINT CHK_NgaySinh CHECK (DATEDIFF(year,PhoneBook.DateBirth,getdate())>0)
--b) Viết câu lệnh để xác định các trường khóa chính và khóa ngoại của các bảng.

--c) Viết câu lệnh để thêm trường ngày bắt đầu liên lạc.

--8. Thực hiện các yêu cầu sau
--a) Thực hiện các chỉ mục sau(Index)
--◦ IX_HoTen : đặt chỉ mục cho cột Họ và tên
CREATE NONCLUSTERED INDEX IX_HoTen
ON PhoneBook(Name)
--◦ IX_SoDienThoai: đặt chỉ mục cho cột Số điện thoại
CREATE NONCLUSTERED INDEX IX_SoDienThoai
ON Phone(Phone)
--b) Viết các View sau:
--◦ View_SoDienThoai: hiển thị các thông tin gồm Họ tên, Số điện thoại
CREATE VIEW View_SoDienThoai AS
SELECT pb.Name,p.Phone
FROM Phone p JOIN PhoneBook AS pb ON p.PhoneBookID = pb.PhoneBookID
SELECT * FROM View_SoDienThoai
--◦ View_SinhNhat: Hiển thị những người có sinh nhật trong tháng hiện tại (Họ tên, Ngày
--sinh, Số điện thoại)
CREATE VIEW View_SinhNhat AS
SELECT pb.Name, pb.DateBirth, p.Phone
FROM Phone p JOIN PhoneBook AS pb ON p.PhoneBookID = pb.PhoneBookID
WHERE DATEPART(MONTH,pb.DateBirth) = DATEPART(MONTH,GETDATE())

--c) Viết các Store Procedure sau:
--◦ SP_Them_DanhBa: Thêm một người mới vào danh bạ

--◦ SP_Tim_DanhBa: Tìm thông tin liên hệ của một người theo tên (gần đúng)
CREATE PROCEDURE SP_Tim_DanhBa
@Name NVARCHAR 
AS
SELECT b.PhoneBookID,pb.Name,pb.[Address],b.Phone
FROM PhoneBook pb JOIN Phone AS b ON pb.PhoneBookID = b.PhoneBookID
WHERE pb.Name LIKE @Name

CREATE PROCEDURE SP_Tim_DanhBa2
@Name NVARCHAR 
AS
SELECT b.PhoneBookID,pb.Name,pb.[Address],b.Phone
FROM PhoneBook pb JOIN Phone AS b ON pb.PhoneBookID = b.PhoneBookID
WHERE pb.Name LIKE '%'+@Name+'%'

EXECUTE SP_Tim_DanhBa2 N'Nguyễn'
EXEC sp_helptext'SP_Tim_DanhBa'
