# Data Wrangling di R
# Missing Value
# Berbagai jenis tipe data
x <- NA
typeof(x)
is.na(x)
c(1, 2, FALSE, 3)
typeof(NA_integer_)
typeof(NA_real_)
typeof(NA_complex_)
typeof(NA_character_)
is.na(NA_integer_)
is.na(NA_real_)
is.na(NA_complex_)
is.na(NA_character_)
c(1, 2, NA, 4, 5)

# Melihat type data
isi.vector <- c(1,2,3,NA,3,1)
lapply(isi.vector, typeof)
is.na(isi.vector)

# Vector tidak apa adanya dengan NULL
isi.vector<- c(1, 2, 3, NA, 5, NULL, 7)
length(isi.vector)

# List apa adanya untuk NULL
isi.list <- list(1, NULL, 3, NA, 5)
length(isi.list)

# inf pada data
1/0 # tampilkan info infinitive

# NAN pada data (Tidak mempresentasikan apapun)
0/0
warning(log(-100))
is.nan(0/0) # cara baca NaN

isi.vector <- c(1,2,NA,4,5,NaN,6)
sum(is.na(isi.vector)==TRUE)

# as.factor for visualization
factor(c("Jan","Feb","Mar"))
faktor.bulan <- factor(c("Jan","Feb","Mar"))
attributes(faktor.bulan)

faktor.bulan <- factor(c("Jan","Feb","Mar"))
levels(faktor.bulan)
class(faktor.bulan)

#Buatlah factor dengan teks "Jan", "Feb", "Mar","Jan","Mar", dan "Jan"
factor.bulan <- factor(c("Jan","Feb","Mar","Jan","Mar","Jan"))
#Mengganti levels 
levels(factor.bulan)[2] <- "Januari"
levels(factor.bulan)[3] <- "Maret"
as.integer(factor.bulan)
factor.bulan

#Buatlah factor bernama factor.umur dengan isi c(12, 35, 24, 12, 35, 37)
factor.umur <- factor(c(12, 35, 24, 12, 35, 37))
#Tampilkan variable factor.umur 
factor.umur

#Buatlah variable factor.lokasi dengan isi berupa vector c("Bandung", "Jakarta", NA, "Jakarta", NaN, "Medan", NULL, NULL, "Bandung") 
factor.lokasi <- factor(c("Bandung", "Jakarta", NA, "Jakarta", NaN, "Medan", NULL, NULL, "Bandung"))
#Tampilkan factor.lokasi
factor.lokasi
length(factor.lokasi) #NULL tidak dihitung

#Menentukan levels sesuka kita
factor(c("Jan","Feb","Mar","Jan","Mar"), levels = c("Jan","Feb","Mar"))

# membaca tipe data CSV
# check.names = FALSE untuk tidak menambahkan data yang kosong
penduduk.dki <- read.csv("https://storage.googleapis.com/dqlab-dataset/dkikepadatankelurahan2013.csv", sep=",")
penduduk.dki

#profile dataset
str(penduduk.dki)
summary(penduduk.dki)

# contoh data tsv
penduduk.dki <- read.csv("https://storage.googleapis.com/dqlab-dataset/dkikepadatankelurahan2013.tsv", sep="\t",
                         check.names = FALSE)
str(penduduk.dki)

# contoh data xlsx
library("openxlsx")
penduduk.dki.xlsx <- read.xlsx(xlsxFile="https://storage.googleapis.com/dqlab-dataset/dkikepadatankelurahan2013.xlsx")
str(penduduk.dki.xlsx)
# tanpa menambahkan check.names untuk data yang null

#struktur transformation pada data
#menampilkan nama kolom
names(penduduk.dki.xlsx)
#merubah nama kolom
names(penduduk.dki.xlsx)[1] <- "PERIODE"
names(penduduk.dki.xlsx)
names(penduduk.dki.xlsx)[c(1:2)] <- c("PERIODE", "PROPINSI")

#melakukan filter data
penduduk.dki <- penduduk.dki[,!names(penduduk.dki) %in% c("X", "X.1","X.2","X.3","X.4","X.5","X.6","X.7","X.8","X.9","X.10", "X.11")]
str(penduduk.dki)

#merubah tipe data
penduduk.dki.xlsx$NAMA.PROVINSI <- as.factor(penduduk.dki.xlsx$NAMA.PROVINSI)
str(penduduk.dki.xlsx)

#filtering kategori dengan grep
pola_nama_perempuan <- grep(pattern="perempuan", x = names(penduduk.dki.xlsx), ignore.case=TRUE)
names(penduduk.dki.xlsx[pola_nama_perempuan])
# ignore.case = TRUE (tidak sensitive)
pola_nama_laki_laki <- grep(pattern="laki", x = names(penduduk.dki.xlsx), ignore.case=TRUE)
names(penduduk.dki.xlsx[pola_nama_laki_laki])

#untuk penjumlahan pembulatan
pola_nama_perempuan <- grep(pattern="perempuan", x = names(penduduk.dki.xlsx), ignore.case=TRUE)
penduduk.dki.xlsx$PEREMPUAN35TAHUNKEATAS <- rowSums(penduduk.dki.xlsx[pola_nama_perempuan])
penduduk.dki.xlsx$PEREMPUAN35TAHUNKEATAS                        

#normalisasi data dari kolom ke baris
library('reshape2')
penduduk.dki.transform <- melt(data=penduduk.dki.xlsx, id.vars=c( "NAMA.KECAMATAN", "NAMA.KELURAHAN"), measure.vars = c("35-39.Laki-Laki", "35-39.Perempuan"), 
                               variable.name = "DEMOGRAFIK", value.name="JUMLAH")
# memecah data kolom
penduduk.dki.transform[c("RENTANG.UMUR", "JENIS.KELAMIN")] <- colsplit(penduduk.dki.transform$DEMOGRAFIK, "\\.", c("RENTANG.UMUR", "JENIS.KELAMIN"))
penduduk.dki.transform$DEMOGRAFIK <- NULL
penduduk.dki.transform
library()