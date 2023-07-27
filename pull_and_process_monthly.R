library(DBI)
library(odbc)
library(lubridate)
library(glue)
library(readr)

dsn <- "OAO Cloud DB"

conn <- dbConnect(odbc(), dsn)

todays_date <- Sys.Date()
last_month <- todays_date %m-% months(1)
month_year <- format(last_month, '%Y-%m')

sql_statement <- glue("SELECT * FROM ONCOLOGY_ACCESS WHERE APPT_MONTH_YEAR = '{month_year}'")
previous_month_data <- dbGetQuery(conn, sql_statement)

save_file_path <- paste0("/SharedDrive/deans/Presidents/HSPI-PM/Operations Analytics and Optimization/Projects/Service Lines/Oncology/Monthly Oncology Email/Oncology_Data_",
                         month_year, ".csv")

write_csv(previous_month_data, save_file_path)

