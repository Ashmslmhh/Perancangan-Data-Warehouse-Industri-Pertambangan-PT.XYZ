\# RUNBOOK

\# PT XYZ Data Warehouse - Industri Pertambangan





\# 1. Pendahuluan



Dokumen ini menjelaskan langkah instalasi, konfigurasi, eksekusi,

dan validasi implementasi Data Warehouse PT XYZ Industri Pertambangan.



Implementasi mengikuti struktur, skema, dan alur proses yang tersedia pada repository:



Perancangan-Data-Warehouse-Industri-Pertambangan-PT.XYZ



Komponen utama yang digunakan:



\- Docker

\- Docker Compose

\- Microsoft SQL Server 2022

\- Apache Airflow

\- PostgreSQL

\- Redis

\- Metabase

\- Superset

\- Grafana

\- Jupyter Notebook





\---



\# 2. Arsitektur Sistem

&#x20;               Data Source

&#x20;                   |

&#x20;                   |

&#x20;         CSV Mining Dataset

&#x20;                   |

&#x20;                   v



&#x20;             Staging Layer

&#x20;        (staging schema SQL Server)



&#x20;                   |

&#x20;                   v



&#x20;           ETL Pipeline Airflow



&#x20;         +----------------+

&#x20;         | Dimension Load |

&#x20;         +----------------+



&#x20;         +--------------+

&#x20;         |  Fact Load   |

&#x20;         +--------------+



&#x20;                   |

&#x20;                   v



&#x20;         PTXYZ\_DataWarehouse



&#x20;         dim schema

&#x20;         fact schema



&#x20;                   |

&#x20;                   v



&#x20;        Dashboard / Analytics



&#x20;  Metabase - Superset - Grafana







Arsitektur Data Warehouse PT XYZ menggunakan pendekatan dimensional model.



Data sumber berupa dataset CSV pertambangan dimuat ke staging layer,

kemudian diproses melalui pipeline ETL menggunakan Apache Airflow.



Hasil transformasi disimpan pada Data Warehouse dengan pemisahan schema:



\- dim untuk tabel dimensi

\- fact untuk tabel fakta

\- staging untuk penyimpanan data sementara sebelum proses transformasi



Data Warehouse kemudian digunakan untuk kebutuhan analisis melalui tools:



\- Metabase

\- Superset

\- Grafana





\---



\# 3. Environment Setup





\## 3.1 Clone Repository





Repository dikloning menggunakan:





