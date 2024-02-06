#' Creats a tibble with specific rows pivotted into columns
#'
#' @param result A summarised_result or compared_result.
#' @param header Names of the columns to make headers. Names not corresponding
#' to a column of the table result, will be used as headers at the defined
#' position.
#' @param delim Delimiter to use to separate headers.
#' @param includeHeaderName Wheather to include the column name as header.
#' @param includeHeaderKey Wheather to include the header key (header,
#' header_name, header_level) before each header type in the column names.
#'
#' @return A tibble with rows pivotted into columns with column names for future
#' spanner headers.
#'
#' @description
#' Pivots a summarised_result object based on the column names in header. The
#' names of the new columns refer to the information on the column based on
#' the header input, with labels are separated using a delimiter.
#'
#' @export
#'
#' @examples
#' \donttest{
#' result <- mockSummarisedResult()
#'
#' result |>
#'   formatTable(
#'     header = c(
#'       "Study cohorts", "group_level", "Study strata", "strata_name",
#'       "strata_level"
#'     ),
#'     includeHeaderName = FALSE
#'   )
#' }

formatTable <- function(result,
                        header,
                        delim = "\n",
                        includeHeaderName = TRUE,
                        includeHeaderKey = TRUE) {
  # initial checks
  result <- validateResult(result)
  checkmate::assertCharacter(x = header, any.missing = FALSE)
  checkmate::assertCharacter(delim, min.chars = 1, len = 1, any.missing = FALSE, max.len = 1)
  checkmate::assertLogical(includeHeaderName, any.missing = FALSE, len = 1)
  if (!rlang::is_character(delim)) {
    cli::cli_abort("The value supplied for `delim` must be of type `character`.")
  }
  if (length(delim) != 1) {
    cli::cli_abort("`delim` must be a single value.")
  }
  if (nchar(delim) != 1) {
    cli::cli_abort("The value supplied for `delim` must be a single character.")
  }

  # pivot wider
  cols <- header[header %in% colnames(result)]
  if (length(cols) > 0) {
    colDetails <- result |>
      dplyr::select(dplyr::all_of(cols)) |>
      dplyr::distinct() |>
      dplyr::mutate("name" = sprintf("column%03i", dplyr::row_number()))
    result <- result |>
      dplyr::inner_join(colDetails, by = cols) |>
      dplyr::select(-dplyr::all_of(cols)) |>
      tidyr::pivot_wider(names_from = "name", values_from = "estimate_value")
    columns <- colDetails$name

    # create column names
    colDetails <- colDetails |> dplyr::mutate(new_name = "")
    for (k in seq_along(header)) {
      if (header[k] %in% cols) {
        spanners <- colDetails[[header[k]]] |> unique()
        for (span in spanners) {
          colsSpanner <- colDetails$name[colDetails[[header[k]]] == span]
          if (includeHeaderKey) {
            if (includeHeaderName) {
              colDetails$new_name[colDetails[[header[k]]] == span] <- paste0(colDetails$new_name[colDetails[[header[k]]] == span], "[header_name]", header[k], delim, "[header_level]", span, delim)
            } else {
              colDetails$new_name[colDetails[[header[k]]] == span] <- paste0(colDetails$new_name[colDetails[[header[k]]] == span], "[header_level]", span, delim)
            }
          } else {
            if (includeHeaderName) {
              colDetails$new_name[colDetails[[header[k]]] == span] <- paste0(colDetails$new_name[colDetails[[header[k]]] == span], header[k], delim, span, delim)
            } else {
              colDetails$new_name[colDetails[[header[k]]] == span] <- paste0(colDetails$new_name[colDetails[[header[k]]] == span], span, delim)
            }
          }
        }
      } else {
        if (includeHeaderKey) {
          colDetails$new_name <- paste0(colDetails$new_name, "[header]", header[k], delim)
        } else {
          colDetails$new_name <- paste0(colDetails$new_name, header[k], delim)
        }
      }
    }
    colDetails <- colDetails |> dplyr::mutate(new_name = base::substring(.data$new_name, 0, nchar(.data$new_name)-1))

    # add column names
    names(result)[names(result) %in% colDetails$name] <- colDetails$new_name

  } else {
    if (includeHeaderKey & length(header)>0) {
      new_name <- paste0("[header]", paste(header, collapse = paste0(delim, "[header]")))
    } else if (!includeHeaderKey & length(header)>0) {
      new_name <- paste(header, collapse = delim)
    } else if (includeHeaderKey & length(header)==0) {
      new_name <- "[header]estimate_value"
    } else if (!includeHeaderKey & length(header)==0) {
      new_name <- "estimate_value"
    }
    result <- result |> dplyr::rename(!!new_name := "estimate_value")
    class(result) <- c("tbl_df", "tbl", "data.frame")
  }

  return(result)
}