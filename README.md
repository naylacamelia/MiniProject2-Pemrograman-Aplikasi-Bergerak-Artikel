**Nama**: Nayla Camelia Indraswari

**NIM**: 2409116009

**Kelas**: A

## 📑 Aplikasi Personal Blog

Aplikasi ini merupakan aplikasi mobile sederhana berbasis Flutter yang berfungsi sebagai platform blogging pribadi. Pengguna dapat menulis artikel dengan judul, deskripsi, nama penulis, dan konten, lalu mempublikasikannya ke halaman utama. Aplikasi ini juga memungkinkan pengguna untuk memodifikasi artikel, mulai dari mengedit hingga menghapus artikel yang telah dibuat.

---

## 💻 Fitur Aplikasi

| Fitur | Kegunaan |
|-----|---|
| **Registrasi Akun** | Membuat akun baru dengan menginputkan email, nickname, password, dan konfirmasi password|
| **Login** | Masuk ke aplikasi menggunakan email dan password|
| **Halaman Utama** | Menampilkan semua artikel yang telah dipublikasikan|
| **Baca Artikel** | Membuka halaman detail untuk membaca konten artikel secara lengkap |
| **Unggah Artikel** | Membuat artikel baru dengan mengisi TextFiled yang bersifat wajib (judul, author, dan konten) dan deskripsi judul yang bersifat opsional |
| **Edit Artikel** | Mengubah artikel yang telah dibuat |
| **Hapus Artikel** | Menghapus artikel dengan konfirmasi dialog |
| **Cari Artikel** | Mencari artikel berdasarkan judul, deskripsi, dan nama author |
| **Tema Aplikasi** | Tema aplikasi (dark/light mode) dapat diubah secara manual lewat tombol di halaman utama |
---

## 📑 Struktur Database
---
### Tabel `profiles`
 
Menyimpan seluruh akun pengguna yang terdaftar pada aplikasi, berikut rinciannya:
 
- `id` — Primary key bertipe UUID, nilainya sama dengan id akun auth user
- `display_name` — Nama User yang akan ditampilkan sebagai nickname author pada artikel
- `created_at` — Waktu profil dibuat, terisi otomatis
---

### Tabel `articles`
 
Menyimpan seluruh artikel yang ditulis oleh pengguna. Setiap artikel terhubung ke user yang membuatnya melalui kolom user_id.
- `id` — Primary key bertipe UUID, di-generate otomatis oleh database menggunakan `gen_random_uuid()`
- `title` — Judul artikel, wajib diisi
- `description` — Deskripsi singkat artikel, opsional
- `content` — Isi artikel, wajib diisi
- `author` — Nama author yang diambil, diperoleh dari **display_name** di tabel **profiles**
- `user_id` — UUID yang merujuk ke akun auth pemilik artikel
- `status` — Status artikel, default **published**
- `created_at` — Waktu artikel dibuat, terisi otomatis
- `updated_at` — Waktu artikel terakhir diubah/edit

## 🔒 Keamanan Database (RLS)
 
### Tabel `articles`
 
- Semua user dapat membaca semua artikel yang dipublikasikan (oleh semua user)
- User hanya dapat membuat artikel menggunakan akunnya sendiri
- User hanya dapat mengubah dan menghapus artikel miliknya sendiri
 
## 💻 Struktur Halaman

Aplikasi memiliki struktur kode yang dibedakan berdasarkan folder sesuai dengan kegunaannya, dengan rincian sebagai berikut:

```
lib/
├── controllers/
│   └── theme_controller.dart   
├── models/
│   └── article.dart            
├── pages/
│   ├── auth_page.dart          
│   ├── home_page.dart          
│   ├── detail_page.dart        
│   ├── posting_page.dart       
│   ├── login_page.dart         
│   └── regis_page.dart         
└── main.dart              
```

