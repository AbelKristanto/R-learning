# BASIC R
# 1. Penulisan Code Pertama
"Hello World"

# 2. Penulisan Angka dan Hitung
10 + 7

# 2.1 Dengan cara fungsi PRINT
print("Hello World")
print(10 + 7)

# 3. Variabel dalam R
a = 5
print(a)
pi <- 3.14
pi

# 4. Pembuatan Vektor
# Fungsi c disertai data-data yang ingin disimpan.
c(5, 10, 20) # Ini menyimpan nilai 5, 10, 20 dalam satu struktur
angka <- c(5, 10, 20)
print(angka)
angka1 <- c(1, 2, 3, 4)
c(4:1) # Ini menyimpan angka berurutan
menu_dinner <- c("Mugigae","Pecel Lele","KCF")
print(menu_dinner)

# 4.1 Index dan Accessor
angka[2]
menu_dinner[3]

data_mahasiswa <- c("Budi", "Alex", "Dono")
data_mahasiswa

# 4.2 Named Vector
profil <- c(nama = "Ana", domisili = "Jakarta", pendidikan = "S2")
print(profil)
print(profil['nama'])

# 5. List pada R (Bisa berbagai jenis data)
profil <- list(nama="Budi", usia=23, asal="Jogja")
print("profil")
# 5.1 Index dan Accessor
profil['nama']
profil[2]

# 6. Dataframe (Representasi tabel)
nama <- c("Angel", "Budi", "Alex", "Joko", "Kanto")
usia <- c(16, 28, 40, 65, 35)
info_responden <- data.frame(nama, usia)
info_responden

nama <- c("Angel", "Budi", "Alex", "Joko", "Kanto")
usia <- list(26, 28, 24, 65, 35)
info_responden <- data.frame(nama, usia)
info_responden

# 6.1 Akses Dataframe
info_responden$nama

# 7. Informasi statistik dalam data
summary(c(20:5))

# 8. Membaca file Excel
library(openxlsx)
mahasiswa <- read.xlsx("https://storage.googleapis.com/dqlab-dataset/mahasiswa.xlsx",sheet = "Sheet 1")
print(mahasiswa$Prodi)

# Plotting di R
# 1. Demografi Responden
library("ggplot2")
gambar <- ggplot(info_responden, aes(x=nama, y=usia, fill=usia))
gambar <- gambar + geom_bar(width=1, stat="identity")
gambar <- gambar + ggtitle("Jumlah Persebaran data")
gambar <- gambar + xlab("Nama Responden")
gambar <- gambar + ylab("Usia Responden")
gambar

#buat variabel sendiri
#Fakultas <- c("Bisnis", "IT", "Ekonomi")
#Jumlah <- c(20, 30, 40)
#ANGKATAN <- c(2010, 2011, 2012)
#mahasiswa <- data.frame(Fakultas, Jumlah, Angkatan)

# 2. Visualisasi data excel
gambar <- ggplot(mahasiswa, aes(x=Fakultas, y=JUMLAH, fill=Fakultas))
gambar <- gambar + geom_bar(width=1, stat="identity")
gambar <- gambar + ggtitle("Jumlah Persebaran Fakultas")
gambar <- gambar + xlab("Nama Fakultas")
gambar <- gambar + ylab("Jumlah") 
gambar

# 3. Visualisasi Summary
# BAR
summarybyfakultas <- aggregate(x=mahasiswa$JUMLAH, by=list(Kategori=mahasiswa$Fakultas, Tahun=mahasiswa$ANGKATAN), FUN=sum)
summarybyfakultas <- setNames(summarybyfakultas, c("fakultas","tahun", "jumlah_mahasiswa"))
summarybyfakultas
summarybyfakultas$tahun = as.factor(summarybyfakultas$tahun)
ggplot(summarybyfakultas, aes(x=fakultas, y=jumlah_mahasiswa)) + 
  geom_bar(stat = "identity", aes(fill = tahun), width=0.8, position = position_dodge(width=0.8)) + 
  theme_classic()
# PIE
summarybyfakultas <- aggregate(x=mahasiswa$JUMLAH, by=list(Kategori=mahasiswa$Fakultas), FUN=sum)
summarybyfakultas <- setNames(summarybyfakultas, c("fakultas","jumlah_mahasiswa"))
piechart<- ggplot(summarybyfakultas, aes(x="", y=jumlah_mahasiswa, fill=fakultas))+ geom_bar(width = 1, stat = "identity")
piechart <- piechart + coord_polar("y", start=0)
piechart <- piechart + ggtitle("Disribusi Mahasiswa per Fakultas")
piechart <- piechart + scale_fill_brewer(palette="Blues")+ theme_minimal()
piechart <- piechart + guides(fill=guide_legend(title="Fakultas"))
piechart <- piechart + ylab("Jumlah Mahasiswa") 
piechart

# 4. Filtering Visualization
summarybyfakultas <- aggregate(x=mahasiswa$JUMLAH, by=list(Kategori=mahasiswa$Fakultas, Tahun=mahasiswa$ANGKATAN), FUN=sum)
summarybyfakultas <- setNames(summarybyfakultas, c("fakultas","tahun", "jumlah_mahasiswa"))
summarybyfakultas
summarybyfakultas$tahun = as.factor(summarybyfakultas$tahun)
summarybyfakultas[summarybyfakultas$fakultas %in% c("ICT", "Ilmu Komunikasi"),]

ggplot(summarybyfakultas[summarybyfakultas$fakultas %in% c("ICT", "Ilmu Komunikasi"),], aes(x=fakultas, y=jumlah_mahasiswa)) + 
  geom_bar(stat = "identity", aes(fill = tahun), width=0.8, position = position_dodge(width=0.8)) + 
  theme_classic() 

