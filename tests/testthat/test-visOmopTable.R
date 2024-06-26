test_that("visOmopTable", {
  result <- mockSummarisedResult()
  expect_message(
    expect_no_error(
      gt1 <- visOmopTable(
        result = result,
        formatEstimateName = character(),
        header = character(),
        groupColumn = NULL,
        split = c("group", "strata", "additional"),
        type = "gt",
        excludeColumns = c("result_id", "estimate_type"),
        .options = list())
    )
  )
  expect_true("gt_tbl" %in% class(gt1))
  expect_true(all(c("CDM name", "Cohort name", "Age group", "Sex", "Variable name", "Variable level", "Estimate name", "Estimate value") %in%
                    colnames(gt1$`_data`)))

  expect_message(
  expect_no_error(
    gt2 <- visOmopTable(
      result = result,
      formatEstimateName = c("N%" = "<count> (<percentage>)", "N" = "<count>"),
      header = c("strata"),
      groupColumn = NULL,
      split = c("group", "strata", "additional"),
      type = "gt",
      excludeColumns = c("result_id", "estimate_type"),
      .options = list())
  )
  )
  expect_true("gt_tbl" %in% class(gt2))
  expect_true(all(c(
    "CDM name", "Cohort name",
    "Variable name", "Variable level",
    "Estimate name", "[header]Age group\n[header_level]Overall\n[header]Sex\n[header_level]Overall",
    "[header]Age group\n[header_level]<40\n[header]Sex\n[header_level]Male", "[header]Age group\n[header_level]>=40\n[header]Sex\n[header_level]Male",
    "[header]Age group\n[header_level]<40\n[header]Sex\n[header_level]Female", "[header]Age group\n[header_level]>=40\n[header]Sex\n[header_level]Female",
    "[header]Age group\n[header_level]Overall\n[header]Sex\n[header_level]Male", "[header]Age group\n[header_level]Overall\n[header]Sex\n[header_level]Female",
    "[header]Age group\n[header_level]<40\n[header]Sex\n[header_level]Overall", "[header]Age group\n[header_level]>=40\n[header]Sex\n[header_level]Overall"
  ) %in% colnames(gt2$`_data`)))
  expect_true(nrow(gt2$`_data`) == 10)

  expect_message(
  expect_no_error(
    fx1 <- visOmopTable(
      result = result,
      formatEstimateName = c("N%" = "<count> (<percentage>)", "N" = "<count>", "<mean>, <sd>"),
      header = c("group", "estimate"),
      groupColumn = NULL,
      split = c("group", "strata", "additional"),
      type = "flextable",
      excludeColumns = c("result_id", "estimate_type", "cdm_name"),
      .options = list())
  )
  )
  expect_true("flextable" == class(fx1))
  expect_true(all(c(
    "Age group", "Sex", "Variable name", "Variable level", "Cohort name\nCohort1\nN",
    "Cohort name\nCohort2\nN", "Cohort name\nCohort1\nmean, sd", "Cohort name\nCohort2\nmean, sd", "Cohort name\nCohort1\nN%", "Cohort name\nCohort2\nN%"
  ) %in% colnames(fx1$body$dataset)))
  expect_true(nrow(fx1$body$dataset) == 36)

  expect_message(
  expect_no_error(
    fx2 <- visOmopTable(
      result = result,
      formatEstimateName = c("N%" = "<count> (<percentage>)", "N" = "<count>", "<mean>, <sd>"),
      header = c("variable", "estimate"),
      groupColumn = NULL,
      split = c("group", "strata", "additional"),
      type = "flextable",
      excludeColumns = c("result_id", "estimate_type", "cdm_name"),
      .options = list())
  )
  )
  expect_true("flextable" == class(fx2))
  expect_true(all(c(
    "Cohort name", "Age group", "Sex", "Number subjects\n-\nN", "Age\n-\nmean, sd",
    "Medications\nAmoxiciline\nN%", "Medications\nIbuprofen\nN%"
  ) %in% colnames(fx2$body$dataset)))
  expect_true(nrow(fx2$body$dataset) == 18)

  expect_message(
  expect_no_error(
    fx3 <- visOmopTable(
      result = result,
      formatEstimateName = c("N%" = "<count> (<percentage>)", "N" = "<count>", "<mean>, <sd>"),
      header = c("strata", "estimate"),
      groupColumn = "cohort_name",
      split = c("group", "additional"),
      type = "flextable",
      excludeColumns = c("result_id", "estimate_type", "cdm_name"),
      .options = list())
  )
  )
  expect_true("flextable" == class(fx3))
  expect_true(all(c(
    'Cohort name', 'Variable name', 'Variable level', 'Overall\nOverall\nN', 'Age group and sex\n<40 and male\nN',
    'Age group and sex\n>=40 and male\nN', 'Age group and sex\n<40 and female\nN', 'Age group and sex\n>=40 and female\nN',
    'Sex\nMale\nN', 'Sex\nFemale\nN', 'Age group\n<40\nN', 'Age group\n>=40\nN', 'Overall\nOverall\nmean, sd',
    'Age group and sex\n<40 and male\nmean, sd', 'Age group and sex\n>=40 and male\nmean, sd',
    'Age group and sex\n<40 and female\nmean, sd', 'Age group and sex\n>=40 and female\nmean, sd', 'Sex\nMale\nmean, sd',
    'Sex\nFemale\nmean, sd', 'Age group\n<40\nmean, sd', 'Age group\n>=40\nmean, sd', 'Overall\nOverall\nN%', 'Age group and sex\n<40 and male\nN%',
    'Age group and sex\n>=40 and male\nN%', 'Age group and sex\n<40 and female\nN%', 'Age group and sex\n>=40 and female\nN%',
    'Sex\nMale\nN%', 'Sex\nFemale\nN%', 'Age group\n<40\nN%', 'Age group\n>=40\nN%'
  ) %in% colnames(fx3$body$dataset)))
  expect_true(nrow(fx3$body$dataset) == 10)

  # settings ----
  expect_message(
  expect_no_error(
    visOmopTable(
      result = result,
      formatEstimateName = c("N%" = "<count> (<percentage>)", "N" = "<count>", "<mean>, <sd>"),
      header = c("group", "settings"),
      groupColumn = NULL,
      split = c("group", "additional"),
      type = "tibble",
      excludeColumns = c("result_id", "estimate_type", "cdm_name"),
      .options = list())
  )
  )

  result <- mockSummarisedResult() |>
    omopgenerics::suppress(1000000)
  expect_no_error(
    tib1 <- visOmopTable(
      result = result,
      formatEstimateName = c("N%" = "<count> (<percentage>)", "N" = "<count>", "<mean>, <sd>"),
      header = c("group", "settings"),
      groupColumn = NULL,
      split = c("group", "additional"),
      type = "tibble",
      excludeColumns = c("result_id", "estimate_type", "cdm_name"),
      .options = list())
  )
  expect_true(all(c("tbl_df", "tbl", "data.frame") %in% class(tib1)))
  expect_true(all(c(
    "Strata name", "Strata level", "Variable name", "Variable level", "Estimate name",
    paste0("[header]Cohort name\n[header_level]Cohort1\n[header]result_id\n[header_level]Mock summarised result\n[header_level]Visomopresults\n[header_level]", utils::packageVersion("visOmopResults"), "\n[header_level]1000000"),
    paste0("[header]Cohort name\n[header_level]Cohort2\n[header]result_id\n[header_level]Mock summarised result\n[header_level]Visomopresults\n[header_level]", utils::packageVersion("visOmopResults"), "\n[header_level]1000000")) %in% colnames(tib1)))
  expect_true(tib1[19:36, 6] |> dplyr::pull() |> unique() == "<1,000,000 (<1,000,000)")

  # woring group column
  expect_error(
    visOmopTable(
      result = result,
      formatEstimateName = c("N%" = "<count> (<percentage>)", "N" = "<count>", "<mean>, <sd>"),
      header = c("group", "settings"),
      groupColumn = "hola",
      split = c("group", "additional"),
      type = "tibble",
      excludeColumns = c("result_id", "estimate_type", "cdm_name"),
      .options = list())
  )
})

