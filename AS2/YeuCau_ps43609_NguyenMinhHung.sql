USE QLNHATRO
GO

-- Xóa Stored Procedure nếu đã tồn tại
IF OBJECT_ID('YC_1a') IS NOT NULL DROP PROCEDURE YC_1a
GO

-- Tạo Stored Procedure để chèn dữ liệu vào bảng NGUOIDUNG
CREATE PROCEDURE YC_1a
    @mand smallint,              
    @tennd nvarchar(50),        
    @gioitinh nvarchar(3),      
    @dienthoai varchar(15),      
    @diachi nvarchar(50),        
    @quan nvarchar(50),          
    @email nvarchar(50)          
AS
BEGIN
    -- Kiểm tra các cột không chấp nhận NULL
    IF @mand IS NULL OR @diachi IS NULL
    BEGIN
        PRINT N'Lỗi: MaND và DiaChi là bắt buộc!'
        RETURN
    END

    -- Kiểm tra trùng lặp khóa chính MaND
    IF EXISTS (SELECT 1 FROM NGUOIDUNG WHERE MaND = @mand)
    BEGIN
        PRINT N'Lỗi: MaND đã tồn tại!'
        RETURN
    END

    -- Kiểm tra định dạng giới tính chỉ chấp nhận Nam hoặc Nữ
    IF @gioitinh IS NOT NULL AND @gioitinh NOT IN (N'Nam', N'Nữ')
    BEGIN
        PRINT N'Lỗi: GioiTinh chỉ được là "Nam" hoặc "Nữ"!'
        RETURN
    END

    -- Kiểm tra định dạng số điện thoại (phải là 10 chữ số)
    IF @dienthoai IS NOT NULL AND @dienthoai NOT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
    BEGIN
        PRINT N'Lỗi: DienThoai phải là chuỗi 10 chữ số!'
        RETURN
    END

    -- Kiểm tra định dạng email (phải chứa @ và .)
    IF @email IS NOT NULL AND @email NOT LIKE '%_@_%._%'
    BEGIN
        PRINT N'Lỗi: Email không đúng định dạng!'
        RETURN
    END

    -- Thực hiện chèn dữ liệu vào bảng NGUOIDUNG
    INSERT INTO NGUOIDUNG (MaND, TenND, GioiTinh, DienThoai, DiaChi, Quan, Email)
    VALUES (@mand, @tennd, @gioitinh, @dienthoai, @diachi, @quan, @email)
    PRINT N'Chèn dữ liệu vào NGUOIDUNG thành công!'
END
GO

-- Lời gọi thực hiện chèn thành công
EXEC YC_1a 11, N'Vũ Quang Dũng', N'Nam', '0362252351', N'123 Nguyễn Thị Thập', N'Quận 7', 'dung@fpt.edu.vn'
-- Lời gọi trả về thông báo lỗi (thiếu MaND)
EXEC YC_1a NULL, N'Vũ Quang Dũng', N'Nam', '0362252351', N'123 Nguyễn Thị Thập', N'Quận 7', 'dung@fpt.edu.vn'
GO

-- Xóa Stored Procedure nếu đã tồn tại
IF OBJECT_ID('YC_1b') IS NOT NULL DROP PROCEDURE YC_1b
GO

-- Tạo Stored Procedure để chèn dữ liệu vào bảng NHATRO
CREATE PROCEDURE YC_1b
    @mant smallint,              
    @maln smallint,             
    @mand smallint,             
    @dientich float,             
    @giaphong int,               
    @diachi nvarchar(50),       
    @quan nvarchar(50),         
    @mota nvarchar(100),      
    @ngaydang date              
