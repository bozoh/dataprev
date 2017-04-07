####REFERENCE http://data.library.virginia.edu/reading-pdf-files-into-r-for-text-mining/
#Linux
install.packages("SnowballC")
install.packages("tm") # only need to do once
install.packages("pdftools")

library(tm)
library(pdftools)
data_raw=pdf_text("edital_divulgao_resultado_final_20_02-2017_-_dataprev.pdf")
data_raw[2]


#https://github.com/ropensci/tabulizer
#https://www.r-bloggers.com/extracting-tables-from-pdfs-in-r-using-the-tabulizer-package/
install.packages("ghit")
install.packages("plyr")
#in linux
##("https://cran.r-project.org/src/contrib/stringi_1.1.5.tar.gz", type="source")
#install.packages("stringr")
#install.packages("evaluate")
#install.packages("knitr")
install.packages("rJava")
ghit::install_github(c("ropensci/tabulizerjars", "ropensci/tabulizer"), INSTALL_opts = "--no-multiarch")
library("tabulizer")
library(plyr)
#f <- system.file("edital_divulgao_resultado_final_20_02-2017_-_dataprev.pdf", package = "tabulizer")
dataprev_array <- extract_tables("data/edital_divulgao_resultado_final_20_02-2017_-_dataprev.pdf", pages = c(1050:1082))
summary(dataprev_array[1])
#com erro
#8,29,30,31,32,33
dataprev_list=do.call("rbind",dataprev_array[c(1:7,9:28)])
#rm(dataprev_array)
dataprev=as.data.frame(dataprev_list,stringsAsFactors = F)
#rm(dataprev_list)
names(dataprev)
nome=c("INSCRICAO","NOME","DOCUMENTO", "NASCIM.", "LP_ACERTO","LP_NOTA","LEST_ACERTO","LEST_NOTA","CG_ACERTO", "CG_NOTA", "CE_ACERTO","CE_NOTA","AC.TOT.","NOTA P.O.","TIT.","RED.","NT.GER.","CLASS","SITUACAO")
names(dataprev)=nome
summary(dataprev)

indicies=which(dataprev$LP_ACERTO=='')
dataprev[indicies,'LP_ACERTO']='0'
dataprev[indicies,'LP_NOTA']='0,0'
dataprev$LP_ACERTO=as.numeric(dataprev$LP_ACERTO)
dataprev$LP_NOTA=as.numeric(gsub(",", ".", dataprev$LP_NOTA))

indicies=which(dataprev$LEST_ACERTO=='')
dataprev[indicies,'LEST_ACERTO']='0'
dataprev[indicies,'LEST_NOTA']='0,0'
dataprev$LEST_ACERTO=as.numeric(dataprev$LEST_ACERTO)
dataprev$LEST_NOTA=as.numeric(gsub(",", ".", dataprev$LEST_NOTA))


indicies=which(dataprev$CG_ACERTO=='')
dataprev[indicies,'LEST_ACERTO']='0'
dataprev[indicies,'CG_NOTA']='0,0'
dataprev$LEST_ACERTO=as.numeric(dataprev$CG_ACERTO)
dataprev$LEST_NOTA=as.numeric(gsub(",", ".", dataprev$CG_NOTA))

indicies=which(dataprev$CE_ACERTO=='')
dataprev[indicies,'CE_ACERTO']='0'
dataprev[indicies,'CE_NOTA']='0,0'
dataprev$CE_ACERTO=as.numeric(dataprev$CE_ACERTO)
dataprev$CE_NOTA=as.numeric(gsub(",", ".", dataprev$CE_NOTA))

indicies=which(dataprev$AC.TOT.=='')
dataprev[indicies,'AC.TOT.']='0'
dataprev$AC.TOT.=as.numeric(dataprev$AC.TOT.)

indicies=which(dataprev$`NOTA P.O.`=='')
dataprev[indicies,'NOTA P.O.']='0'
dataprev$`NOTA P.O.`=as.numeric(dataprev$`NOTA P.O.`)

indicies=which(dataprev$TIT.=='')
dataprev[indicies,'TIT.']='0'
dataprev$TIT.=as.numeric(dataprev$TIT.)

indicies=which(dataprev$RED.=='')
dataprev[indicies,'RED.']='0'
dataprev$RED.=as.numeric(dataprev$RED.)

indicies=which(dataprev$NT.GER=='')
dataprev[indicies,'NT.GER.']='0'
dataprev$NT.GER.=as.numeric(dataprev$NT.GER.)

dataprev$CLASS=as.numeric(dataprev$CLASS)
