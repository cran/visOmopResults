## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  warning = FALSE,
  message = FALSE
)

## ----setup--------------------------------------------------------------------
library(visOmopResults)
library(dplyr)
mock_sr <- mockSummarisedResult()
mock_sr |> glimpse()

## -----------------------------------------------------------------------------
mock_sr <- mock_sr |> formatEstimateValue()
mock_sr |> glimpse()

## -----------------------------------------------------------------------------
mock_sr <- mock_sr |> 
  formatEstimateName(
    estimateNameFormat = c(
      "N (%)" = "<count> (<percentage>%)", 
      "N" = "<count>",
      "Mean (SD)" = "<mean> (<sd>)"
    ),
    keepNotFormatted = FALSE,
    useFormatOrder = FALSE
  )
mock_sr |> glimpse()

## -----------------------------------------------------------------------------
mock_sr |>
  formatHeader(
    header = c("Names of the cohorts", "group_level"),
    delim = "\n",
    includeHeaderName = TRUE,
    includeHeaderKey = TRUE
  ) |>
  glimpse()

## -----------------------------------------------------------------------------
mock_sr <- mock_sr |>
  mutate(across(c("strata_name", "strata_level"), ~ gsub("&&&", "and", .x))) |>
  formatHeader(
    header = c("Stratifications", "strata_name", "strata_level"),
    delim = "\n",
    includeHeaderName = FALSE,
    includeHeaderKey = TRUE
  ) 

mock_sr |> glimpse()

## -----------------------------------------------------------------------------
# first we select the columns we want:
mock_sr <- mock_sr |>
  splitGroup() |>
  select(!all_of(c("cdm_name", "result_type", "package_name", 
                                 "package_version", "estimate_type", "result_id",
                                 "additional_name", "additional_level"))) 
mock_sr |>  gtTable()

## -----------------------------------------------------------------------------
mock_sr |>  
  gtTable(
    groupNameCol = "cohort_name",
    groupNameAsColumn = FALSE,
    groupOrder = c("cohort1", "cohort2"),
    colsToMergeRows = "all_columns"
  )

## -----------------------------------------------------------------------------
mock_sr |>  
  gtTable(
    style = list(
      "header" = list(gt::cell_text(weight = "bold"), 
                      gt::cell_fill(color = "orange")),
      "header_level" = list(gt::cell_text(weight = "bold"), 
                      gt::cell_fill(color = "yellow")),
      "column_name" = gt::cell_text(weight = "bold"),
      "group_label" = list(gt::cell_fill(color = "blue"),
                           gt::cell_text(color = "white", weight = "bold")),
      "body" = gt::cell_text(color = "red")
    ),
    groupNameCol = "cohort_name",
    groupNameAsColumn = FALSE,
    groupOrder = c("cohort1", "cohort2"),
    colsToMergeRows = "all_columns"
  )

## -----------------------------------------------------------------------------
mock_sr |>  
  fxTable(
    style = list(
      "header" = list(
        "cell" = officer::fp_cell(background.color = "orange"),
        "text" = officer::fp_text(bold = TRUE)),
      "header_level" = list(
        "cell" = officer::fp_cell(background.color = "yellow"),
        "text" = officer::fp_text(bold = TRUE)),
      "column_name" = list("text" = officer::fp_text(bold = TRUE)),
      "group_label" = list(
        "cell" = officer::fp_cell(background.color = "blue"),
        "text" = officer::fp_text(bold = TRUE, color = "white")),
      "body" = list("text" = officer::fp_text(color = "red"))
    ),
    groupNameCol = "cohort_name",
    groupNameAsColumn = FALSE,
    groupOrder = c("cohort1", "cohort2"),
    colsToMergeRows = "all_columns"
  )

