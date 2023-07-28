compose_email(header = sinai_logo,
              body = render_connect_email("Scripts/email_body.Rmd")$html_html,
              footer = "This is an auto generated email") %>%
  add_attachment(
    file = save_compressed_file_path,
    filename = paste0("Oncology Data ", "month_year", ".zip")
  ) %>%
  smtp_send(
    from = "armando.villegas@mssm.edu",
    to = send_list,
    credentials = creds_file(file = email_credential_location),
    subject = email_subject
  )