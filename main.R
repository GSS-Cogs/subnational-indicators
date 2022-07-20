library(tidyverse)

kebabify <- function(string) {
  tolower(gsub("[ _]", "-", string))
}

fix_financial_years <- function(string) {
  first_year <- as.integer(str_sub(string, 1, 4))
  return(as.character(glue::glue("{first_year}-{first_year + 1}")))
}

df <- read_csv(
  "./raw-data/20220331_subnational_indicators_explorer.csv",
  col_types = list(Period = col_character())
)

df <- df %>% 
  janitor::clean_names() %>%
  rename(
    area = areacd,
    area_label = areanm,
    area_type = tier
  ) %>%
  # We'll use the Indicator column to define the measures.
  select(-measure) %>% 
  mutate(
    unit = recode(
      unit,
      "%" = "Percent",
      "Number" = "Number of houses",
      "Avg" = NA_character_, # Not sure how to express units for 10-point scale.
      "Time" = "Hours",
      "yrs" = "Years"
    )
  ) %>%
  mutate(
    period_type = case_when(
      str_detect(period, "^\\d{4}$") ~ "year",
      str_detect(period, "^\\d{4}/\\d{2}$") ~ "government-year",
      str_detect(period, "^\\d{4}-\\d{2}$") ~ "government-year"
    ),
    .before = period
  ) %>%
  mutate(
    period = case_when(
      str_detect(period, "^\\d{4}$") ~ period,
      str_detect(period, "^\\d{4}/\\d{2}$") ~ fix_financial_years(period),
      str_detect(period, "^\\d{4}-\\d{2}$") ~ fix_financial_years(period)
    )
  ) %>%
  mutate(
    indicator = kebabify(indicator),
    category = kebabify(category)
  )

write_csv(
  df,
  "./data/20220331-subnational-indicators.csv",
  na = ""
)