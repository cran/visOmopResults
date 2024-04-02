## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  warning = FALSE,
  message = FALSE
)

## -----------------------------------------------------------------------------
library(visOmopResults)
library(dplyr)
result <- mockSummarisedResult()
result |> glimpse()

## -----------------------------------------------------------------------------
result |> 
  pivotEstimates(pivotEstimatesBy = c("variable_name", "variable_level", "estimate_name")) |>
  glimpse()

## -----------------------------------------------------------------------------
result |> 
  pivotEstimates(pivotEstimatesBy = "estimate_name",
                 nameStyle = "{toupper(estimate_name)}") |>
  glimpse()

## -----------------------------------------------------------------------------
mockSummarisedResult(settings = TRUE) |>
  pivotSettings() |>
  glimpse()

## -----------------------------------------------------------------------------
table <- mockSummarisedResult() |>
  mutate(mockSummarisedResult = TRUE, vignette = "tidy")

result <- table |> appendSettings(colsSettings = c("mockSummarisedResult", "vignette"))

result |> filter(variable_name == "settings") |> glimpse()

## -----------------------------------------------------------------------------
result <- mockSummarisedResult(settings = TRUE)

result |> 
  tidy() |> 
  glimpse()

