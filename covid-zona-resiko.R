# Load packages -----------------------------------------------------------

library(httr)
library(tidyverse)
library(lubridate)
# library(dplyr) # Jika bagian glimpse tidak jalan, gunakan library ini.

# Connect and fetch data --------------------------------------------------

resp <- GET("https://data.covid19.go.id/public/api/skor.json") 
#jika GET error, matikan VPN ya
status_code(resp)
#Check di console, apabila status code = 200, berarti sudah connect
resp_content <- content(resp, as = "parsed", simplifyVector = TRUE)

# Extract data ------------------------------------------------------------

risk_data <- resp_content$data
#risk_date <- dmy(resp_content$tanggal, locale = "id_ID.UTF-8")
#jika cara diatas error, dicomment, ubah dengan cara dibawah ini
risk_date <- today()
glimpse(risk_data)
glimpse(risk_date)

# Preprocess data ---------------------------------------------------------

risk <-
  risk_data %>%
  rename(
    province_name = prov,
    province_code = kode_prov,
    district_name = kota,
    disctrict_code = kode_kota,
    status = hasil
  ) %>%
  mutate(
    last_updated = risk_date,
    start_date = risk_date - 6,
    end_date = risk_date,
    across(where(is.character), str_to_title)
  ) %>%
  mutate(
    status = factor(
      status,
      levels = c(
        "Resiko Tinggi",
        "Resiko Sedang",
        "Resiko Rendah",
        "Tidak Ada Kasus",
        "Tidak Terdampak"
      )
    )
  ) %>%
  relocate(
    start_date,
    end_date,
    .before = province_name
  )

glimpse(risk)
str(risk)
# Exploratory data analysis -----------------------------------------------

#' Some questions:
#' 1. How is the latest status? How many cities/regencies with high risk status?
#' 2. Is there any area with 'no cases' or 'not affected' status? If so, where?
#' 3. Which province has the largest proportion of high risk and medium risk status?
#' 4. In Java Island, how is the current status?
#' 5. How about the trend? You need to collect weekly data to answer this.

# Simple data visualisation -----------------------------------------------

#melihat seluruh provinsi
risk %>%
  filter(last_updated == risk_date) %>%
  count(status) %>%
  ggplot(aes(status, n, fill = status)) +
  geom_col(width = 0.75, show.legend = FALSE) +
  ylim(0, 500)+
  scale_fill_manual(
    values = c(
      "Resiko Tinggi" = "#8E3B46",
      "Resiko Sedang" = "#FA8334",
      "Resiko Rendah" = "#FFE882",
      "Tidak Ada Kasus" = "#00916E",
      "Tidak Terdampak" = "#1B998B"
    )
  ) +
  labs(
    x = 20,
    y = 5,
    title = "Zona Resiko COVID-19 Per Kota/Kabupaten di Indonesia",
    subtitle = "Data didapatkan dari KPC-PEN (covid19.go.id)",
    caption = format(risk_date, format = "Pembaharuan data pada %e %B %Y")
  ) +
  theme_minimal(base_family = "Arial") +
  theme(
    plot.title.position = "plot",
    plot.caption.position = "plot",
    plot.title = element_text(size = rel(1.75), face = "bold"),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.y = element_blank(),
    plot.margin = margin(30, 30, 30, 30)
  )

#melihat Aceh saja, diubah-ubah sesuai provinsi yang mau dilihat saja
risk[risk$province_name %in% c("Aceh"),]  %>%
  filter(last_updated == risk_date) %>%
  count(status) %>%
  ggplot(aes(status, n, fill = status)) +
  geom_col(width = 0.75, show.legend = FALSE) +
  ylim(0, 500)+
  scale_fill_manual(
    values = c(
      "Resiko Tinggi" = "#8E3B46",
      "Resiko Sedang" = "#FA8334",
      "Resiko Rendah" = "#FFE882",
      "Tidak Ada Kasus" = "#00916E",
      "Tidak Terdampak" = "#1B998B"
    )
  ) +
  labs(
    x = 20,
    y = 5,
    title = "Zona Resiko COVID-19 Per Kota/Kabupaten di Indonesia",
    subtitle = "Data didapatkan dari KPC-PEN (covid19.go.id)",
    caption = format(risk_date, format = "Pembaharuan data pada %e %B %Y")
  ) +
  theme_minimal(base_family = "Arial") +
  theme(
    plot.title.position = "plot",
    plot.caption.position = "plot",
    plot.title = element_text(size = rel(1.75), face = "bold"),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.y = element_blank(),
    plot.margin = margin(30, 30, 30, 30)
  )

# diuncomment apabila mau disave datanya ya!
# ggsave(
# "outfile/risk_status.png",
#  width = 8,
#  height = 5,
#  dpi = 300
#)

# Save the data -----------------------------------------------------------

# write_csv(risk, paste0("data/risk_", risk_date, ".csv"))
# write_rds(risk, paste0("data/risk_", risk_date, ".rds"))