- **main.dart** : awal mula berjalannya aplikasi, konfigurasi tema light dan dark mode, serta inisialisasi koneksi ke Supabase
- **controllers/theme_controller.dart** : Mengatur perpindahan dark mode dan light mode menggunakan GetX
- **models/article.dart** : struktur data artikel beserta logika parsing data dari Supabase
- **pages/auth_page.dart** : Gerbang akses aplikasi. Mendeteksi session aktif dan mengarahkan user ke halaman yang sesuai
- **pages/home_page.dart** : Beranda aplikasi. Menampilkan seluruh daftar artikel dari Supabase dan menjadi pusat navigasi untuk membaca, membuat, mengedit, serta menghapus artikel
- **pages/detail_page.dart** : Halaman untuk membaca isi artikel secara lengkap beserta info author dan tanggal publikasi
- **pages/posting_page.dart** : Halaman untuk menulis dan mengedit artikel. Author terisi otomatis dari profil yang sedang login
- **pages/login_page.dart** : Halaman masuk aplikasi menggunakan email dan password
- **pages/regis_page.dart** : Halaman pembuatan akun baru dengan menginputkan email, nickname, dan password

---

## 💻 Widget yang Digunakan

<details>
<summary><b>Layout & Struktur Aplikasi</b></summary>
<br>
 
- **GetMaterialApp** — Widget root aplikasi dari GetX, menggantikan `MaterialApp` standar. Mendukung navigasi GetX dan manajemen tema
- **Scaffold** — Kerangka dasar setiap halaman yang menyediakan struktur AppBar, body, FloatingActionButton, dan BottomNavigationBar
- **AppBar** — Header halaman untuk menempatkan judul, tombol navigasi, tombol aksi, dan garis pemisah di bagian bawah
- **BottomNavigationBar** — Navigasi tab di bagian bawah layar untuk berpindah antara tab Explore dan My Blog
- **SafeArea** — Memastikan konten tidak tertutup elemen sistem seperti notch atau status bar
- **Center** — Memusatkan child secara horizontal dan vertikal di dalam ruang yang tersedia
- **ConstrainedBox** — Membatasi ukuran child sesuai constraints yang ditentukan, digunakan untuk mengatur lebar maksimal konten
- **Column** — Menyusun widget secara vertikal dari atas ke bawah
- **Row** — Menyusun widget secara horizontal dalam satu baris
- **Padding** — Memberikan jarak di sekeliling atau sisi tertentu dari sebuah widget
- **Container** — Widget serbaguna untuk menambahkan dekorasi, warna, ukuran, dan padding pada child
- **SizedBox** — Memberikan jarak kosong antar widget atau memaksa ukuran tertentu pada widget
- **Expanded** — Membuat child mengisi semua ruang yang tersisa di dalam Row atau Column
- **Align** — Mengatur posisi child di dalam parent ke posisi tertentu
- **PreferredSize** — Membungkus widget agar dapat digunakan sebagai `bottom` AppBar dengan ukuran eksplisit

  
</details>

---

<details>
<summary><b>Scroll & List</b></summary>
<br>

- **SingleChildScrollView** — Membuat konten yang melebihi ukuran layar dapat di-scroll
- **ListView.builder** — Menampilkan daftar item secara dinamis dan efisien, hanya merender item yang terlihat di layar

</details>

---

<details>
<summary><b>Input & Form</b></summary>
<br>

- **Form** — Membungkus kumpulan `TextFormField` dan mengelola validasi seluruh field sekaligus menggunakan `GlobalKey<FormState>`
- **TextFormField** — Input teks yang terintegrasi dengan `Form`, mendukung validasi bawaan dengan pesan error di bawah field
- **TextField** — Input teks tanpa integrasi Form, digunakan untuk tampilan yang bersih tanpa border pada halaman tulis artikel
  
</details>

---

<details>
<summary><b>Tombol</b></summary>
<br>

- **ElevatedButton** — Tombol dengan tampilan menonjol, digunakan sebagai tombol utama seperti Sign In, Publish, dan Update
- **TextButton** — Tombol teks tanpa background, digunakan sebagai tombol aksi di dalam AlertDialog
- **IconButton** — Tombol berbentuk ikon untuk toggle tema, logout, tombol back, dan show/hide password
- **FloatingActionButton** — Tombol aksi melayang di pojok kanan bawah, ditampilkan hanya di tab My Blog
- **GestureDetector** — Mendeteksi gesture tap tanpa efek visual, digunakan pada teks navigasi antar halaman auth
- **InkWell** — Area yang bisa di-tap dengan efek ripple, digunakan pada card artikel di tab Explore
- **PopupMenuButton** — Menampilkan menu pilihan saat ikon ditekan, digunakan untuk opsi Edit dan Delete artikel
- **PopScope** — Mengontrol perilaku tombol back sistem untuk mencegah user keluar tanpa sengaja saat menulis artikel

