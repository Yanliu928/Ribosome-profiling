# package installation
install.packages("devtools")
devtools::install_github("hadley/devtools")
install.packages("gert")
install.packages('remotes')
library("remotes")
setwd('~/R')
remotes::install_github("ohlerlab/RiboseQC")
library("RiboseQC")

#prepare annotation files
prepare_annotation_files(annotation_directory = '.',
                         twobit_file = 'Rattus_norvegicus.Rnor_6.0.dna.toplevel.2bit',
                         gtf_file = 'Rattus_norvegicus.Rnor_6.0.101.gtf', scientific_name = 'Rat.Ribosome',
                         annotation_name = 'Rat_101',export_bed_tables_TxDb = F,forge_BSgenome = T,create_TxDb = T)
load_annotation('Rattus_norvegicus.Rnor_6.0.101.gtf_Rannot')

#set the bamfile path
bam_filepath <- c('UNDSRR9596295_clipped_t10_f2_tr_Rnor_6_sorted.bam', 
                  'UNDSRR9596296_clipped_t10_f2_tr_Rnor_6_sorted.bam',
                  'UNDSRR9596300_clipped_t10_f2_tr_Rnor_6_sorted.bam', 
                  'UNDSRR9596303_clipped_t10_f2_tr_Rnor_6_sorted.bam', 
                  'UNDSRR9596304_clipped_t10_f2_tr_Rnor_6_sorted.bam', 
                  'UNDSRR9596310_clipped_t10_f2_tr_Rnor_6_sorted.bam')
# analyze the bam files and check the quality
RiboseQC_analysis(annotation_file = 'Rattus_norvegicus.Rnor_6.0.101.gtf_Rannot',
                  bam_files =  bam_filepath, fast_mode = T, report_file = 'SRR_bam.html', 
                  sample_names = c('SRR9596295', 'SRR9596296','SRR9596300', 'SRR9596303',  'SRR9596304', 'SRR9596310'), 
                  dest_names = c('SRR9596295', 'SRR9596296','SRR9596300', 'SRR9596303',  'SRR9596304', 'SRR9596310'), 
                  write_tmp_files = F)

