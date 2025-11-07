## ----echo=FALSE---------------------------------------------------------------
# Setup chunk
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  warning = FALSE,
  message = FALSE,
  fig.width = 7.2,
  fig.height = 5
)
options(rmarkdown.html_vignette.check_title = FALSE)

## ----message=FALSE, warning=FALSE---------------------------------------------
library(visOmopResults)
library(here)
library(gt)
library(ggplot2)
library(dplyr)
library(officer)

## -----------------------------------------------------------------------------
tableStyle()
plotStyle()

## ----echo=FALSE, results='asis'-----------------------------------------------
library(yaml)
theme <- read_yaml(file = here("inst/brand/darwin.yml"))
cat("```yaml\n", as.yaml(theme), "```", sep = "")

## ----echo=FALSE---------------------------------------------------------------
tibble(
  "type" = "Plot",
  "Part" = c("Background color", "Header (facet) color", "Header (facet) text color", "Border color", "Grid color", "Axis color", "Legend position", "Font family", "Font size"),
  "Option 1" = c("plot:background-color", "plot:header-color", "plot:header-text-color", "plot:border-color", "plot:grid-major-color", "plot:axis-color", "plot:legend-position", "typography:plot", "plot:font-size"),
  "Option 2" = c("color:background", "color:foreground", "-", "color:foreground", "color:foreground", "-", "-",  "typography:base", "typography:plot-font-size"),
  "Option 3" = c(rep("-", 8), "typography:base-font-size")
) |> 
  bind_rows(
    tibble(
      "type" = "Table section",
      "Part" = c("Background color", "Text bold", "Text color", "Text align", "Font size", "Font family", "Border color", "Border width"),
      "Option 1" = c("table:[section_name]:background-color", "table:[section_name]:text-bold", "table:[section_name]:text-color", "table:[section_name]:align", "table:[section_name]:font-size", "table:[section_name]:font-family", "table:[section_name]:border-color", "table:[section_name]:border-width"),
      "Option 2" = c("color:background", "-", "-", "-", "typography:table-font-size", "typography:table", "table:border-color", "table:border-width"),
      "Option 3" = c("-", "-", "-", "-", "typography:base-font-size", "typography:base", "-", "-")
    )
  ) |>
  visTable(groupColumn = "type")

## -----------------------------------------------------------------------------
result <- mockSummarisedResult() |> 
  filter(variable_name == "age")

barPlot(
  result = result,
  x = "cohort_name",
  y = "mean",
  facet = c("age_group", "sex"),
  colour = "sex",
  style = "darwin"
)

## ----eval=FALSE---------------------------------------------------------------
# barPlot(
#   result = result,
#   x = "cohort_name",
#   y = "mean",
#   facet = c("age_group", "sex"),
#   colour = "sex",
#   style = here("MyStyleFolder", "MyStyle.yml")
# )

## -----------------------------------------------------------------------------
result |>
  visOmopTable(
    estimateName = c("Mean (SD)" = "<mean> (<sd>)"),
    groupColumn = "cohort_name",
    header = c("This is an overall header", "sex"),
    type = "gt",
    style = list(
      header = list(
        cell_text(weight = "bold"), 
        cell_fill(color = "red")
      ),
      header_name = list(
        cell_text(weight = "bold"), 
        cell_fill(color = "orange")
      ),
      header_level = list(
        cell_text(weight = "bold"), 
        cell_fill(color = "yellow")
      ),
      column_name = list(
        cell_text(weight = "bold")
      ),
      group_label = list(
        cell_fill(color = "blue"),
        cell_text(color = "white", weight = "bold")
      ),
      title = list(
        cell_text(size = 20, weight = "bold")
      ),
      subtitle = list(
        cell_text(size = 15)
      ),
      body = list(
        cell_text(color = "red")
      )
    ),
    .options = list(
      title = "My formatted table!",
      subtitle = "Created with the `visOmopResults` R package.",
      groupAsColumn = FALSE,
      groupOrder = c("cohort2", "cohort1")
    )
  )

## -----------------------------------------------------------------------------
result |>
  visOmopTable(
    estimateName = c("Mean (SD)" = "<mean> (<sd>)"),
    groupColumn = "cohort_name",
    header = c("This is an overall header", "sex"),
    type = "flextable",
    style = list(
      header = list(
        cell = fp_cell(background.color = "red"),
        text = fp_text(bold = TRUE)
      ),
      header_level = list(
        cell = fp_cell(background.color = "orange"),
        text = fp_text(bold = TRUE)
      ),
      header_name = list(
        cell = fp_cell(background.color = "yellow"),
        text = fp_text(bold = TRUE)
      ),
      column_name = list(
        text = fp_text(bold = TRUE)
      ),
      group_label = list(
        cell = fp_cell(background.color = "blue"),
        text = fp_text(bold = TRUE, color = "white")
      ),
      title = list(
        text = fp_text(bold = TRUE, font.size = 20)
      ),
      subtitle = list(
        text = fp_text(font.size = 15)
      ),
      body = list(
        text = fp_text(color = "red")
      )
    ),
    .options = list(
      title = "My formatted table!",
      subtitle = "Created with the `visOmopResults` R package.",
      groupAsColumn = FALSE,
      groupOrder = c("cohort2", "cohort1")
    )
  )

## -----------------------------------------------------------------------------
library(ggplot2)

barPlot(
  result = result,
  x = "cohort_name",
  y = "mean",
  facet = c("age_group", "sex"),
  colour = "sex"
) +
  theme(
    strip.background = element_rect(fill = "#ffeb99", colour = "#ffcc00"),
    legend.position = "top",
    panel.grid.major = element_line(color = "transparent", linewidth = 0.25)
  ) +
  scale_color_manual(values = c("black", "black", "black")) +
  scale_fill_manual(values = c("#999999", "#E69F00", "#56B4E9"))

## ----eval=FALSE---------------------------------------------------------------
# library(extrafont)
# 
# # import system fonts (may take several minutes) - just needs to be done when
# # a new font is installed
# font_import(paths = NULL, prompt = FALSE)
# 
# # make fonts available for graphic devices using R
# loadfonts(device = "win")

## ----echo=FALSE---------------------------------------------------------------
extrafont::loadfonts(device = "win")  

## -----------------------------------------------------------------------------
barPlot(
  result = result,
  x = "cohort_name",
  y = "mean",
  facet = c("age_group", "sex"),
  colour = "sex",
  style = "darwin"
)