</details>

---

<details>
<summary><b>Tampilan & Dekorasi</b></summary>
<br>

- **Card** — Menampilkan konten dalam kotak dengan elevasi dan border, digunakan untuk artikel di tab My Blog
- **AlertDialog** — Dialog pop-up untuk konfirmasi aksi penting seperti Sign Out, Delete, dan konfirmasi keluar draft
- **CircleAvatar** — Menampilkan inisial atau ikon dalam bentuk lingkaran, digunakan untuk avatar penulis artikel
- **Icon** — Menampilkan ikon dari koleksi Material Icons
- **Divider** — Garis horizontal tipis sebagai pemisah antar konten
- **CircularProgressIndicator** — Animasi loading berbentuk lingkaran, ditampilkan saat fetch data atau proses autentikasi

</details>

---

<details>
<summary><b>State Management & Asynchronous UI</b></summary>
<br>

- **StreamBuilder** —  Membangun UI berdasarkan data yang terus berubah secara realtime. Digunakan untuk mendengarkan perubahan status login dari Supabase dan mengarahkan user ke halaman yang sesuai
- **FutureBuilder** — Membangun UI berdasarkan hasil proses yang membutuhkan waktu. Digunakan untuk mengecek apakah profil user sudah ada setelah status login terdeteksi
- **Obx** — Widget dari GetX yang otomatis memperbarui tampilan saat ada nilai yang berubah. Digunakan untuk tombol toggle tema dan judul AppBar agar ikut berubah saat tema atau tab aktif berganti

</details>

---

## ⚙️ Dependencies Tamabahan
 
- **supabase_flutter** : Package untuk menghubungkan aplikasi Flutter dengan Supabase, mencakup autentikasi dan operasi database
- **get** : Package GetX untuk navigasi antar halaman dan manajemen perubahan tema aplikasi
- **google_fonts** : Package untuk menggunakan font dari Google Fonts, digunakan untuk font Rubik dan Merriweather di seluruh aplikasi
- **flutter_dotenv** : Package untuk membaca file `.env`, digunakan untuk menyimpan Supabase URL dan API Key agar tidak ter-expose di kode dan tidak ter-upload ke GitHub
 
```yaml
dependencies:
  flutter:
    sdk: flutter
  
  google_fonts: ^6.2.1
  get: ^4.7.3
  supabase_flutter: ^2.12.0
  flutter_dotenv: ^5.1.0
```
---
## 🔐 Environment Variables
 
Aplikasi ini menggunakan file `.env` untuk menyimpan kredensial Supabase. File ini tidak ikut di-upload ke GitHub karena sudah didaftarkan di `.gitignore`.
 
Membuat file `.env` di root project yang beriisi Supabase URL dan API Key lalu daftarkan sebagai asset di `pubspec.yaml`:
 
```yaml
flutter:
  assets:
    - .env
```
---
## 🔍 Tampilan Aplikasi
 
---
 ### 1. Register Page
 
Halaman pembuatan akun baru. User mengisi email, nickname, password, dan konfirmasi password.
 
<table>
  <tr>
    <td align="center"><b>Tampilan Utama</b></td>
    <td align="center"><b>Validasi Field Kosong</b></td>
    <td align="center"><b>Format Input Salah</b></td>
  </tr>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/f4b782da-e248-4be8-b93c-d9c5cb3ec632" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/98bb35ba-8395-4f4e-b336-4e6bf879e022" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/d3b56db7-4413-4a7d-be63-61fd19f29ab1" width="200"/></td>
  </tr>
</table>
 

---
### 2. Login Page
 
Halaman masuk aplikasi menggunakan email dan password. Terdapat validasi input dan penanganan error dari Supabase.
 
<table>
  <tr>
    <td align="center"><b>Tampilan Utama</b></td>
    <td align="center"><b>Validasi Field Kosong</b></td>
    <td align="center"><b>Error Login</b></td>
  </tr>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/b57bfc22-c536-42ce-ad4f-b96161d55d03" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/fa430a13-ebb0-4d81-82a8-ae2f49159de6" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/2d1e8c33-81dd-4e80-b26b-d0bb5ad9b4cf" width="200"/></td>
  </tr>
</table>
 
