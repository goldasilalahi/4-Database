CREATE TABLE "Departemen" (
 "no_departemen" VARCHAR(8) NOT NULL,
 "nama_departemen" VARCHAR(18) NOT NULL,
 PRIMARY KEY("no_departemen")
);

CREATE TABLE "Gaji" (
 "no_karyawan" INTEGER,
 "no_jabatan" INTEGER,
 "no_rekening" INTEGER NOT NULL,
 "gaji" INTEGER NOT NULL,
 "tanggal_kirim" DATE NOT NULL,
 FOREIGN KEY("no_karyawan") REFERENCES "Karyawan"("no_karyawan"),
 FOREIGN KEY("no_jabatan") REFERENCES "Jabatan"("no_jabatan")
);

CREATE TABLE "Jabatan" (
 "no_jabatan" VARCHAR(6) NOT NULL,
 "nama_jabatan" VARCHAR(18) NOT NULL,
 PRIMARY KEY("no_jabatan")
);

CREATE TABLE "Karyawan" (
 "no_karyawan" INTEGER NOT NULL,
 "no_project" VARCHAR(5) NOT NULL,
 "no_jabatan" VARCHAR(6) NOT NULL,
 "no_departemen" INTEGER NOT NULL,
 "tanggal_lahir" DATE NOT NULL,
 "nama_awal" VARCHAR(11) NOT NULL,
 "nama_akhir" VARCHAR(10) NOT NULL,
 "jenis_kelamin" VARCHAR(1) NOT NULL,
 "alamat" VARCHAR(60) NOT NULL,
 "tanggal_diterima" DATE NOT NULL,
 "email" VARCHAR(29) NOT NULL,
 "nomor_handphone" INTEGER NOT NULL,
 FOREIGN KEY("no_jabatan") REFERENCES "Jabatan"("no_jabatan"),
 FOREIGN KEY("no_project") REFERENCES "Projek"("no_project"),
 FOREIGN KEY("no_departemen") REFERENCES "Departemen"("no_departemen"),
 PRIMARY KEY("no_karyawan")
);

CREATE TABLE "Projek" (
 "no_project" VARCHAR(5) NOT NULL,
 "no_departemen" VARCHAR(5) NOT NULL,
 "nama_project" VARCHAR(18) NOT NULL,
 "tanggal_mulai" DATE NOT NULL,
 "tanggal_berakhir" DATE NOT NULL,
 FOREIGN KEY("no_departemen") REFERENCES "Departemen"("no_departemen"),
 PRIMARY KEY("no_project")
);