AS
BEGIN
    -- Kiểm tra các cột không chấp nhận NULL
    IF @mant IS NULL OR @maln IS NULL OR @mand IS NULL OR @dientich IS NULL OR @giaphong IS NULL OR @diachi IS NULL OR @ngaydang IS NULL
    BEGIN
        PRINT N'Lỗi: MaNT, MaLoaiNha, MaND, DienTich, GiaPhong, DiaChi, NgayDang là bắt buộc!'
        RETURN
    END

    -- Kiểm tra trùng lặp khóa chính MaNT
    IF EXISTS (SELECT 1 FROM NHATRO WHERE MaNT = @mant)
    BEGIN
        PRINT N'Lỗi: MaNT đã tồn tại!'
        RETURN
    END

    -- Kiểm tra diện tích phải lớn hơn 10
    IF @dientich <= 10
    BEGIN
        PRINT N'Lỗi: Diện tích phải lớn hơn 10!'
        RETURN
    END

    -- Kiểm tra giá phòng phải lớn hơn 0
    IF @giaphong <= 0
    BEGIN
        PRINT N'Lỗi: Giá phòng phải lớn hơn 0!'
        RETURN
    END

    -- Kiểm tra khóa ngoại MaLoaiNha
    IF NOT EXISTS (SELECT 1 FROM LOAINHA WHERE MaLoaiNha = @maln)
    BEGIN
        PRINT N'Lỗi: MaLoaiNha không tồn tại trong bảng LOAINHA!'
        RETURN
    END

    -- Kiểm tra khóa ngoại MaND
    IF NOT EXISTS (SELECT 1 FROM NGUOIDUNG WHERE MaND = @mand)
    BEGIN
        PRINT N'Lỗi: MaND không tồn tại trong bảng NGUOIDUNG!'
        RETURN
    END

    -- Thực hiện chèn dữ liệu vào bảng NHATRO
    INSERT INTO NHATRO (MaNT, MaLoaiNha, MaND, DienTich, GiaPhong, DiaChi, Quan, MoTa, NgayDang)
    VALUES (@mant, @maln, @mand, @dientich, @giaphong, @diachi, @quan, @mota, @ngaydang)
    PRINT N'Chèn dữ liệu vào NHATRO thành công!'
END
GO

-- Lời gọi thực hiện chèn thành công
EXEC YC_1b 11, 1, 4, 50.6, 5000000, N'123 Nguyễn Thị Thập', N'Quận 7', N'Cho Thuê', '2020-11-22'
-- Lời gọi trả về thông báo lỗi (thiếu MaNT)
EXEC YC_1b NULL, 1, 4, 50.6, 5000000, N'123 Nguyễn Thị Thập', N'Quận 7', N'Cho Thuê', '2020-11-22'
GO

-- Xóa Stored Procedure nếu đã tồn tại
IF OBJECT_ID('YC_1c') IS NOT NULL DROP PROCEDURE YC_1c
GO

-- Tạo Stored Procedure để chèn dữ liệu vào bảng DANHGIA
CREATE PROCEDURE YC_1c
    @mand smallint,              -- Mã người dùng (khóa ngoại)
    @mant smallint,              -- Mã nhà trọ (khóa ngoại)
    @like_dislike nvarchar(10),  -- (like hoặc dislike)
    @noidung nvarchar(100)       
AS
BEGIN
    -- Kiểm tra các cột không chấp nhận NULL
    IF @mand IS NULL OR @mant IS NULL
    BEGIN
        PRINT N'Lỗi: MaND và MaNT là bắt buộc!'
        RETURN
    END

    -- Kiểm tra trùng lặp khóa chính (cặp MaND và MaNT)
    IF EXISTS (SELECT 1 FROM DANHGIA WHERE MaND = @mand AND MaNT = @mant)
    BEGIN
        PRINT N'Lỗi: Đánh giá với MaND và MaNT này đã tồn tại!'
        RETURN
    END

    -- Kiểm tra khóa ngoại MaND
    IF NOT EXISTS (SELECT 1 FROM NGUOIDUNG WHERE MaND = @mand)
    BEGIN
        PRINT N'Lỗi: MaND không tồn tại trong bảng NGUOIDUNG!'
        RETURN
    END

    -- Kiểm tra khóa ngoại MaNT
    IF NOT EXISTS (SELECT 1 FROM NHATRO WHERE MaNT = @mant)
    BEGIN
        PRINT N'Lỗi: MaNT không tồn tại trong bảng NHATRO!'
        RETURN
    END

    -- Kiểm tra trạng thái Like_Dislike (chỉ chấp nhận like hoặc dislike)
    IF @like_dislike IS NOT NULL AND @like_dislike NOT IN ('like', 'dislike')
    BEGIN
        PRINT N'Lỗi: Like_Dislike chỉ được là "like" hoặc "dislike"!'
        RETURN
    END

    -- Thực hiện chèn dữ liệu vào bảng DANHGIA
    INSERT INTO DANHGIA (MaND, MaNT, Like_Dislike, NoiDung)
    VALUES (@mand, @mant, @like_dislike, @noidung)
    PRINT N'Chèn dữ liệu vào DANHGIA thành công!'
END
GO

-- Lời gọi thực hiện chèn thành công
EXEC YC_1c 1, 7, 'like', N'Tốt'
-- Lời gọi trả về thông báo lỗi (thiếu MaND)
EXEC YC_1c NULL, 7, 'like', N'Tốt'
GO

