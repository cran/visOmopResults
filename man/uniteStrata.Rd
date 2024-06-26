% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/unite.R
\name{uniteStrata}
\alias{uniteStrata}
\title{Unite one or more columns in strata_name-strata_level format}
\usage{
uniteStrata(x, cols = character(0), keep = FALSE, ignore = c(NA, "overall"))
}
\arguments{
\item{x}{Tibble or dataframe.}

\item{cols}{Columns to aggregate.}

\item{keep}{Whether to keep the original columns.}

\item{ignore}{Level values to ignore.}
}
\value{
A tibble with the new columns.
}
\description{
Unites targeted table columns into strata_name-strata_level columns.
}
\examples{
x <- dplyr::tibble(
  variable = "number subjects",
  value = c(10, 15, 40, 78),
  sex = c("Male", "Female", "Male", "Female"),
  age_group = c("<40", ">40", ">40", "<40")
)

x |>
  uniteStrata(c("sex", "age_group"))

}
