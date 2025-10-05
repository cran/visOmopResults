## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  warning = FALSE,
  message = FALSE,
  fig.width=7.2, 
  fig.height=5
)
options(rmarkdown.html_vignette.check_title = FALSE)

## -----------------------------------------------------------------------------
library(visOmopResults)
library(palmerpenguins)
library(dplyr)
library(tidyr)
x <- penguins |> 
  filter(!is.na(sex) & year == 2008) |> 
  select(!"body_mass_g") |>
  summarise(across(ends_with("mm"), ~mean(.x)), .by = c("species", "island", "sex"))
head(x)

## -----------------------------------------------------------------------------
visTable(
  result = x,
  groupColumn = c("sex"),
  rename = c("Bill length (mm)" = "bill_length_mm",
             "Bill depth (mm)" = "bill_depth_mm",
             "Flipper length (mm)" = "flipper_length_mm"),
  type = "gt",
  hide = "year"
)

## -----------------------------------------------------------------------------
# Transforming the dataset to include estimate columns
x <- x |>
  pivot_longer(
    cols = ends_with("_mm"), 
    names_to = "estimate_name", 
    values_to = "estimate_value"
  ) |>
  mutate(estimate_type = "numeric")

# Creating a formatted flextable
visTable(
  result = x,
  estimateName = c(
    "Bill length - Bill depth (mm)" = "<bill_length_mm> - <bill_depth_mm>",
    "Flipper length (mm)" = "<flipper_length_mm>"
  ),
  header = c("species", "island"),
  groupColumn = "sex",
  type = "flextable",
  hide = c("year", "estimate_type")
)


## -----------------------------------------------------------------------------
# Creating a mock summarised result
result <- mockSummarisedResult() |>
  filter(strata_name == "age_group &&& sex")

# Displaying the first few rows
head(result)

# Creating a formatted gt table
visOmopTable(
  result = result,
  estimateName = c(
    "N%" = "<count> (<percentage>)",
    "N" = "<count>",
    "Mean (SD)" = "<mean> (<sd>)"
  ),
  header = c("package_name", "age_group"),
  groupColumn = c("cohort_name", "sex"),
  settingsColumn = "package_name",
  type = "gt"
)

## -----------------------------------------------------------------------------
result |>
  suppress(minCellCount = 1000000) |>
  visOmopTable(
    estimateName = c(
      "N%" = "<count> (<percentage>)",
      "N" = "<count>",
      "Mean (SD)" = "<mean> (<sd>)"
    ),
    header = c("group"),
    groupColumn = c("strata"),
    hide = c("cdm_name"),
    showMinCellCount = TRUE,
    type = "reactable"
  )

## -----------------------------------------------------------------------------
tableStyleCode(type = "gt", style = "default")

## -----------------------------------------------------------------------------
tableOptions()

## ----echo=FALSE---------------------------------------------------------------
bind_rows(
  tibble(
    Function = "formatEstimateValue()",
    Argument = c("decimals", "decimalMark", "bigMark"),
    Description = c(
      "Number of decimals to display, which can be specified per estimate type (integer, numeric, percentage, proportion), per estimate name, or applied to all estimates.",
      "Symbol to use as the decimal separator.",
      "Symbol to use as the thousands and millions separator."
    )
  ),
  tibble(
    Function = "formatEstimateName()",
    Argument = c("keepNotFormatted", "useFormatOrder"),
    Description = c(
      "Whether to retain rows with estimate names that are not explicitly formatted.",
      "Whether to display estimate names in the order provided in `estimateName` (TRUE) or in the order of the input data frame (FALSE)."
    )
  ),
  tibble(
    Function = "formatHeader()",
    Argument = c("delim", "includeHeaderName", "includeHeaderKey"),
    Description = c(
      "Delimiter to use when separating header components.",
      "Whether to include the column name as part of the header.",
      "Whether to prefix header elements with their type (e.g., header, header_name, header_level)."
    )
  ),
  tibble(
    Function = "formatTable()",
    Argument = c("style", "na", "title", "subtitle", "caption", "groupAsColumn", "groupOrder", "merge"),
    Description = c(
      "Named list specifying styles for table components (e.g., title, subtitle, header, body). Use `'default'` for the default `visOmopResults` style or `NULL` for the package default (either `gt` or `flextable`). Use `tableStyleCode()` to preview the pre-defined styles.",
      "Value to display for missing data.",
      "Title of the table. Use `NULL` for no title.",
      "Subtitle of the table. Use `NULL` for no subtitle.",
      "Caption in markdown format. Use `NULL` for no caption. For example, *Your caption here* renders in italics.",
      "Whether to display group labels as a separate column (`TRUE`) or as row headers (`FALSE`).",
      "Order in which to display group labels.",
      "Columns to merge vertically when consecutive cells have the same value. Use `'all_columns'` to merge all, or `NULL` for no merging."
    )
  )
) |>
  formatTable(groupColumn = "Function")

