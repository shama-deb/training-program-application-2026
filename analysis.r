# ---------------------------------------------------------

# Melbourne Bioinformatics Training Program

# This exercise to assess your familiarity with R and git. Please follow
# the instructions on the README page and link to your repo in your application.
# If you do not link to your repo, your application will be automatically denied.

# Leave all code you used in this R script with comments as appropriate.
# Let us know if you have any questions!


# You can use the resources available on our training website for help:
# Intro to R: https://mbite.org/intro-to-r
# Version Control with Git: https://mbite.org/intro-to-git/

# ----------------------------------------------------------

# Load libraries -------------------
# You may use base R or tidyverse for this exercise

# ex. library(tidyverse)

library(readr)
library(tidyr)
library(ggplot2)
# Load data here ----------------------
# Load each file with a meaningful variable name.
data<- read_csv("https://raw.githubusercontent.com/egmg726/training-program-application-2026/refs/heads/main/data/GSE60450_GeneLevel_Normalized(CPM.and.TMM)_data.csv")
metadata<-read_csv("https://raw.githubusercontent.com/egmg726/training-program-application-2026/refs/heads/main/data/GSE60450_filtered_metadata.csv")
# Inspect the data -------------------------
View(data)
View(metadata)
# What are the dimensions of each data set? (How many rows/columns in each?)
# Keep the code here for each file.

## Expression data
dim(data)

## Metadata
dim(metadata)

# Prepare/combine the data for plotting ------------------------
# How can you combine this data into one data.frame?
expr <- data[, -c(1,2)]
expr$gene_symbol <- data$`gene_symbol`
expr_long <- pivot_longer(expr,
                          cols = -gene_symbol,
                          names_to = "sample",
                          values_to = "expression")

metadata$sample <- rownames(metadata)

combined_data <- merge(expr_long, metadata, by = "sample")


# Plot the data --------------------------
## Plot the expression by cell type
## Can use boxplot() or geom_boxplot() in ggplot2




# Ensure cell_type is factor
combined_data$cell_type <- as.factor(combined_data$cell_type)

p<-ggplot(combined_data, aes(x = cell_type, y = expression)) +
  geom_boxplot(fill = "skyblue", color = "darkblue") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(title = "Gene Expression by Cell Type",
       x = "Cell Type",
       y = "Expression")


print(p)

## Save the plot
### Show code for saving the plot with ggsave() or a similar function
if(!dir.exists("results")){
  dir.create("results")
}

ggsave("results/GeneA_boxplot.png", plot = p, width = 8, height = 6, dpi = 300)
