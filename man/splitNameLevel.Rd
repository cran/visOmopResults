% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/split.R
\name{splitNameLevel}
\alias{splitNameLevel}
\title{Split name and level columns into the columns}
\usage{
splitNameLevel(
  result,
  name = "group_name",
  level = "group_level",
  keep = FALSE,
  fill = "overall",
  overall = lifecycle::deprecated()
)
}
\arguments{
\item{result}{A summarised_result object.}

\item{name}{Column with the names.}

\item{level}{Column with the levels.}

\item{keep}{Whether to keep the original group_name and group_level columns.}

\item{fill}{Optionally, a character that specifies what value should be
filled in with when missing.}

\item{overall}{deprecated.}
}
\value{
A dataframe with the specified name column values as columns.
}
\description{
Pivots the input dataframe so the values of the name columns are transformed
into columns, which values come from the specified level column.
}
\examples{
mockSummarisedResult() |>
  splitNameLevel(name = "group_name",
                 level = "group_level",
                 keep = FALSE)

}