## -----------------------------------------------------------------------------
result |> 
  filterGroup(cohort_name == "cohort1") |>  # visOmopResult filter function
  filterStrata(age_group == "<40", sex == "Female") |>  # visOmopResult filter function
  select(variable_name, variable_level, estimate_name, estimate_type, estimate_value)

## -----------------------------------------------------------------------------
result <- result |> formatMinCellCount()

## -----------------------------------------------------------------------------
# Formatting estimate values
result <- result |>
  formatEstimateValue(
    decimals = c(integer = 0, numeric = 4, percentage = 2),
    decimalMark = ".",
    bigMark = ","
  )

# Displaying the formatted subset
result |> 
  filterGroup(cohort_name == "cohort1") |>  
  filterStrata(age_group == "<40", sex == "Female") |> 
  select(variable_name, variable_level, estimate_name, estimate_type, estimate_value)

## -----------------------------------------------------------------------------
# Formatting estimate names
result <- result |> 
  formatEstimateName(
    estimateName = c(
      "N (%)" = "<count> (<percentage>%)", 
      "N" = "<count>",
      "Mean (SD)" = "<mean> (<sd>)"
    ),
    keepNotFormatted = TRUE,
    useFormatOrder = FALSE
  )

# Displaying the formatted subset with new estimate names
result |> 
  filterGroup(cohort_name == "cohort1") |>  
  filterStrata(age_group == "<40", sex == "Female") |> 
  select(variable_name, variable_level, estimate_name, estimate_type, estimate_value)

## -----------------------------------------------------------------------------
result |>
  mutate(across(c("strata_name", "strata_level"), ~ gsub("&&&", "and", .x))) |>
  formatHeader(
    header = c("Stratifications", "strata_name", "strata_level"),
    delim = "\n",
    includeHeaderName = TRUE,
    includeHeaderKey = TRUE
  ) |> 
  colnames()

## -----------------------------------------------------------------------------
result <- result |>
  mutate(across(c("strata_name", "strata_level"), ~ gsub("&&&", "and", .x))) |>
  formatHeader(
    header = c("Stratifications", "strata_name", "strata_level"),
    delim = "\n",
    includeHeaderName = FALSE,
    includeHeaderKey = TRUE
  )  

colnames(result)

## -----------------------------------------------------------------------------
result <- result |>
  splitGroup() |>
  splitAdditional() |>
  select(!c("result_id", "estimate_type", "cdm_name"))
head(result)

## -----------------------------------------------------------------------------
result |>
  formatTable(
    type = "gt",
    delim = "\n",
    style = "default",
    na = "-",
    title = "My formatted table!",
    subtitle = "Created with the `visOmopResults` R package.",
    caption = NULL,
    groupColumn = "cohort_name",
    groupAsColumn = FALSE,
    groupOrder = c("cohort2", "cohort1"),
    merge = "variable_name"
  )

## -----------------------------------------------------------------------------
result |>
  formatTable(
    type = "gt",
    delim = "\n",
    style = list(
      "header" = list(gt::cell_text(weight = "bold"), 
                      gt::cell_fill(color = "orange")),
      "header_level" = list(gt::cell_text(weight = "bold"), 
                      gt::cell_fill(color = "yellow")),
      "column_name" = gt::cell_text(weight = "bold"),
      "group_label" = list(gt::cell_fill(color = "blue"),
                           gt::cell_text(color = "white", weight = "bold")),
      "title" = list(gt::cell_text(size = 20, weight = "bold")),
      "subtitle" = list(gt::cell_text(size = 15)),
      "body" = gt::cell_text(color = "red")
    ),
    na = "-",
    title = "My formatted table!",
    subtitle = "Created with the `visOmopResults` R package.",
    caption = NULL,
    groupColumn = "cohort_name",
    groupAsColumn = FALSE,
    groupOrder = c("cohort2", "cohort1"),
    merge = "variable_name"
  )

## -----------------------------------------------------------------------------
result |>
  formatTable(
    type = "flextable",
    delim = "\n",
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
      "title" = list("text" = officer::fp_text(bold = TRUE, font.size = 20)),
      "subtitle" = list("text" = officer::fp_text(font.size = 15)),
      "body" = list("text" = officer::fp_text(color = "red"))
    ),
    na = "-",
    title = "My formatted table!",
    subtitle = "Created with the `visOmopResults` R package.",
    caption = NULL,
    groupColumn = "cohort_name",
    groupAsColumn = FALSE,
    groupOrder = c("cohort2", "cohort1"),
    merge = "variable_name"
  )

