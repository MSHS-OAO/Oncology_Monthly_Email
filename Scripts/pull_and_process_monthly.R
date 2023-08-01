library(DBI)
library(odbc)
library(lubridate)
library(glue)
library(readr)
library(zip)

dsn <- "OAO Cloud DB"

conn <- dbConnect(odbc(), dsn)

todays_date <- Sys.Date()
last_month <- todays_date %m-% months(1)
month_year <- format(last_month, '%Y-%m')

sql_statement <- glue("SELECT * FROM ONCOLOGY_ACCESS WHERE APPT_MONTH_YEAR = '{month_year}' AND APPT_STATUS = 'Arrived'")
previous_month_data <- dbGetQuery(conn, sql_statement)

save_uncompressed_file_path <- paste0("/SharedDrive/deans/Presidents/HSPI-PM/Operations Analytics and Optimization/Projects/Service Lines/Oncology/Monthly Oncology Email/Uncompressed/Oncology_Data_",
                         month_year, " created ", format(Sys.time(), "%Y-%m-%d %H.%M"), ".csv")

write_csv(previous_month_data, save_uncompressed_file_path)

save_compressed_file_path <- gsub("\\<Uncompressed\\>","Compressed",save_uncompressed_file_path)
save_compressed_file_path <- gsub("\\<csv\\>","zip",save_compressed_file_path)

zip(save_compressed_file_path, save_uncompressed_file_path, include_directories = FALSE, mode = "cherry-pick")

min_date <- format(min(previous_month_data$APPT_DTTM), "%m/%d/%Y")
max_date <- format(max(previous_month_data$APPT_DTTM), "%m/%d/%Y")



