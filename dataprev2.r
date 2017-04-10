#####Resultado dataprev concurso 2016 área 312RJ
#312RJ=ANALISTA DE TECNOLOGIA DA INFORMAÇÃO-INFRAESTRUTURA E APLICAÇÕES-RJ

install.packages("curl");
install.packages("rvest");
install.packages('stringr')
install.packages('tidyr')

library("rvest")
library('stringr')
library('tidyr')
url="http://portal.dataprev.gov.br/situacao-concursados/2016?field_candidato_value=&field_cargo_value=ANALISTA%20DE%20TECNOLOGIA%20DA%20INFORMA%C3%87%C3%83O&field_perfil_value=INFRAESTRUTURA%20E%20APLICA%C3%87%C3%95ES&field_lotacao_value=RIO%20DE%20JANEIRO&field_cadastro_reserva_value=&field_inscricao_value=&field_cpf_value=&op-concurso=Pesquisar"
dataprev = data.frame();
for(p in c(0:2)){
  page=paste0("&page=",p,sep="")
  url_page=paste0(url, page, sep="")
  dataprev_html <- read_html(url_page)
  dataprev_table <- html_nodes(dataprev_html, 'table')
  dataprev=rbind(dataprev,html_table(dataprev_table)[[1]])
} 
rm("p","page","url", "url_page","dataprev_html","dataprev_table")

head(dataprev)
dataprev[which(dataprev$Situação!="NÃO CONVOCADO"),]
write.csv2(dataprev, "dataprev2.csv")
