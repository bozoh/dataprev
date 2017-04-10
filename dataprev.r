#####Resultado dataprev concurso 2016 área 312RJ

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
#dataprev_array <- extract_tables("data/edital_divulgao_resultado_final_20_02-2017_-_dataprev.pdf", pages = c(1050:1082))

load("data/dataprev.RData")

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
dataprev$LP_NOTA=gsub(",", ".", dataprev$LP_NOTA)
dataprev$LP_NOTA=as.numeric(dataprev$LP_NOTA)

indicies=which(dataprev$LEST_ACERTO=='')
dataprev[indicies,'LEST_ACERTO']='0'
dataprev[indicies,'LEST_NOTA']='0,0'
dataprev$LEST_ACERTO=as.numeric(dataprev$LEST_ACERTO)
dataprev$LEST_NOTA=gsub(",", ".", dataprev$LEST_NOTA)
dataprev$LEST_NOTA=as.numeric(dataprev$LEST_NOTA)


indicies=which(dataprev$CG_ACERTO=='')
dataprev[indicies,'CG_ACERTO']='0'
dataprev[indicies,'CG_NOTA']='0,0'
dataprev$CG_ACERTO=as.numeric(dataprev$CG_ACERTO)
dataprev$CG_NOTA=as.numeric(gsub(",", ".", dataprev$CG_NOTA))

indicies=which(dataprev$CE_ACERTO=='')
dataprev[indicies,'CE_ACERTO']='0'
dataprev[indicies,'CE_NOTA']='0,0'
dataprev$CE_ACERTO=as.numeric(dataprev$CE_ACERTO)
dataprev$CE_NOTA=as.numeric(gsub(",", ".", dataprev$CE_NOTA))

indicies=which(dataprev$AC.TOT.=='')
dataprev[indicies,'AC.TOT.']='0'
dataprev$AC.TOT.=as.numeric(gsub(",", ".",dataprev$AC.TOT.))

indicies=which(dataprev$`NOTA P.O.`=='')
dataprev[indicies,'NOTA P.O.']='0'
dataprev$`NOTA P.O.`=as.numeric(gsub(",", ".",dataprev$`NOTA P.O.`))

indicies=which(dataprev$TIT.=='')
dataprev[indicies,'TIT.']=NA
dataprev$TIT.=gsub(",", ".",dataprev$TIT.)
dataprev$TIT.=gsub("NE", NA,dataprev$TIT.)
dataprev$TIT.=as.numeric(gsub(",", ".",dataprev$TIT.))

indicies=which(dataprev$RED.=='')
dataprev[indicies,'RED.']='0'
dataprev$RED.=as.numeric(gsub(",", ".",dataprev$RED.))

indicies=which(dataprev$NT.GER=='')
dataprev[indicies,'NT.GER.']='0'
dataprev$NT.GER.=as.numeric(gsub(",", ".",dataprev$NT.GER.))

indicies=which(dataprev$CLASS=='')
dataprev[indicies,'NT.GER.']=NA
dataprev$CLASS=as.numeric(gsub("o", "",dataprev$CLASS))
rm(indicies)
rm(nome)

dataprev_habilitados=dataprev[which(dataprev$SITUACAO=='Habilitado'),]
dataprev_habilitados[which(dataprev_habilitados$DOCUMENTO==""),]
dataprev_habilitados[which(dataprev_habilitados$INSCRICAO=="22090023645"),c('NOME','DOCUMENTO')]=c('RODRIGO AUGUSTO DE OLIVEIRA PAES BORGES BIONE','0122706393')
dataprev_habilitados[which(dataprev_habilitados$INSCRICAO=="22090068021"),c('NOME','DOCUMENTO')]=c('RODRIGO CAETANO FILGUEIRA','13386104')
dataprev_habilitados[which(dataprev_habilitados$INSCRICAO=="22090029777"),c('NOME','DOCUMENTO')]=c('RODRIGO GOMES MARCELO','219011319')
dataprev_habilitados[which(dataprev_habilitados$INSCRICAO=="22090061216"),c('NOME','DOCUMENTO')]=c('RODRIGO S MORAES','97679539')
dataprev_habilitados[which(dataprev_habilitados$DOCUMENTO==""),]
dataprev_habilitados$CHAMADO=''
summary(dataprev_habilitados)

hist(dataprev_habilitados$NT.GER.)

dataprev_habilitados[which(dataprev_habilitados$INSCRICAO=="22090029777"),]
dataprev_habilitados[which(dataprev_habilitados$INSCRICAO=="22090029777"),'CHAMADO']='03/02/2017'

#https://portal.dataprev.gov.br/situacao-concursados/2016
#https://portal.dataprev.gov.br/situacao-concursados/2016?field_candidato_value=&field_cargo_value=&field_perfil_value=&field_lotacao_value=&field_cadastro_reserva_value=ADMITIDO&field_inscricao_value=&field_cpf_value=&op-concurso=Pesquisar

