Sending emails from R
================

# Overview

There are many use cases for sending emails from R. It’s especially
useful when you’re scheduling a script, as it allows you to receive an
email confirmation that the script ran and to receive a summary of what
the script did, ie. how many records were processed, important values,
etc.

There are likely many ways to send emails from R, but we typically use
two packages [`sendmailR`](https://github.com/olafmersmann/sendmailR)
and [`blastula`](https://github.com/rstudio/blastula). `sendmailR` is
great for plain text emails and `blastula` is good for rich text emails.

This overview will provide basic examples for how to use these packages.
Additionaly information is available at the links above and on the
internet.

# `sendmailR`

## Basic usage

`sendmailR` is a great package for sending plain text emails. The basic
function is called `sendmail()`. Here is how you would send a basic
email with `sendmail()`:

``` r
library(sendmailR)

sendmail(from = sprintf("email@email.com"),
         to = sprintf(c("email1@email.com", "email2@email.com")),
         subject = "string for subject",
         body = "string of body text", 
         control = list(smtpServer = "server")) # you'll need to figure out what this is for your email set-up
```

## Additional options

You can also add emails to be CC’ed or BCC’ed and you can add
attachments to your emails. This code includes those options:

``` r
library(sendmailR)

sendmail(from = sprintf("email@email.com"),
         to = sprintf(c("email1@email.com", "email2@email.com")),
         cc = sprintf("email3@email.com"),
         bcc = sprintf("email4@email.com"),
         subject = "string for subject",
         body = list("body text goes here",
                     mime_part(x = "file_path_of_the_file_you_want_to_attach",
                               name = "Name of the attachment in the email")), 
         control = list(smtpServer = "server")) # you'll need to figure out what this is for your email set-up
```

# `blastula`

## Basic usage

`blastula()` sends rich text emails and therefore provides more
formatting options for you when sending emails from R. This is an
example of how to send a basic email using blastula:

``` r
library(blastula)
library(kableExtra)
library(tidyverse)

# write your email ----
email <- compose_email(
    body = md(glue::glue(
      "Text goes here"
    )
  )
)

## send your email ----
smtp_send(
    email = email,
    from = "email@email.com",
    to = c("email1@email.com", "email2@email.com"),
    subject = "blastula test email",
    
    credentials = creds_anonymous(host = "host", # you'll need to figure out what this is for your email set-up
                                  port = 25))
```

## Additional options

Like `sendmail()` from `sendmailR`, you can CC, BCC and attach documents
with blastula. You can also include rich text elements in your email
body including tables, bolded text and more.

``` r
library(blastula)
library(kableExtra)
library(tidyverse)


 table <- data.frame(
   "Numbers" = 1:3,
   "Colors" = c("blue", "orange", "green")
 ) %>%
    kbl(format = "html")
  
email <- compose_email(
    body = md(glue::glue(
      "This email contains a **table**:
    
{table}

"))
  )
  
## send your email ----
email %>%
  add_attachment(file = "file-path",
                 filename = "File display name") %>%
  smtp_send(
    from = "email@email.com",
    to = c("email1@email.com", "email2@email.com"),
    cc = c("email3@email.com"),
    bcc = c("email4@email.com"),
    subject = "blastula test email",
    
    credentials = creds_anonymous(host = "host", # you'll need to figure out what this is for your email set-up
                                  port = 25))
```
