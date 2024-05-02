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
mockSummarisedResult() |>
  addSettings() |>
  glimpse()

## -----------------------------------------------------------------------------
result <- mockSummarisedResult()

result |> 
  tidy() |> 
  glimpse()

