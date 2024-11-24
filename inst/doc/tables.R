## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  warning = FALSE,
  message = FALSE
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
             "Flipper length (mm)" = "flipper_length_mm",
             "Body mass (g)" = "body_mass_g"),
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
    "Bill length (mm)" = "<bill_length_mm>",
    "Bill depth (mm)" = "<bill_depth_mm>",
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
    header = c("My visOmopTable", "group"),
    groupColumn = c("strata"),
    hide = c("cdm_name"),
    showMinCellCount = TRUE,
    type = "gt"
  )

## ----echo=FALSE---------------------------------------------------------------
bind_rows(
  tibble(
    Function = "formatEstimateValue()",
    Argument = c("decimals", "decimalMark", "bigMark"),
    Description = c(
      "Number of decimals per estimate type (integer, numeric, percentage, proportion), estimate name, or all estimate values (introduce the number of decimals).",
      "Decimal separator mark.",
      "Thousand and millions separator mark."
    )
  ) ,
  tibble(
    Function = "formatEstimateName()",
    Argument = c("keepNotFormatted", "useFormatOrder"),
    Description = c(
      "Whether to keep rows not formatted.",
      "Whether to use the order in which estimate names appear in the estimateName (TRUE), or use the order in the input dataframe (FALSE)."
    )
  ),
  tibble(
    Function = "formatHeader()",
    Argument = c("delim", "includeHeaderName", "includeHeaderKey"),
    Description = c(
      "Delimiter to use to separate headers.",
      "Whether to include the column name as header.",
      "Whether to include the header key (header, header_name, header_level) before each header type in the column names."
    )
  ),
  tibble(
    Function = "formatTable()",
    Argument = c("style", "na", "title", "subtitle", "caption", "groupAsColumn", "groupOrder", "merge"),
    Description = c(
      "Named list that specifies how to style the different parts of the gt or flextable table generated. Accepted style entries are: title, subtitle, header, header_name, header_level, column_name, group_label, and body. Alternatively, use 'default' to get visOmopResults style, or NULL for gt/flextable style. Keep in mind that styling code is different for gt and flextable. To see the 'deafult' gt style code use gtStyle(), and flextableStyle() for flextable default code style",
      "How to display missing values.",
      "Title of the table, or NULL for no title.",
      "Subtitle of the table, or NULL for no subtitle.",
      "Caption for the table, or NULL for no caption. Text in markdown formatting style (e.g. ⁠*Your caption here*⁠ for caption in italics)",
      "Whether to display the group labels as a column (TRUE) or rows (FALSE).",
      "Order in which to display group labels.",
      "Names of the columns to merge vertically when consecutive row cells have identical values. Alternatively, use 'all_columns' to apply this merging to all columns, or use NULL to indicate no merging."
    )
  )  
) |>
  formatTable(groupColumn = "Function")


## -----------------------------------------------------------------------------
tableOptions()

## -----------------------------------------------------------------------------
tableStyle(type = "gt")

tableStyle(type = "flextable")

## -----------------------------------------------------------------------------
result |> 
  filterGroup(cohort_name == "cohort1") |>  # visOmopResult filter function
  filterStrata(age_group == "<40", sex == "Female") |>  # visOmopResult filter function
  select(variable_name, variable_level, estimate_name, estimate_type, estimate_value)

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

