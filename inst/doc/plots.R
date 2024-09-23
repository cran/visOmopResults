## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  warning = FALSE,
  fig.width=7, 
  fig.height=5
)
options(rmarkdown.html_vignette.check_title = FALSE)

## ----setup--------------------------------------------------------------------
library(visOmopResults)

## -----------------------------------------------------------------------------
library(PatientProfiles)
library(palmerpenguins)
library(dplyr)

summariseIsland <- function(island) {
  penguins |>
    filter(.data$island == .env$island) |>
    summariseResult(
      group = "species",
      includeOverallGroup = TRUE,
      strata = list("year", "sex", c("year", "sex")),
      variables = c(
        "bill_length_mm", "bill_depth_mm", "flipper_length_mm", "body_mass_g", 
        "sex"),
      estimates = c(
        "median", "q25", "q75", "min", "max", "count_missing", "count", 
        "percentage", "density")
    ) |>
    suppressMessages() |>
    mutate(cdm_name = island)
}

penguinsSummary <- bind(
  summariseIsland("Torgersen"), 
  summariseIsland("Biscoe"), 
  summariseIsland("Dream")
)

## -----------------------------------------------------------------------------
tidyColumns(penguinsSummary)

## -----------------------------------------------------------------------------
colnames(penguinsSummary)

## -----------------------------------------------------------------------------
penguinsSummary |>
  filter(variable_name == "bill_depth_mm") |>
  filterStrata(year != "overall", sex == "overall") |>
  scatterPlot(
    x = "year", 
    y = "median",
    line = TRUE, 
    point = TRUE,
    ribbon = FALSE,
    facet = "cdm_name",
    colour = "species"
  )

## -----------------------------------------------------------------------------
penguinsSummary |>
  filter(variable_name %in% c("bill_length_mm", "bill_depth_mm"))|>
  filterStrata(year == "overall", sex == "overall") |>
  filterGroup(species != "overall") |>
  scatterPlot(
    x = "density_x", 
    y = "density_y",
    line = TRUE, 
    point = FALSE,
    ribbon = FALSE,
    facet = cdm_name ~ variable_name,
    colour = "species"
  ) +
  ggplot2::facet_grid(cdm_name ~ variable_name, scales = "free_x")

## -----------------------------------------------------------------------------
penguinsSummary |>
  filter(variable_name == "flipper_length_mm") |>
  filterStrata(year != "overall", sex %in% c("female", "male")) |>
  scatterPlot(
    x = c("year", "sex"), 
    y = "median",
    ymin = "q25",
    ymax = "q75",
    line = FALSE, 
    point = TRUE,
    ribbon = FALSE,
    facet = cdm_name ~ species,
    colour = "sex",
    group = c("year", "sex")
  ) +
  ggplot2::coord_flip() +
  ggplot2::labs(y = "Flipper length (mm)")

## -----------------------------------------------------------------------------
penguinsSummary |>
  filter(variable_name %in% c(
    "flipper_length_mm", "bill_length_mm", "bill_depth_mm")) |>
  filterStrata(sex == "overall") |>
  scatterPlot(
    x = "year", 
    y = "median",
    ymin = "min",
    ymax = "max",
    line = FALSE, 
    point = TRUE,
    ribbon = TRUE,
    facet = cdm_name ~ species,
    colour = "variable_name",
    group = c("variable_name")
  )

## -----------------------------------------------------------------------------
penguinsSummary |>
  filter(variable_name == "number records") |>
  filterGroup(species != "overall") |>
  filterStrata(sex != "overall", year != "overall") |>
  barPlot(
    x = "year",
    y = "count",
    colour = "sex",
    facet = cdm_name ~ species
  )

## -----------------------------------------------------------------------------
penguinsSummary |>
  filter(variable_name == "body_mass_g") |>
  boxPlot(x = "year", facet = c("cdm_name", "species"), colour = "sex")

## -----------------------------------------------------------------------------
penguinsSummary |>
  filter(variable_name == "body_mass_g") |>
  boxPlot(x = "year", facet = cdm_name ~ species, colour = "sex")

## -----------------------------------------------------------------------------
penguinsSummary |>
  filter(variable_name == "body_mass_g") |>
  filterGroup(species != "overall") |>
  filterStrata(sex %in% c("female", "male"), year != "overall") |>
  boxPlot(facet = cdm_name ~ species + sex, colour = "year")

## -----------------------------------------------------------------------------
penguinsTidy <- penguinsSummary |>
  filter(!estimate_name %in% c("density_x", "density_y")) |> # remove density for simplicity
  tidy()
penguinsTidy |> glimpse()

## -----------------------------------------------------------------------------
penguinsTidy |> class()

## -----------------------------------------------------------------------------
penguinsTidy |>
  filter(
    variable_name == "body_mass_g",
    species != "overall",
    sex %in% c("female", "male"),
    year != "overall"
  ) |>
  boxPlot(facet = cdm_name ~ species + sex, colour = "year")

## -----------------------------------------------------------------------------
library(ggplot2)
penguinsSummary |>
  filter(variable_name == "number records") |>
  tidy() |>
  ggplot(aes(x = year, y = sex, fill = count, label = count)) +
  geom_tile() +
  scale_fill_viridis_c(trans = "log") + 
  geom_text() +
  facet_grid(cdm_name ~ species)

## -----------------------------------------------------------------------------
penguinsSummary |>
  filter(
    group_level != "overall",
    strata_name == "year &&& sex",
    !grepl("NA", strata_level),
    variable_name == "body_mass_g") |>
  boxPlot(facet = cdm_name ~ species + sex, colour = "year") +
  ylim(c(0, 6500)) +
  labs(x = "My custom x label") +
  theme(legend.position = "top")

## ----eval=FALSE---------------------------------------------------------------
#  ggsave(
#    "figure8.png", plot = last_plot(), device = "png", width = 15, height = 12,
#    units = "cm", dpi = 300)

