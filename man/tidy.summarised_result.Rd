% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tidy.R
\name{tidy.summarised_result}
\alias{tidy.summarised_result}
\title{Turn a \verb{<summarised_result>} object into a tidy tibble}
\usage{
\method{tidy}{summarised_result}(x, ...)
}
\arguments{
\item{x}{A \verb{<summarised_result>}.}

\item{...}{For compatibility (not used).}
}
\value{
A tibble.
}
\description{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#experimental}{\figure{lifecycle-experimental.svg}{options: alt='[Experimental]'}}}{\strong{[Experimental]}}
Provides tools for obtaining a tidy version of a \verb{<summarised_result>} object.
This tidy version will include the settings as columns, \code{estimate_value} will
be pivotted into columns using \code{estimate_name} as names, and group, strata,
and additional will be splitted.
If you want to customise these tidy operations, please use
\code{tidySummarisedResult()}.
}
\examples{
result <- mockSummarisedResult()
result |> tidy()
}