---
 
### 3. Home Page (Explore)
 
Menampilkan seluruh artikel dari semua user dan memiliki fitur search untuk mencari artikel berdasarkan judul, isi konten, deskripsi ataupun nama author.
 
<table>
  <tr>
    <td align="center"><b>Tampilan Utama</b></td>
    <td align="center"><b>Hasil Pencarian</b></td>
    <td align="center"><b>Tidak Ada Hasil</b></td>
    <td align="center"><b>Konfirmasi Sign Out</b></td>
  </tr>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/52f844f1-cda4-421e-96fd-34dc6742392b" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/4da9ad89-edf2-430c-9e25-b0d61e882b0f" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/ff61bf0d-d0e0-4f2b-aa10-ea9894a0d5e0" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/d7c2ef87-6695-449e-9f12-0fdc1f5d26bb" width="200"/></td>
  </tr>
</table>
 
---
 
### 4. Home Page (Artikel Pribadi)
 
Menampilkan artikel milik pengguna yang sedang login beserta opsi edit dan delete.
 
<table>
  <tr>
    <td align="center"><b>Tampilan Utama</b></td>
    <td align="center"><b>Menu Edit / Delete</b></td>
    <td align="center"><b>Konfirmasi Delete</b></td>
  </tr>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/c46bd4be-f32d-4cd8-af6d-3c3511131714" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/40f35269-1e30-48b1-976b-105a402be47b" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/55485631-db58-4e8b-a86c-b6007b5c0b25" width="200"/></td>
  </tr>
</table>
---
 
### 5. Posting Page (Tambah Artikel)
 
Halaman untuk menulis dan mempublikasikan artikel baru.
 
<table>
  <tr>
    <td align="center"><b>Tampilan Utama</b></td>
    <td align="center"><b>Validasi Seluruh Field Kosong</b></td>
    <td align="center"><b>Validasi Tittle Kosong</b></td>
    <td align="center"><b>Validasi Konten Kosong</b></td>
    <td align="center"><b>Konfirmasi Keluar</b></td>
  </tr>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/fd853f98-eb44-4b9e-a5a7-9633bc671bd1" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/6e44eada-cfc6-4759-b185-b188394a8615" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/dc35bb80-b0fa-4d97-8cc9-d299bcc5d0d9" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/8ec7c45e-72aa-452a-8e1b-ee202f052c2f" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/3f905f27-d7d6-4441-a236-d4e33b0c6cbf" width="200"/></td>
  </tr>
</table>
 
---
 
### 6. Posting Page (Edit Artikel)
 
Mode edit aktif saat user memilih Edit dari menu artikel. Tombol Update menggantikan Publish.
 
<table>
  <tr>
    <td align="center"><b>Tampilan Menu Edit</b></td>
    <td align="center"><b>Konfirmasi Keluar</b></td>
    <td align="center"><b>Setelah Diperbarui</b></td>
  </tr>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/ff453794-b217-4306-a7ec-ea6b408a2b7c" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/379afd70-4003-4acf-9239-92fabc16adad" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/74023da8-4513-4d19-a3b7-297c7e7aaadb" width="200"/></td>
  </tr>
</table>
 
 
---
 
### 7. Detail Page
 
Halaman untuk membaca artikel secara lengkap.
 
<table>
  <tr>
    <td align="center"><b>Tampilan Artikel</b></td>
  </tr>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/ec53900b-c8ca-4b5f-89d8-5d55d87a3ec0" width="200"/></td>
  </tr>
</table>
 
---
 
### 8. Dark Mode
 
Tampilan seluruh halaman dalam mode gelap.
 
<table>
  <tr>
    <td align="center"><b>Registrasi</b></td>
    <td align="center"><b>Login</b></td>
    <td align="center"><b>Explore</b></td>
    <td align="center"><b>My Blog</b></td>
    <td align="center"><b>Detail Page</b></td>
  </tr>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/e6188556-a25a-4a4d-a33d-2a56e51ff579" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/96ebf03e-4dca-4c00-92de-15d0bdbd4686" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/011d56a9-4ded-429a-aeea-8bf105246b22" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/cad9e685-dbc8-4c7a-b4db-462c4f9b19a8" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/9a5f14da-cb69-4496-b4f8-f71e0c2235ce" width="200"/></td>
  </tr>
</table>
