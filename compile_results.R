library(tidyverse)

meta <- "./sample_description.tsv" |>
    read_tsv(col_names = c("sample_id", "fq1", "fq2"))


hlapers_files <- sprintf("./genotype_calls/hlapers/%s_genotypes.tsv", meta$sample_id) |>
    setNames(meta$sample_id)

kourami_files <- sprintf("./genotype_calls/kourami/%s.result", meta$sample_id) |>
    setNames(meta$sample_id)

hlapers_results <- hlapers_files |>
    map_dfr(read_tsv, col_names = TRUE, .id = "sample_id") |>
    filter(locus %in% c("A", "B", "C")) |>
    arrange(sample_id, locus, allele) |>
    group_by(sample_id, locus) |>
    mutate(h = seq_len(n())) |>
    ungroup() |>
    select(sample_id, locus, h, allele)

kourami_results <- kourami_files |>
    map_dfr(read_tsv, col_names = FALSE, .id = "sample_id") |>
    extract(X1, "locus", "([^*]+)", remove = FALSE) |>
    filter(locus %in% c("A", "B", "C")) |>
    arrange(sample_id, locus, X1) |>
    group_by(sample_id, locus) |>
    mutate(h = seq_len(n())) |>
    ungroup() |>
    select(sample_id, locus, h, allele = X1)

results_df <- 
    left_join(hlapers_results, kourami_results,
	      by = c("sample_id", "locus", "h"),
	      suffix = c("_hlapers", "_kourami")) |>
    mutate_at(vars(allele_hlapers), ~sub("IMGT_", "", .)) |>
    mutate_at(vars(allele_kourami), ~sub(";", "/", .))

write_csv(results_df, "./results.csv")
