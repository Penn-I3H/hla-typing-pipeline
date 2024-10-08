library(autoHLA)
library(tidyverse)

dir_in <- Sys.getenv("INPUT_DIR")
dir_out <- Sys.getenv("OUTPUT_DIR")

HLA_data <- read_HLA_data(dir_in)
HLA_data <- analyze_HLA_data(HLA_data)

# heatmap of subject level calls
p <- plot_heatmap(HLA_data)
ggsave(p, filename=paste0(dir_out, "/heatmap.png"), width=8, height=10)

# subject level calls overlaid on histograms
p <- make_output_plot(HLA_data)
ggsave(p, filename=paste0(dir_out, "/calls.png"), width=12, height=10)

# write table of calls
write_csv(HLA_data$call_df, file=paste0(dir_out, "/HLA_calls.csv"))