-- Xóa Stored Procedure nếu đã tồn tại
IF OBJECT_ID('SP_TimKiemPhongTro') IS NOT NULL DROP PROCEDURE SP_TimKiemPhongTro
GO

-- Tạo Stored Procedure để tìm kiếm thông tin phòng trọ theo điều kiện
CREATE PROCEDURE SP_TimKiemPhongTro
    @quan nvarchar(50) = NULL,          
    @dientich_min float = 0,            -- Diện tích (mặc định 0)
    @dientich_max float = NULL,         -- Diện tích tối đa (tùy chọn)
    @ngaydang_min date = NULL,          -- Ngày đăng tối thiểu 
    @ngaydang_max date = NULL,          -- Ngày đăng
    @giaphong_min int = 0,              
    @giaphong_max int = NULL            
AS
BEGIN
    -- Truy vấn thông tin phòng trọ thỏa mãn điều kiện
    SELECT 
        'Cho thuê phòng trọ tại ' + N.DiaChi + N' ' + N.Quan AS ThongTinDiaChi, 
        CAST(DienTich AS nvarchar(10)) + N' m2' AS DienTich,                    
        FORMAT(GiaPhong, 'N0') AS GiaPhong,                                     
        MoTa AS MoTaPhong,                                                      
        FORMAT(NgayDang, 'dd-MM-yyyy') AS NgayDang,                             
        CASE 
            WHEN ND.GioiTinh = N'Nam' THEN N'A. ' + ND.TenND                   
            WHEN ND.GioiTinh = N'Nữ' THEN N'C. ' + ND.TenND 
            ELSE ND.TenND 
        END AS TenLienHe,
        ND.DienThoai AS SoDienThoai,                                            
        ND.DiaChi AS DiaChiLienHe                                               
    FROM NHATRO N
    JOIN NGUOIDUNG ND ON N.MaND = ND.MaND
    WHERE (@quan IS NULL OR N.Quan = @quan)                                    
    AND DienTich BETWEEN @dientich_min AND ISNULL(@dientich_max, DienTich)     
    AND GiaPhong BETWEEN @giaphong_min AND ISNULL(@giaphong_max, GiaPhong)     
    AND (@ngaydang_min IS NULL OR NgayDang >= @ngaydang_min)                    
    AND (@ngaydang_max IS NULL OR NgayDang <= @ngaydang_max)                    
END
GO

-- Lời gọi thực hiện tìm kiếm thành công
EXEC SP_TimKiemPhongTro @quan = N'Quận 7', @dientich_min = 40, @giaphong_max = 6000000
-- Lời gọi trả về kết quả rỗng (ngày không hợp lệ)
EXEC SP_TimKiemPhongTro @ngaydang_min = '2025-10-03', @ngaydang_max = '2025-10-01'
GO

-- Xóa hàm nếu đã tồn tại
IF OBJECT_ID('fn_GetMaND') IS NOT NULL DROP FUNCTION fn_GetMaND
GO

-- Tạo hàm để lấy mã người dùng dựa trên thông tin
CREATE FUNCTION fn_GetMaND
    (@tennd nvarchar(50),         
     @gioitinh nvarchar(3),       
     @dienthoai varchar(15),      
     @diachi nvarchar(50),        
     @quan nvarchar(50),          
     @email nvarchar(50))       
RETURNS smallint
AS
BEGIN
    DECLARE @mand smallint                           
    SELECT @mand = MaND
    FROM NGUOIDUNG
    WHERE TenND = @tennd                                   -- Kiểm tra tên
    AND (GioiTinh = @gioitinh OR @gioitinh IS NULL)        -- Kiểm tra giới tính
    AND (DienThoai = @dienthoai OR @dienthoai IS NULL)     -- Kiểm tra số điện thoại 
    AND DiaChi = @diachi                                   -- Kiểm tra địa chỉ
    AND (Quan = @quan OR @quan IS NULL)                    -- Kiểm tra quận 
    AND (Email = @email OR @email IS NULL)                 -- Kiểm tra email 
    RETURN @mand                                           -- Trả về mã người dùng hoặc NULL nếu không tìm thấy
END
GO

