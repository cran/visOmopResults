## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  warning = FALSE,
  message = FALSE
)

options(rmarkdown.html_vignette.check_title = FALSE)

## -----------------------------------------------------------------------------
# Set-up
library(visOmopResults)
library(dplyr)

# Create a mock summarized result
result <- mockSummarisedResult()
head(result)

# Get strata columns
strataColumns(result)

## -----------------------------------------------------------------------------
# Display settings tibble
settings(result)

# Get which settings are present using `settingsColumns()`
settingsColumns(result)

## -----------------------------------------------------------------------------
# Show tidy result:
tidy(result) |> head()

# Get the tidy columns with `tidyColumns()`
tidyColumns(result)

## -----------------------------------------------------------------------------
result <- result |>
  filter(variable_name == "number subjects")

barPlot(
  result = result, 
  x = groupColumns(result), 
  y = "count", 
  facet = strataColumns(result), 
  colour = groupColumns(result)
)

## -----------------------------------------------------------------------------
# Create and show mock data
data <- tibble(
  denominator_cohort_name = c("general_population", "older_than_60", "younger_than_60"),
  outcome_cohort_name = c("stroke", "stroke", "stroke")
)
head(data)

# Unite into group name-level columns
data |>
  uniteGroup(cols = c("denominator_cohort_name", "outcome_cohort_name"))

