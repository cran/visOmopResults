## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
options(rmarkdown.html_vignette.check_title = FALSE)

## -----------------------------------------------------------------------------
library(visOmopResults)
library(dplyr, warn.conflicts = FALSE)

## -----------------------------------------------------------------------------
result1 <- mockSummarisedResult()
result2 <- mockSummarisedResult()

## -----------------------------------------------------------------------------
result2 <- result2 |>
  omopgenerics::newSummarisedResult(settings = tibble(
    result_id = 1L,
    result_type = "second_mock_result",
    package_name = "omopgenerics",
    package_version = "1.0.0",
    my_parameter = TRUE
  ))

## -----------------------------------------------------------------------------
result <- bind(result1, result2)
settings(result)
result

## -----------------------------------------------------------------------------
resultMyParam <- result |>
  addSettings(settingsColumns = "my_parameter") |>
  filter(my_parameter == TRUE) |>
  select(!"my_parameter")
resultMyParam

## -----------------------------------------------------------------------------
settings(resultMyParam)

## -----------------------------------------------------------------------------
resultMyParam <- result |>
  filterSettings(my_parameter == TRUE)
resultMyParam
settings(resultMyParam)

## -----------------------------------------------------------------------------
result |>
  select(strata_name, strata_level) |>
  distinct()

## -----------------------------------------------------------------------------
result |>
  splitStrata() |>
  filter(sex == "Female") |>
  uniteStrata(c("age_group", "sex"))

## -----------------------------------------------------------------------------
result |>
  filterStrata(sex == "Female")

## -----------------------------------------------------------------------------
result |>
  filterSettings(setting_that_does_not_exist == 1)

## -----------------------------------------------------------------------------
result |>
  splitStrata()

## -----------------------------------------------------------------------------
result |>
  splitStrata() |>
  uniteStrata(c("age_group", "sex"))

## ----echo = FALSE-------------------------------------------------------------
dplyr::tibble(
  age_group = c(NA, NA, "<40", ">40"),
  sex = c(NA, "Male", "Female", NA),
  year = c(NA, NA, 2010L, 2011L)
) |> 
  gt::gt()

## ----echo = FALSE-------------------------------------------------------------
dplyr::tibble(
  strata_name = c("overall", "sex", "age_group &&& sex &&& year", "age_group &&& year"),
  strata_level = c("overall", "Male", "<40 &&& Female &&& 2010", ">40 &&& 2011")
) |> 
  gt::gt()

## -----------------------------------------------------------------------------
settingsColumns(result)
groupColumns(result)
strataColumns(result)
additionalColumns(result)
tidyColumns(result)

