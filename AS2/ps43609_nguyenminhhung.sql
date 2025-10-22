-- Xóa cơ sở dữ liệu nếu đã tồn tại
IF DB_ID('QLNHATRO') IS NOT NULL
BEGIN
    DROP DATABASE QLNHATRO
END
GO

-- Tạo cơ sở dữ liệu mới
CREATE DATABASE QLNHATRO
GO
USE QLNHATRO
GO

-- Tạo bảng
CREATE TABLE LOAINHA(
    MaLoaiNha smallint PRIMARY KEY NOT NULL,
    TenLoaiNha nvarchar(50) NOT NULL
)
GO

CREATE TABLE NGUOIDUNG(
    MaND smallint PRIMARY KEY NOT NULL,
    TenND nvarchar(50) NULL,
    GioiTinh nvarchar(3) NULL,
    DienThoai varchar(15) NULL,
    DiaChi nvarchar(50) NOT NULL,
    Quan nvarchar(50) NULL,
    Email nvarchar(50) NULL
)
GO

CREATE TABLE NHATRO(
    MaNT smallint PRIMARY KEY NOT NULL,
    MaLoaiNha smallint NOT NULL,
    MaND smallint NOT NULL,
    DienTich float CHECK(DienTich > 10) NOT NULL,
    GiaPhong int CHECK(GiaPhong > 0) NOT NULL,
    DiaChi nvarchar(50) NOT NULL,
    Quan nvarchar(50) NULL,
    MoTa nvarchar(100) NULL,
    NgayDang date NOT NULL,
    FOREIGN KEY(MaLoaiNha) REFERENCES LOAINHA(MaLoaiNha),
    FOREIGN KEY(MaND) REFERENCES NGUOIDUNG(MaND)
)
GO

CREATE TABLE DANHGIA(
    MaND smallint NOT NULL,
    MaNT smallint NOT NULL,
    Like_Dislike nvarchar(10) NULL,
    NoiDung nvarchar(100) NULL,
    PRIMARY KEY(MaND, MaNT),
    FOREIGN KEY(MaND) REFERENCES NGUOIDUNG(MaND),
    FOREIGN KEY(MaNT) REFERENCES NHATRO(MaNT)
)
GO

-- Chèn dữ liệu mẫu
INSERT INTO LOAINHA(MaLoaiNha, TenLoaiNha) VALUES
(1, N'Nhà trọ chung chủ'),
(2, N'Thuê nhà'),
(3, N'Chung cư'),
(4, N'Ký túc xá')
GO

INSERT INTO NGUOIDUNG(MaND, TenND, GioiTinh, DienThoai, DiaChi, Quan, Email) VALUES
(1, N'Phạm Văn Khánh', N'Nam', '0359690101', N'12 Nguyễn Văn Cừ, Phường 2', N'Quận 5', 'khanh@gmail.com'),
(2, N'Trần Thị Thủy', N'Nữ', '0359690102', N'45 Lê Hồng Phong, Phường 8', N'Quận 10', 'thuy@gmail.com'),
(3, N'Lê Anh Dũng', N'Nam', '0359690103', N'77 Điện Biên Phủ, Phường 15', N'Bình Thạnh', 'dung@gmail.com'),
(4, N'Ngô Thị Lan', N'Nữ', '0359690104', N'99 Nguyễn Trãi, Phường 3', N'Quận 5', 'lan@gmail.com'),
(5, N'Đặng Hải Long', N'Nam', '0359690105', N'35 Võ Văn Ngân, Phường Linh Chiểu', N'Thủ Đức', 'long@gmail.com'),
(6, N'Vũ Thị Hạnh', N'Nữ', '0359690106', N'21 Nguyễn Văn Linh, Phường Tân Phong', N'Quận 7', 'hanh@gmail.com'),
(7, N'Đỗ Minh Tuấn', N'Nam', '0359690107', N'200 Hoàng Văn Thụ, Phường 4', N'Tân Bình', 'tuan@gmail.com'),
(8, N'Lê Thị Hồng', N'Nữ', '0359690108', N'18 Cách Mạng Tháng 8, Phường 11', N'Quận 3', 'hong@gmail.com'),
(9, N'Phan Bá Lợi', N'Nam', '0359690109', N'66 Trần Não, Phường Bình An', N'Quận 2', 'loi@gmail.com'),
(10, N'Nguyễn Thị Kim', N'Nữ', '0359690110', N'50 Nguyễn Huệ, Phường Bến Nghé', N'Quận 1', 'kim@gmail.com')
GO

INSERT INTO NHATRO(MaNT, MaLoaiNha, MaND, DienTich, GiaPhong, DiaChi, Quan, MoTa, NgayDang) VALUES
(1, 1, 2, 28, 1500000, N'12 Nguyễn Kiệm, Phường 3', N'Gò Vấp', N'Phòng trọ thoáng mát', '2022-01-05'),
(2, 2, 5, 55, 2800000, N'45 Lý Thường Kiệt, Phường 7', N'Tân Bình', N'Có ban công', '2022-03-18'),
(3, 3, 8, 40, 3200000, N'99 Hoàng Sa, Phường Đa Kao', N'Quận 1', N'Gần trung tâm', '2022-06-12'),
(4, 4, 4, 75, 5000000, N'18 Nguyễn Hữu Cảnh, Phường 22', N'Bình Thạnh', N'Chung cư mini', '2022-07-22'),
(5, 1, 7, 35, 2000000, N'33 Nguyễn Văn Đậu, Phường 5', N'Phú Nhuận', N'Phòng mới xây', '2022-08-11'),
(6, 2, 10, 60, 4500000, N'120 Nguyễn Trãi, Phường 2', N'Quận 5', N'Full nội thất', '2022-09-27'),
(7, 3, 3, 90, 8000000, N'17 Lê Văn Lương, Phường Tân Hưng', N'Quận 7', N'Mặt bằng kinh doanh', '2022-10-09'),
(8, 4, 6, 25, 1300000, N'9 Cách Mạng Tháng 8, Phường 11', N'Quận 3', N'Phòng giá rẻ', '2022-11-30'),
(9, 1, 9, 45, 3500000, N'72 Phan Xích Long, Phường 2', N'Phú Nhuận', N'Có chỗ để xe', '2022-12-15'),
(10, 2, 1, 65, 5200000, N'200 Trần Não, Phường Bình An', N'Thủ Đức', N'Nhà nguyên căn', '2022-12-28')
GO

INSERT INTO DANHGIA(MaND, MaNT, Like_Dislike, NoiDung) VALUES
(1, 2, 'like', N'Phòng sạch sẽ'),
(2, 5, 'dislike', N'Thường xuyên ồn ào'),
(3, 7, 'like', N'Chủ nhà thân thiện'),
(4, 1, 'dislike', N'Nước yếu'),
(5, 9, 'like', N'Gần chợ'),
(6, 6, 'dislike', N'Điện đắt'),
(7, 8, 'like', N'Không gian thoáng'),
(8, 10, 'dislike', N'Không có chỗ gửi xe'),
(9, 4, 'like', N'Khu vực an ninh'),
(10, 3, 'dislike', N'Tường mốc')

-- Kiểm tra dữ liệu
SELECT * FROM LOAINHA
SELECT * FROM NGUOIDUNG
SELECT * FROM NHATRO
SELECT * FROM DANHGIA