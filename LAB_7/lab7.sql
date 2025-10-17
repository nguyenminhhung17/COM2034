-- ========================================
-- BÀI 1: VIẾT HÀM
-- ========================================

-- 1a. Nhập vào MaNV, cho biết tuổi của nhân viên này
GO
CREATE OR ALTER FUNCTION lab7bai1a (@manv NVARCHAR(9)) 
RETURNS INT
AS
BEGIN
    DECLARE @tuoi INT
    SELECT @tuoi = YEAR(GETDATE()) - YEAR(NGSINH)
    FROM NHANVIEN
    WHERE MANV = @manv
    RETURN @tuoi
END
GO
PRINT N'Tuổi nhân viên 001: ' + CAST(dbo.lab7bai1a('001') AS NVARCHAR(10))
GO


-- 1b. Nhập vào MaNV, cho biết số lượng đề án nhân viên này đã tham gia
GO
CREATE OR ALTER FUNCTION lab7bai1b (@manv NVARCHAR(9)) 
RETURNS INT
AS
BEGIN
    DECLARE @soLuong INT
    SELECT @soLuong = COUNT(*) 
    FROM PHANCONG
    WHERE MA_NVIEN = @manv
    RETURN ISNULL(@soLuong, 0)
END
GO
PRINT N'Số đề án nhân viên 001 tham gia: ' + CAST(dbo.lab7bai1b('001') AS NVARCHAR(10))
GO


-- 1c. Truyền tham số vào là phái ('Nam' hoặc 'Nữ'), xuất số lượng nhân viên theo phái
GO
CREATE OR ALTER FUNCTION lab7bai1c (@gt NVARCHAR(3)) 
RETURNS INT
AS
BEGIN
    DECLARE @count INT
    SELECT @count = COUNT(*) FROM NHANVIEN WHERE PHAI = @gt
    RETURN ISNULL(@count, 0)
END
GO
PRINT N'Nam: ' + CAST(dbo.lab7bai1c(N'Nam') AS NVARCHAR(10))
PRINT N'Nữ: ' + CAST(dbo.lab7bai1c(N'Nữ') AS NVARCHAR(10))
GO


-- 1d. Truyền vào mã phòng, cho biết họ tên NV có lương > lương TB của phòng đó
GO
CREATE OR ALTER FUNCTION lab7bai1d (@maPhg INT) 
RETURNS TABLE
AS
RETURN (
    SELECT HONV, TENLOT, TENNV, LUONG
    FROM NHANVIEN
    WHERE PHG = @maPhg
      AND LUONG > (SELECT AVG(LUONG) FROM NHANVIEN WHERE PHG = @maPhg)
)
GO
SELECT * FROM lab7bai1d(1)
GO


-- 1e. Truyền vào mã phòng, cho biết tên phòng, họ tên trưởng phòng và số lượng đề án phòng đó chủ trì
GO
CREATE OR ALTER FUNCTION lab7bai1e (@maPhg INT)
RETURNS @tbLab7 TABLE(
    tenphg NVARCHAR(15),
    honv NVARCHAR(15),
    tennv NVARCHAR(15),
    soLuong INT
)
AS
BEGIN
    INSERT INTO @tbLab7
    SELECT 
        TENPHG,
        HONV,
        TENNV,
        COUNT(DEAN.MADA) AS soLuong
    FROM PHONGBAN
        INNER JOIN NHANVIEN ON NHANVIEN.MANV = PHONGBAN.TRPHG
        LEFT JOIN DEAN ON DEAN.PHONG = PHONGBAN.MAPHG
    WHERE PHONGBAN.MAPHG = @maPhg
    GROUP BY TENPHG, HONV, TENNV
    RETURN
END
GO
SELECT * FROM lab7bai1e(1)
GO


-- ========================================
-- BÀI 2: TẠO VIEW
-- ========================================

-- 2a. Hiển thị HoNV, TenNV, TenPHG, DiaDiemPhg
GO
CREATE OR ALTER VIEW lab7bai2a
AS
SELECT 
    HONV,
    TENNV,
    TENPHG,
    DIADIEM_PHG.DIADIEM
FROM NHANVIEN
    INNER JOIN PHONGBAN ON PHONGBAN.MAPHG = NHANVIEN.PHG
    INNER JOIN DIADIEM_PHG ON DIADIEM_PHG.MAPHG = PHONGBAN.MAPHG
GO
SELECT * FROM lab7bai2a
GO


-- 2b. Hiển thị TenNV, Lương, Tuổi
GO
CREATE OR ALTER VIEW lab7bai2b
AS
SELECT 
    TENNV,
    LUONG,
    YEAR(GETDATE()) - YEAR(NGSINH) AS TUOI
FROM NHANVIEN
GO
SELECT * FROM lab7bai2b
GO


-- 2c. Hiển thị tên phòng ban và họ tên trưởng phòng của phòng ban có đông nhân viên nhất
GO
CREATE OR ALTER VIEW lab7bai2c
AS
SELECT 
    TENPHG,
    HONV,
    TENNV
FROM PHONGBAN
    INNER JOIN NHANVIEN ON PHONGBAN.TRPHG = NHANVIEN.MANV
WHERE MAPHG IN (
    SELECT TOP 1 PHG
    FROM NHANVIEN
    GROUP BY PHG
    ORDER BY COUNT(*) DESC
)
GO
SELECT * FROM lab7bai2c
GO