test_that("renameColumn works", {
  result <- mockSummarisedResult()
  expect_message(
    expect_no_error(
      gt1 <- visOmopTable(
        result = result,
        formatEstimateName = character(),
        header = character(),
        groupColumn = NULL,
        split = c("group", "strata", "additional"),
        type = "gt",
        renameColumns = c("Database name" = "cdm_name"),
        excludeColumns = c("result_id", "estimate_type"),
        .options = list())
    )
  )
  expect_true(all(
    colnames(gt1$`_data`) ==
      c("Database name", "Cohort name", "Age group", "Sex", "Variable name",
        "Variable level", "Estimate name", "Estimate value")
  ))

  expect_no_error(
    gt2 <- visOmopTable(
      result = result,
      formatEstimateName = character(),
      header = c("cdm_name", "strata"),
      groupColumn = NULL,
      split = c("group", "strata", "additional"),
      type = "gt",
      renameColumns = c("Database name" = "cdm_name", "changeName" = "variable_name"),
      excludeColumns = c("result_id", "estimate_type"),
      .options = list())
  )
  expect_true(all(colnames(gt2$`_data`)[1:2] == c("Cohort name", "changeName")))
  expect_true(all(colnames(gt2$`_data`)[5] == "[header]Database name\n[header_level]mock\n[header]Age group\n[header_level]Overall\n[header]Sex\n[header_level]Overall"))

  expect_message(
    expect_warning(
    fx1 <- visOmopTable(
      result = result,
      formatEstimateName = character(),
      header = c("cdm_name", "strata"),
      groupColumn = NULL,
      split = c("group", "strata", "additional"),
      type = "flextable",
      renameColumns = c("Database name" = "cdm_name", "changeName" = "name"),
      excludeColumns = c("result_id", "estimate_type"),
      .options = list())
    )
  )

  # more than 1 group column
  fx2 <- visOmopTable(
    result = result,
    formatEstimateName = character(),
    header = c("strata"),
    split = c("group", "strata", "additional"),
    type = "flextable",
    groupColumn = c("cdm_name", "cohort_name"),
    renameColumns = c("Database name" = "cdm_name", "changeName" = "variable_name"),
    excludeColumns = c("result_id", "estimate_type"),
    .options = list())
  expect_true(colnames(fx2$body$dataset)[1] == "cdm_name_cohort_name")

  # more than 1 group column
  fx3 <- visOmopTable(
    result = result,
    formatEstimateName = character(),
    header = c("strata"),
    split = c("group", "strata", "additional"),
    type = "flextable",
    groupColumn = list("group" = c("cdm_name", "cohort_name")),
    renameColumns = c("Database name" = "cdm_name", "changeName" = "variable_name"),
    excludeColumns = c("result_id", "estimate_type"),
    .options = list())
  expect_true(colnames(fx3$body$dataset)[1] == "group")
})