-- Gọi hàm với dữ liệu hợp lệ
SELECT dbo.fn_GetMaND(N'Phạm Văn Khánh', N'Nam', '0359690101', N'12 Nguyễn Văn Cừ, Phường 2', N'Quận 5', 'khanh@gmail.com') AS MaND
-- Gọi hàm với dữ liệu không tồn tại
SELECT dbo.fn_GetMaND(N'Không Tồn Tại', N'Nam', NULL, N'Không Tồn Tại', NULL, NULL) AS MaND
GO

-- Xóa hàm nếu đã tồn tại
IF OBJECT_ID('fn_GetTongLikeDislike') IS NOT NULL DROP FUNCTION fn_GetTongLikeDislike
GO

-- Tạo hàm để tính tổng số LIKE và DISLIKE của một nhà trọ
CREATE FUNCTION fn_GetTongLikeDislike (@mant smallint)  -- Mã nhà trọ (khóa chính)
RETURNS int
AS
BEGIN
    DECLARE @tong int                                  -- Biến lưu tổng số lượng
    SELECT @tong = COUNT(*)                            -- Đếm số bản ghi đánh giá
    FROM DANHGIA
    WHERE MaNT = @mant                                 -- Lọc theo mã nhà trọ
    RETURN ISNULL(@tong, 0)                            -- Trả về tổng hoặc 0 nếu không có
END
GO

-- Gọi hàm với mã nhà trọ hợp lệ
SELECT dbo.fn_GetTongLikeDislike(7) AS TongLikeDislike
-- Gọi hàm với mã nhà trọ không tồn tại
SELECT dbo.fn_GetTongLikeDislike(999) AS TongLikeDislike
GO

-- Xóa View nếu đã tồn tại
IF OBJECT_ID('vw_Top10NhaTroLike') IS NOT NULL DROP VIEW vw_Top10NhaTroLike
GO

-- Tạo View để lưu thông tin TOP 10 nhà trọ có LIKE nhiều nhất
CREATE VIEW vw_Top10NhaTroLike
AS
SELECT TOP 10 
    N.DienTich,                                      
    N.GiaPhong,                                    
    N.MoTa,                                
    N.NgayDang,                                  
    ND.TenND AS TenLienHe,                         
    ND.DiaChi,                               
    ND.DienThoai,                             
    ND.Email                                    
FROM NHATRO N
JOIN NGUOIDUNG ND ON N.MaND = ND.MaND
JOIN DANHGIA DG ON N.MaNT = DG.MaNT
WHERE DG.Like_Dislike = 'like'                       -- Chỉ lấy các đánh giá LIKE
GROUP BY N.DienTich, N.GiaPhong, N.MoTa, N.NgayDang, ND.TenND, ND.DiaChi, ND.DienThoai, ND.Email
ORDER BY COUNT(DG.MaNT) DESC                         -- Sắp xếp theo số LIKE giảm dần
GO

-- Truy vấn View
SELECT * FROM vw_Top10NhaTroLike
GO

-- Xóa Stored Procedure nếu đã tồn tại
IF OBJECT_ID('SP_ThongTinDanhGia') IS NOT NULL DROP PROCEDURE SP_ThongTinDanhGia
GO

-- Tạo Stored Procedure để lấy thông tin đánh giá theo mã nhà trọ
CREATE PROCEDURE SP_ThongTinDanhGia
    @mant smallint                   
AS
BEGIN
    -- Truy vấn thông tin đánh giá
    SELECT 
        N.MaNT,                   
        ND.TenND AS TenNguoiDanhGia, 
        DG.Like_Dislike AS TrangThai,
        DG.NoiDung AS NoiDungDanhGia 
    FROM NHATRO N
    JOIN DANHGIA DG ON N.MaNT = DG.MaNT
    JOIN NGUOIDUNG ND ON DG.MaND = ND.MaND
    WHERE N.MaNT = @mant          
END
GO

-- Lời gọi với mã nhà trọ hợp lệ
EXEC SP_ThongTinDanhGia @mant = 7
-- Lời gọi với mã nhà trọ không tồn tại
EXEC SP_ThongTinDanhGia @mant = 999
GO

-- Xóa Stored Procedure nếu đã tồn tại
IF OBJECT_ID('SP_XoaNhaTroTheoDislike') IS NOT NULL DROP PROCEDURE SP_XoaNhaTroTheoDislike
GO

