## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  warning = FALSE,
  message = FALSE
)
options(rmarkdown.html_vignette.check_title = FALSE)

## ----echo = FALSE-------------------------------------------------------------
dplyr::tibble(
  group_name = c("cohort_name", c("cohort_name &&& sex"), c("sex &&& age_group")),
  group_level = c("acetaminophen", c("acetaminophen &&& Female"), c("Male &&& <40"))
) |>
  gt::gt()

## ----echo = FALSE-------------------------------------------------------------
dplyr::tibble(
  group_name = c("cohort_name", c("cohort_name &&& sex"), c("sex &&& age_group")),
  group_level = c("acetaminophen", c("acetaminophen &&& Female"), c("Male &&& <40"))
) |>
  visOmopResults::splitGroup() |>
  gt::gt()

## ----echo = FALSE-------------------------------------------------------------
dplyr::tibble(
  result_id = c(1L, 2L),
  my_setting = c(TRUE, FALSE),
  package_name = "visOmopResults"
) |>
  gt::gt()

## ----echo = FALSE-------------------------------------------------------------
dplyr::tibble(
  result_id = c("1", "...", "2", "..."),
  cdm_name = c("omop", "...", "omop", "..."),
  " " = c("..."),
  additional_name = c("overall", "...", "overall", "...")
) |>
  gt::gt()

## ----echo = FALSE-------------------------------------------------------------
dplyr::tibble(
  cdm_name = c("omop", "...", "omop", "..."),
  " " = c("..."),
  additional_name = c("overall", "...", "overall", "..."),
  my_setting = c("TRUE", "...", "FALSE", "..."),
  package_name = c("visOmopResults", "...", "visOmopResults", "...")
) |>
  gt::gt()

## ----echo = FALSE-------------------------------------------------------------
dplyr::tibble(
  variable_name = c("number individuals", "age", "age"),
  estimate_name = c("count", "mean", "sd"),
  estimate_type = c("integer", "numeric", "numeric"),
  estimate_value = c("100", "50.3", "20.7")
) |>
  gt::gt()

## ----echo = FALSE-------------------------------------------------------------
dplyr::tibble(
  variable_name = c("number individuals", "age"),
  count = c(100L, NA),
  mean = c(NA, 50.3),
  sd = c(NA, 20.7)
) |>
  gt::gt()

## -----------------------------------------------------------------------------
library(visOmopResults)
result <- mockSummarisedResult()
result |>
  tidy()

## -----------------------------------------------------------------------------
splitAll(result)

## -----------------------------------------------------------------------------
pivotEstimates(
  result, 
  pivotEstimatesBy = c("variable_name","variable_level", "estimate_name")
)

## -----------------------------------------------------------------------------
addSettings(
  result, 
  settingsColumns = "result_type"
)

