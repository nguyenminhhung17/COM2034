
-- HÌNH CHỮ NHẬT (chu vi, diện tích)

-- Cách 1: Biến vô hướng
declare @a int, @b int, @p int, @s int;
set @a = 10;
set @b = 15;
set @s = @a * @b;
set @p = 2 * (@a + @b);
select @a as chieu_dai, @b as chieu_rong, 
       @p as chu_vi, @s as dien_tich;

-- Cách 2: Biến bảng
declare @BangHCN table (ChieuDai int, ChieuRong int, ChuVi int, DienTich int);
insert into @BangHCN
select 10, 15, 2*(10+15), 10*15;
select * from @BangHCN;

-- BÀI 1: NHÂN VIÊN CÓ LƯƠNG CAO NHẤT
-- Cách 1: Biến vô hướng
declare @MaxLuong int;
set @MaxLuong = (select max(LUONG) from NHANVIEN);
select @MaxLuong as LuongCaoNhat, * 
from NHANVIEN 
where LUONG = @MaxLuong;

-- Cách 2: Biến bảng
declare @BangMaxLuong table (MaNV int, HoTen nvarchar(100), Luong int);
insert into @BangMaxLuong
select MANV, HONV + ' ' + TENLOT + ' ' + TENNV, LUONG
from NHANVIEN
where LUONG = (select max(LUONG) from NHANVIEN);
select * from @BangMaxLuong;


-- BÀI 2: NHÂN VIÊN LƯƠNG > TRUNG BÌNH PHÒNG "NGHIÊN CỨU"

-- Cách 1: Biến vô hướngs
declare @TBLuong float;
set @TBLuong = (
    select avg(LUONG) 
    from NHANVIEN N 
    join PHONGBAN P on N.PHG = P.MAPHG
    where TENPHG = N'Nghiên Cứu'
);
select HONV + ' ' + TENLOT + ' ' + TENNV as HoTen, LUONG, TENPHG
from NHANVIEN N
join PHONGBAN P on N.PHG = P.MAPHG
where LUONG > @TBLuong and TENPHG = N'Nghiên Cứu';

-- Cách 2: Biến bảng
declare @BangLuongTB table (HoTen nvarchar(100), Luong int, TenPhong nvarchar(50));
insert into @BangLuongTB
select HONV + ' ' + TENLOT + ' ' + TENNV, LUONG, TENPHG
from NHANVIEN N
join PHONGBAN P on N.PHG = P.MAPHG
where LUONG > (
    select avg(LUONG) 
    from NHANVIEN N2 
    join PHONGBAN P2 on N2.PHG = P2.MAPHG
    where TENPHG = N'Nghiên Cứu'
)
and TENPHG = N'Nghiên Cứu';
select * from @BangLuongTB;

-- BÀI 3: PHÒNG BAN CÓ LƯƠNG TRUNG BÌNH > 30,000
-- Cách 1: Biến vô hướng
declare @LuongTB float;
set @LuongTB = (select avg(LUONG) from NHANVIEN);
select TENPHG, count(MANV) as SoLuong
from NHANVIEN N
join PHONGBAN P on N.PHG = P.MAPHG
group by TENPHG
having avg(LUONG) > 30000;

-- Cách 2: Biến bảng
declare @TablePhong table (MaPB int, TenPB nvarchar(50), LuongTB float, SoLuong int);
insert into @TablePhong
select MAPHG, TENPHG, avg(LUONG), count(MANV)
from NHANVIEN
join PHONGBAN on NHANVIEN.PHG = PHONGBAN.MAPHG
group by MAPHG, TENPHG
having avg(LUONG) > 30000;
select * from @TablePhong;
-- BÀI 4: SỐ LƯỢNG ĐỀ ÁN MỖI PHÒNG BAN
-- Cách 1: Biến vô hướng
declare @MaPhong int, @SoDA int;
set @MaPhong = 1;
set @SoDA = (select count(MaDA) from DEAN where PHONG = @MaPhong);
select @MaPhong as MaPhong, @SoDA as SoLuongDeAn;

-- Cách 2: Biến bảng
declare @TableDeAn table (TenPHG nvarchar(50), SoLuongDeAn int);
insert into @TableDeAn
select TENPHG, count(MaDA)
from DEAN
join PHONGBAN on PHONGBAN.MAPHG = DEAN.PHONG
group by TENPHG;
select * from @TableDeAn;