-- Tạo Stored Procedure để xóa nhà trọ dựa trên số DISLIKE
CREATE PROCEDURE SP_XoaNhaTroTheoDislike
    @soDislike int                -- Số lượng DISLIKE tối đa
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION        
            -- Xóa thông tin đánh giá của các nhà trọ có số DISLIKE vượt quá
            DELETE DG
            FROM DANHGIA DG
            JOIN (SELECT MaNT FROM DANHGIA WHERE Like_Dislike = 'dislike' 
                  GROUP BY MaNT HAVING COUNT(*) > @soDislike) T ON DG.MaNT = T.MaNT

            -- Xóa thông tin nhà trọ tương ứng
            DELETE N
            FROM NHATRO N
            JOIN (SELECT MaNT FROM DANHGIA WHERE Like_Dislike = 'dislike' 
                  GROUP BY MaNT HAVING COUNT(*) > @soDislike) T ON N.MaNT = T.MaNT
        COMMIT TRANSACTION       -- Cam kết giao dịch nếu thành công
        PRINT N'Xóa dữ liệu thành công!'
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION    -- Hoàn tác nếu có lỗi
        PRINT N'Lỗi: ' + ERROR_MESSAGE()
    END CATCH
END
GO

-- Lời gọi thực hiện xóa
EXEC SP_XoaNhaTroTheoDislike @soDislike = 1
GO

-- Xóa Stored Procedure nếu đã tồn tại
IF OBJECT_ID('SP_XoaNhaTroTheoThoiGian') IS NOT NULL DROP PROCEDURE SP_XoaNhaTroTheoThoiGian
GO

-- Tạo Stored Procedure để xóa nhà trọ theo khoảng thời gian
CREATE PROCEDURE SP_XoaNhaTroTheoThoiGian
    @ngaydang_min date,        
    @ngaydang_max date        
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION        -- Bắt đầu giao dịc
            -- Tạo bảng tạm để lưu danh sách mã nhà trọ cần xóa
            DECLARE @maNTList TABLE (MaNT smallint)
            INSERT INTO @maNTList
            SELECT MaNT FROM NHATRO WHERE NgayDang BETWEEN @ngaydang_min AND @ngaydang_max

            -- Xóa thông tin đánh giá
            DELETE DG FROM DANHGIA DG JOIN @maNTList T ON DG.MaNT = T.MaNT

            -- Xóa thông tin nhà trọ
            DELETE N FROM NHATRO N JOIN @maNTList T ON N.MaNT = T.MaNT
        COMMIT TRANSACTION       -- Cam kết giao dịch nếu thành công
        PRINT N'Xóa dữ liệu thành công!'
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION    -- Hoàn tác nếu có lỗi
        PRINT N'Lỗi: ' + ERROR_MESSAGE()
    END CATCH
END
GO

-- Lời gọi thực hiện xóa
EXEC SP_XoaNhaTroTheoThoiGian @ngaydang_min = '2022-01-01', @ngaydang_max = '2022-12-31'
GO

-- Y4.Yêu cầu quản trị CSDL 
USE master
GO

-- Tạo login cho người dùng quản trị (Admin)
CREATE LOGIN AdminQLNhaTro WITH PASSWORD = 'Admin@2025', DEFAULT_DATABASE = QLNHATRO, CHECK_EXPIRATION = OFF, CHECK_POLICY = OFF
GO

-- Tạo login cho người dùng thông thường (User)
CREATE LOGIN UserQLNhaTro WITH PASSWORD = 'User@2025', DEFAULT_DATABASE = QLNHATRO, CHECK_EXPIRATION = OFF, CHECK_POLICY = OFF
GO

-- Tạo user trong cơ sở dữ liệu QLNHATRO cho Admin
USE QLNHATRO
GO
CREATE USER AdminQLNhaTro FOR LOGIN AdminQLNhaTro
GO

-- Phân quyền cho Admin (toàn quyền trên CSDL QLNHATRO)
ALTER ROLE db_owner ADD MEMBER AdminQLNhaTro
GO

-- Tạo user trong cơ sở dữ liệu QLNHATRO cho User
CREATE USER UserQLNhaTro FOR LOGIN UserQLNhaTro
GO

-- Phân quyền cho User (toàn quyền trên các bảng và quyền thực thi SP/hàm)
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO UserQLNhaTro
GRANT EXECUTE ON SCHEMA::dbo TO UserQLNhaTro
GO

-- Kết nối bằng tài khoản AdminQLNhaTro và tạo bản sao CSDL
-- SSMS bằng tài khoản AdminQLNhaTro với mật khẩu 'Admin@2025')
USE master
GO
-- Tạo bản sao CSDL với tên QLNHATRO_Backup
CREATE DATABASE QLNHATRO_Backup
AS COPY OF QLNHATRO
GO
