test_that("tidy", {
  mocksum <- mockSummarisedResult()

  expect_no_error(res0 <- tidy(x = mocksum, pivotEstimatesBy = "estimate_name"))
  expect_true(nrow(res0 |> dplyr::filter(.data$variable_name == "settings")) == 0)
  expect_true(all(c("cohort_name", "age_group", "sex", "count",
                    "mean", "sd", "percentage") %in% colnames(res0)))
  expect_true(class(res0$percentage) == "numeric")
  expect_true(class(res0$mean) == "numeric")
  expect_true(class(res0$count) == "integer")

  expect_no_error(res1 <- tidy(mocksum, splitGroup = FALSE, splitAdditional = FALSE,
                               splitStrata = FALSE, pivotEstimatesBy = c("variable_name", "variable_level", "estimate_name")))
  expect_true(all(c("group_name", "group_level", "strata_name", "strata_level",
                    "additional_name", "additional_level") %in%
                    colnames(res1)))
  expect_true(all(c("number subjects_NA_count", "age_NA_mean", "age_NA_sd", "Medications_Amoxiciline_count",
                    "Medications_Amoxiciline_percentage", "Medications_Ibuprofen_count",
                    "Medications_Ibuprofen_percentage") %in% colnames(res1)))

  expect_no_error(res2 <- tidy(mocksum,
                               splitGroup = FALSE,
                               splitAdditional = FALSE,
                               addSettings = FALSE,
                               pivotEstimatesBy = c("variable_name", "estimate_name"),
                               nameStyle = "{estimate_name}__{variable_name}"))
  expect_false("logic__settings" %in% colnames(res2))
  expect_true(all(c("count__number subjects", "mean__age", "sd__age",
                    "count__Medications", "percentage__Medications") %in% colnames(res2)))
  expect_true(class(res2$percentage__Medications) == "numeric")
  expect_true(class(res2$mean__age) == "numeric")
  expect_true(class(res2$count__Medications) == "integer")

  expect_no_error(res3 <- tidy(mocksum, splitGroup = FALSE, splitAdditional = FALSE, splitStrata = FALSE,
                                pivotEstimatesBy = NULL))
  expect_true(all(colnames(res3) %in% c(
    colnames(mocksum), "result_type", "package_name", "package_version"
  )))

  # 2 id's:
  mocksum2 <- mocksum |>
    dplyr::union_all(mocksum |> dplyr::mutate(result_id = as.integer(2)))
  expect_no_error(res4 <- tidy(x = mocksum2))
})

test_that("tidy, dates", {
  result <- dplyr::tibble(
    "result_id" = integer(1),
    "cdm_name" = "mock",
    "group_name" = "cohort_name",
    "group_level" = c(rep("cohort1", 9), rep("cohort2", 9)),
    "strata_name" = rep(c(
      "overall", rep("age_group &&& sex", 4), rep("sex", 2), rep("age_group", 2)
    ), 2),
    "strata_level" = rep(c(
      "overall", "<40 &&& Male", ">=40 &&& Male", "<40 &&& Female",
      ">=40 &&& Female", "Male", "Female", "<40", ">=40"
    ), 2),
    "variable_name" = "number subjects",
    "variable_level" = NA_character_,
    "estimate_name" = "count",
    "estimate_type" = "integer",
    "estimate_value" = round(10000000*stats::runif(18)) |> as.character(),
    "additional_name" = "overall",
    "additional_level" = "overall"
  ) |>
    dplyr::union_all(
      dplyr::tibble(
        "result_id" = integer(1),
        "cdm_name" = "mock",
        "group_name" = "cohort_name",
        "group_level" = c(rep("cohort1", 9), rep("cohort2", 9)),
        "strata_name" = rep(c(
          "overall", rep("age_group &&& sex", 4), rep("sex", 2), rep("age_group", 2)
        ), 2),
        "strata_level" = rep(c(
          "overall", "<40 &&& Male", ">=40 &&& Male", "<40 &&& Female",
          ">=40 &&& Female", "Male", "Female", "<40", ">=40"
        ), 2),
        "variable_name" = "start date",
        "variable_level" = NA_character_,
        "estimate_name" = "date",
        "estimate_type" = "date",
        "estimate_value" = as.Date("2020-10-01") |> as.character(),
        "additional_name" = "overall",
        "additional_level" = "overall"
      )
    ) |>
    omopgenerics::newSummarisedResult(
      settings = dplyr::tibble(
        "result_id" = integer(1),
        "result_type" = "mock_summarised_result",
        "package_name" = "visOmopResults",
        "package_version" = utils::packageVersion("visOmopResults") |>
          as.character()
      )
    )
  expect_no_error(result_out <- tidy(result))
  expect_true(class(as.Date(result_out |> dplyr::pull(date))) == "Date")
})
