-- simulasi

-- simulasi no 1: membaca data pada tabel
SELECT*FROM Karyawan

-- simulasi no 2: menginput data pada tabel 
INSERT INTO Karyawan (
    no_karyawan, no_project, no_jabatan, no_departemen, tanggal_lahir,
    nama_awal, nama_akhir, jenis_kelamin, alamat, tanggal_diterima,
    email, nomor_handphone
) VALUES (
    201, 'EBW17', 'XET426', 'EEG60644', '11/9/1996',
    'John', 'Doe', 'M', '123 Example St', '15/1/2023',
    'john.doe@example.com', '85711451983'
),(
    202, 'FZT16', 'XET426', 'EEG60644', '15/5/1990',
    'Jane', 'Smith', 'F', '456 Another St', '16/1/2023',
    'jane.smith@example.com', '8765432102'
);

SELECT*FROM Karyawan WHERE no_karyawan = 201 OR  no_karyawan = 202

-- simulasi no 3: mengupdate data yang salah input
UPDATE "Karyawan"
SET "email" = 'JonathanLiandi@example.net'
WHERE "no_karyawan" = 25;

SELECT*FROM Karyawan WHERE no_karyawan = 25

-- simulasi no 4: mengupdate data yang salah lokasi
SELECT no_karyawan
FROM Karyawan
WHERE nama_awal = 'Michael' and nama_akhir = 'Weiss';

UPDATE Karyawan
SET no_project = 'ARJ11'
WHERE no_karyawan = (
	SELECT no_karyawan
	FROM Karyawan
	WHERE  nama_awal = 'Michael' AND nama_akhir = 'Weiss'
	) AND no_project = 'ABK15';

SELECT*FROM Karyawan WHERE nama_awal = 'Michael' AND nama_akhir = 'Weiss'

-- simulasi no 5: menghapus data karyawan yang mengundurkan diri
SELECT no_karyawan
FROM Karyawan
WHERE nama_awal = 'Christopherr' AND nama_akhir = 'Vega'

-- Langkah 1: Hapus data gaji terkait dengan karyawan 122 dari tabel "Gaji"
DELETE FROM "Gaji"
WHERE "no_karyawan" = 122;

-- Langkah 2: Hapus data karyawan 122 dari tabel "Karyawan"
DELETE FROM "Karyawan"
WHERE "no_karyawan" = 122;

SELECT*FROM Karyawan

-- simulasi no 6: menggabungkan tabel departemen dan tabel projek
SELECT Departemen.nama_departemen, Projek.nama_project FROM Departemen JOIN Projek ON Departemen.no_departemen = Projek.no_departemen

-- simulaso no 7: menggabungkan tabel karyawan dan tabel gaji
SELECT 
    Karyawan.nama_awal, 
    Karyawan.nama_akhir, 
    Gaji.no_rekening, 
    Gaji.gaji, 
    Jabatan.nama_jabatan
FROM 
    Karyawan
JOIN 
    Gaji ON Karyawan.no_karyawan = Gaji.no_karyawan
JOIN 
    Jabatan ON Karyawan.no_jabatan = Jabatan.no_jabatan

-- simulaso no 8: menggabungkan tabel karyawan dan tabel projek
SELECT Karyawan.nama_awal, Karyawan.nama_akhir, Karyawan.email, Karyawan.nomor_handphone, Projek.nama_project 
FROM Karyawan JOIN Projek ON Karyawan.no_project = Projek.no_project WHERE Karyawan.no_project= 'JNI74'

-- simulaso no 9: melihat total karyawan yang ada pada perusahaan
SELECT COUNT(*) AS jumlah_record
FROM Karyawan;

-- simulaso no 10: menghitung rata-rata penghasilan yang didapat tiap departemen
SELECT Departemen.nama_departemen,
ROUND(AVG("gaji"), 2) as "rata-rata gaji"

FROM Departemen
JOIN Karyawan ON Departemen.no_departemen = Karyawan.no_departemen
JOIN Gaji ON Karyawan.no_karyawan = Gaji.no_karyawan

GROUP BY Departemen.nama_departemen
