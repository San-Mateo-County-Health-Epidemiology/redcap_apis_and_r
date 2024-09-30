
<!-- README.md is generated from README.Rmd. Please edit that file -->

# REDCap APIs and R

This repo contains
[slides](https://elizabethjump.github.io/redcap_apis_and_r/#/title-slide)
and resources to explain our workflow of managing daily ED Census data
in REDCap. While the data are stored in REDCap, the data processing,
importing and visualizing is done from R.

A general outline of the workflow is in the slides and an outline of the
code is
[here](https://github.com/elizabethjump/redcap_apis_and_r/blob/main/resources/workflow-outline.R).

------------------------------------------------------------------------

## Additional Resources:

- [Windows Task
  Scheduler](https://github.com/elizabethjump/redcap_apis_and_r/blob/main/resources/r-scripts-on-windows-task-scheduler.md)
- [Sending emails from
  R](https://github.com/elizabethjump/redcap_apis_and_r/blob/main/resources/sending-emails-from-r.md)

------------------------------------------------------------------------

## R Markdown and Quarto

**R Markdown**

- [R Markdown Cookbook](https://bookdown.org/yihui/rmarkdown-cookbook/)
- [R Markdown Cheat Sheet](https://rmarkdown.rstudio.com/lesson-15.html)

**Quarto**

- [Quarto
  Introduction](https://quarto.org/docs/get-started/hello/rstudio.html)
- [Quarto chapter, R for Data Science](https://r4ds.hadley.nz/quarto)

------------------------------------------------------------------------

## Application Programming Interfaces (API)

**General knowlege**

- [Overview of APIs](https://www.postman.com/what-is-an-api/)
- [APIs and R](https://www.dataquest.io/blog/r-api-tutorial/)

**R packages for using APIs with REDCap**

- [httr](https://httr.r-lib.org/): this is what is used in the API
  playground in REDCap
- [redcapAPI](https://github.com/vubiostat/redcapAPI): this is what we
  typically use
- [REDCapR](https://ouhscbbmc.github.io/REDCapR/): we’ve used this in
  the past when we couldn’t get what we needed from REDCapAPI
