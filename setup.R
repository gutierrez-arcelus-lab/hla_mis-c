library(tidyverse)

tibble(f = list.files("./fastq")) |>
    extract(f, c("sample_id", "fidx"), "(Key_\\d+)_([12])", remove = FALSE) |>
    pivot_wider(names_from = fidx, values_from = f) |>
    write_tsv("sample_description.tsv", col_names = FALSE)