```bash

git clone https://github.com/Ashmslmhh/Perancangan-Data-Warehouse-Industri-Pertambangan-PT.XYZ.git





3.2 Software Requirement



Software yang digunakan:

Software	Versi

Git	2.53.0

Docker	29.4.2

Docker Compose	5.1.3

SQL Server	2022



3.3 Struktur Repository

Struktur utama repository:

Perancangan-Data-Warehouse-Industri-Pertambangan-PT.XYZ



├── airflow

├── dags

├── data

├── dashboard

├── init-scripts

├── misi1

├── misi2

├── misi3

├── src

├── tests

│   └── validate.sql

├── docker-compose.yml

├── README.md

└── RUNBOOK.md



4\. Deployment Docker

Seluruh layanan dijalankan menggunakan:

docker compose up -d



Service yang aktif:

\- SQL Server

\- Airflow Scheduler

\- Airflow Webserver

\- Airflow Worker

\- PostgreSQL

\- Redis

\- Superset

\- Metabase

\- Grafana

\- Jupyter



Validasi service:

docker compose ps



Hasil:

Semua service berhasil berjalan dengan status healthy.



5\. Database Initialization

Database dibuat otomatis melalui:

init-scripts/create-schema.sql



Database:

init-scripts/create-schema.sql



Schema:

init-scripts/create-schema.sql



Tabel dimension:

DimTime

DimSite

DimEquipment

DimMaterial

DimEmployee

DimShift

DimProject

DimAccount



Tabel fact:

FactEquipmentUsage

FactProduction

FactFinancialTransaction



6\. Dataset Source

Dataset yang digunakan berasal dari repository dan digunakan tanpa perubahan struktur.

Dataset:

dataset\_alat\_berat\_dw.csv

dataset\_production.csv

dataset\_transaksi.csv



Dataset tersebut digunakan sebagai sumber proses ETL Data Warehouse.



7\. ETL Execution

7.1 Dimension Loading

Proses dimension loading dijalankan melalui Airflow DAG:

ptxyz\_dimension\_loader



Task yang berhasil:

\- load\_staging\_data

\- load\_dim\_time

\- load\_dim\_site

\- load\_dim\_equipment

\- load\_dim\_material

\- load\_dim\_employee

\- load\_dim\_shift

\- load\_dim\_project

\- load\_dim\_account

\- validate\_dimensions

Status:

Success



7.2 Fact Loading

Proses fact loading dijalankan melalui:

ptxyz\_fact\_loader



Task:

\- load\_fact\_equipment\_usage

\- load\_fact\_production

\- load\_fact\_financial

\- validate\_fact\_tables

Status:

SUCCESS





8\. Hasil Data Warehouse

Jumlah data setelah proses ETL:

| Table | Count |

|---|---:|

| DimTime | 830 |

| DimSite | 612 |

| DimEquipment | 6 |

| DimMaterial | 5 |

| DimEmployee | 10 |

| DimShift | 3 |

| DimProject | 50 |

| DimAccount | 30 |

| FactEquipmentUsage | 236892 |

| FactProduction | 1266 |

| FactFinancialTransaction | 1997 |



Hasil tersebut menunjukkan bahwa proses ETL berhasil menghasilkan

Data Warehouse sesuai struktur repository.



9\. Automated Validation

Validasi otomatis dibuat menggunakan:

tests/validate.sql



Eksekusi validasi:

docker exec -it ptxyz\_sqlserver bash





/opt/mssql-tools18/bin/sqlcmd \\

\-S localhost \\

\-U sa \\

\-P <MSSQL\_PASSWORD> \\

\-C \\

\-i /tests/validate.sql



Validasi meliputi:

9.1 Schema Validation

Memastikan tabel sesuai dengan rancangan Data Warehouse.

Hasil:

14 tabel berhasil ditemukan



9.2 Row Count Validation

Memastikan jumlah data sesuai hasil ETL.

Hasil:



FactEquipmentUsage            236892

FactProduction                  1266

FactFinancialTransaction        1997



9.3 Foreign Key Validation

Memastikan seluruh foreign key pada fact table memiliki referensi valid.

Hasil:

0 orphan record



9.4 Duplicate Validation

Validasi menggunakan surrogate key.

Hasil:

usage\_key\_duplicate          0

production\_key\_duplicate     0



9.5 Data Range Validation

Validasi nilai numerik.

Hasil:

negative\_operating\_hours     0



10\. Bukti Eksekusi

10.1 Dimension Loader

DAG:

ptxyz\_dimension\_loader

Status:

SUCCESS



Task dimension berhasil dijalankan seluruhnya.



10.2 Fact Loader

DAG:

ptxyz\_fact\_loader

Status:

SUCCESS



Task fact berhasil dijalankan seluruhnya.



10.3 Database Validation

Hasil akhir validasi:

Foreign Key Check



FactEquipmentUsage\_time          0

FactEquipmentUsage\_site          0

FactEquipmentUsage\_equipment     0

FactProduction\_time               0

FactFinancial\_account             0





Aggregate Validation



FactEquipmentUsage              236892

FactProduction                    1266

FactFinancialTransaction          1997





11\. Pemetaan README terhadap Implementasi

| Requirement README | Implementasi |

|---|---|

| Docker Compose | docker compose up -d |

| Database Setup | init-scripts/create-schema.sql |

| Dimensional Model | schema dim dan fact |

| ETL Pipeline | Apache Airflow |

| Dimension Loading | ptxyz\_dimension\_loader |

| Fact Loading | ptxyz\_fact\_loader |

| Data Validation | tests/validate.sql |

| Dashboard Analytics | Metabase, Superset, Grafana |





12\. Kendala dan Solusi

12.1 Airflow Docker Build Error

Masalah:

plugins/: not found

Penyebab:

Folder plugins belum tersedia.

Solusi:

Membuat folder:

airflow/plugins



12.2 SQL Server Initialization Error

Masalah:/bin/bash^M bad interpreter

Penyebab:

File script menggunakan format Windows CRLF.

Solusi:

Mengubah format file menjadi Linux LF.



12.3 SQL Server Password Mismatch

Masalah:

Container gagal melakukan koneksi SQL Server.

Solusi:

Menyesuaikan konfigurasi pada: .env

dengan password SQL Server yang digunakan.





13\. Kesimpulan

Implementasi PT XYZ Data Warehouse berhasil dijalankan secara end-to-end.

Hasil implementasi:

\- Database berhasil dibuat

\- Dimensional model berhasil diterapkan

\- ETL berjalan menggunakan Apache Airflow

\- Data berhasil dimuat ke Data Warehouse

\- Validasi otomatis berhasil dijalankan

\- Semua foreign key valid

\- Tidak terdapat orphan record

\- Output sesuai dengan struktur repository

