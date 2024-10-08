#' Additional table formatting options for `visOmopTable()` and `visTable()`
#'
#' @description
#' This function provides a list of allowed inputs for the `.option` argument in
#' `visOmopTable()` and `visTable()`, and their corresponding default values.
#'
#' @return A named list of default options for table customization.
#'
#' @export
#'
#' @examples
#' tableOptions()
#'
tableOptions <- function() {
  return(defaultTableOptions(NULL))
}


#' Additional table formatting options
#'
#'  `r lifecycle::badge("deprecated")`
#'
#' @return list of options
#' @export
#'
optionsVisOmopTable <- function() {
  lifecycle::deprecate_soft("0.4.0", "optionsVisOmopTable()", "tableOptions()")
  tableOptions()
}

#' Supported predefined styles for formatted tables
#'
#' @param type Character string specifying the formatted table class.
#' See `tableType()` for supported classes. Default is "gt".
#' @param styleName A character string specifying the style name. Currently, the
#' package supports only one predefined style: "default".
#'
#' @return A code expression for the selected style and table type.
#'
#' @export
#'
#' @examples
#' tableStyle("gt")
#' tableStyle("flextable")
#'
tableStyle <- function(type = "gt", styleName = "default") {
  if (type == "gt") {
    list(
      "header" = list(gt::cell_fill(color = "#c8c8c8"),
                      gt::cell_text(weight = "bold", align = "center")),
      "header_name" = list(gt::cell_fill(color = "#d9d9d9"),
                           gt::cell_text(weight = "bold", align = "center")),
      "header_level" = list(gt::cell_fill(color = "#e1e1e1"),
                            gt::cell_text(weight = "bold", align = "center")),
      "column_name" = list(gt::cell_text(weight = "bold", align = "center")),
      "group_label" = list(gt::cell_fill(color = "#e9e9e9"),
                           gt::cell_text(weight = "bold")),
      "title" = list(gt::cell_text(weight = "bold", size = 15, align = "center")),
      "subtitle" = list(gt::cell_text(weight = "bold", size = 12, align = "center")),
      "body" = list()
    ) |>
      rlang::expr()
  } else if (type == "flextable") {
    list(
      "header" = list(
        "cell" = officer::fp_cell(background.color = "#c8c8c8"),
        "text" = officer::fp_text(bold = TRUE)
      ),
      "header_name" = list(
        "cell" = officer::fp_cell(background.color = "#d9d9d9"),
        "text" = officer::fp_text(bold = TRUE)
      ),
      "header_level" = list(
        "cell" = officer::fp_cell(background.color = "#e1e1e1"),
        "text" = officer::fp_text(bold = TRUE)
      ),
      "column_name" = list(
        "text" = officer::fp_text(bold = TRUE)
      ),
      "group_label" = list(
        "cell" = officer::fp_cell(
          background.color = "#e9e9e9",
          border = officer::fp_border(color = "gray")
        ),
        "text" = officer::fp_text(bold = TRUE)
      ),
      "title" = list(
        "text" = officer::fp_text(bold = TRUE, font.size = 15)
      ),
      "subtitle" = list(
        "text" = officer::fp_text(bold = TRUE, font.size = 12)
      ),
      "body" = list()
    ) |>
      rlang::expr()
  }
}


#' Supported table classes
#'
#' @description
#' This function returns the supported table classes that can be used in the
#' `type` argument of `visOmopTable()`, `visTable()`, and `formatTable()`
#' functions.
#'
#' @return A character vector of supported table types.
#'
#' @export
#'
#' @examples
#' tableType()
#'
tableType <- function() {
  c("gt", "flextable", "tibble")
}

