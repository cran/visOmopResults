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
mock_sr |> splitGroup() |> glimpse()

## -----------------------------------------------------------------------------
mock_sr |> splitStrata() |> glimpse()
mock_sr |> splitAdditional() |> glimpse()
mock_sr |> splitAll() |> glimpse()

## -----------------------------------------------------------------------------
data_to_split <- tibble(
  denominator = "general_population",
  outcome = "stroke",
  input_arguments = c("wash_out &&& previous_observation"),
  input_arguments_values = c("60 &&& 180")
)
data_to_split 

## -----------------------------------------------------------------------------
data_to_split |>
  splitNameLevel(
    name = "input_arguments",
    level = "input_arguments_values"
  )

## -----------------------------------------------------------------------------
to_unite_group <- tibble(
  denominator_cohort_name = c("general_population", "older_than_60", "younger_than_60"),
  outcome_cohort_name = c("stroke", "stroke", "stroke")
)

to_unite_group |>
  uniteGroup(cols = c("denominator_cohort_name", "outcome_cohort_name"))

## -----------------------------------------------------------------------------
to_unite_strata <- tibble(
    age = c(NA, ">40", "<=40", NA, NA, NA, NA, NA, ">40", "<=40"),
    sex = c(NA, NA, NA, "F", "M", NA, NA, NA, "F", "M"),
    region = c(NA, NA, NA, NA, NA, "North", "South", "Center", NA, NA)
  )

to_unite_strata |>
  uniteStrata(cols = c("age", "sex", "region"),
              ignore = character())

## -----------------------------------------------------------------------------
to_unite_strata |>
  uniteStrata(cols = c("age", "sex", "region"))

## -----------------------------------------------------------------------------
to_unite_strata |>
  uniteNameLevel(cols = c("age", "sex", "region"),
                 name = "name",
                 level = "level",
                 keep = TRUE)

