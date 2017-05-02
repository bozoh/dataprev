#####Resultado dataprev concurso 2016 área 312RJ
#312RJ=ANALISTA DE TECNOLOGIA DA INFORMAÇÃO-INFRAESTRUTURA E APLICAÇÕES-RJ

install.packages("curl");
install.packages("rvest");
install.packages('stringr')
install.packages('tidyr')

library("rvest")
library('stringr')
library('tidyr')
library('dplyr')

base_url="http://portal.dataprev.gov.br/situacao-concursados/2016?"
cargo_field="&field_cargo_value=ANALISTA%20DE%20TECNOLOGIA%20DA%20INFORMA%C3%87%C3%83O"
perfil_field="&field_perfil_value=INFRAESTRUTURA%20E%20APLICA%C3%87%C3%95ES"
lotacao_field="&field_lotacao_value=RIO%20DE%20JANEIRO"
page_field="&page="

url=paste0(base_url,cargo_field,perfil_field,lotacao_field, sep="")

ultima_pagina = read_html(url) %>% html_nodes('.pager-last') %>% html_nodes('a') %>% 
  html_attr(name='href') %>% str_extract("&page=[\\d]+") %>% 
  str_extract("\\d+") %>% as.numeric()


dataprev = data.frame();

for(p in c(0:ultima_pagina)){
  url=paste0(url,page_field,p, sep="")
  dataprev_html <- read_html(url)
  dataprev_table <- html_nodes(dataprev_html, 'table')
  dataprev=rbind(dataprev,html_table(dataprev_table)[[1]])
} 
#PDC e cotistas  tem duas classificação, uma por ampla cocorencia e outra por vagas
#de cotas ou pdc, então removo PDC/Cotitas e busco as informações da classificação por
#ampla concorencia e por PDC/Cotas.  Só é possivel pelo num. de inscrição

#Obtendo PDC/COTISTAS
pdc_cotas=dataprev[which(dataprev$`Cadastro reserva`!="AMPLA CONCORRÊNCIA"),]
#Removendo-os do data frame
dataprev=dataprev[which(dataprev$`Cadastro reserva`=="AMPLA CONCORRÊNCIA"),]

#Obtendo informações da Ampla Concorencia do PDC/Cotista, e adicionando ao data.frame
inscricao_field = "&field_inscricao_value="
for(cod_insc in pdc_cotas$Inscrição){
  inscricao=paste0(inscricao_field,cod_insc,sep="")
  url=paste0(base_url,inscricao, sep="")
  dataprev_html <- read_html(url)
  dataprev_table <- html_nodes(dataprev_html, 'table')
  dataprev=rbind(dataprev,html_table(dataprev_table)[[1]])
} 
rm("p","page","url", "base_url","dataprev_html","dataprev_table", "cod_insc", 
   "inscricao_field","pdc_cotas","cargo_field","perfil_field","lotacao_field",
   "page_field","ultima_pagina", "inscricao")

head(dataprev)
pdc_cotas=dataprev[which(dataprev$`Cadastro reserva`!="AMPLA CONCORRÊNCIA"),]
dataprev[which(dataprev$`Disponibilidade do cadastro`!="DISPONÍVEL"),]
convocados=dataprev[which(dataprev$Situação!="NÃO CONVOCADO"),]
write.csv2(dataprev, "data/dataprev2.csv", row.names = F)

###
#Todos os dados

####Pegando do site (LENTO)
base_url="http://portal.dataprev.gov.br/situacao-concursados/2016?"
dataprev_html <- read_html(base_url)
dataprev_pagina <- html_nodes(dataprev_html, '.pager-last') %>% html_nodes('a')
ultima_pagina = html_attr(dataprev_pagina, name='href') %>% str_extract("&page=[\\d]+") %>% 
  str_extract("\\d+") %>% as.numeric()
page_field="&page="
dataprev = data.frame();
for(p in c(0:ultima_pagina)){
  page=paste0(page_field,p,sep="")
  url=paste0(base_url, page, sep="")
  dataprev_html <- read_html(url)
  dataprev_table <- html_nodes(dataprev_html, 'table')
  dataprev=rbind(dataprev,html_table(dataprev_table)[[1]])
}
rm("p","page","url", "base_url","dataprev_html","dataprev_table", "cod_insc", 
   "inscricao_field","pdc_cotas","cargo_field","perfil_field","lotacao_field",
   "page_field","ultima_pagina", "inscricao", "dataprev_pagina")
write.csv2(dataprev, "data/dataprev_completo.csv", row.names = F)

#######
#Pegando do csv
dataprev=read.csv2("data/dataprev_completo.csv")
#dp=read.csv2("data/dataprev2.csv")
nomes = c("Cargo","Perfil", "Lotação", "Situação Vaga",  "Tipo Concorrência", 
          "Classificação", "Candidato", "Inscrição", "Situação")
names(dataprev) = nomes
#names(dp) = nomes
rm(nomes)
head(dataprev)

dataprev %>% group_by(`Tipo Concorrência`) %>% count()
convocados_geral=dataprev %>% dplyr::filter(Situação == "EM ANDAMENTO") %>% 
  select(Candidato,  Classificação, Perfil, Lotação)

###### para o cargo/perfil 312RJ
dataprev_312RJ=dplyr::filter(dataprev, Cargo == "ANALISTA DE TECNOLOGIA DA INFORMAÇÃO" ) %>% 
  dplyr::filter(Lotação == "RIO DE JANEIRO") %>%
  dplyr::filter(Perfil == "INFRAESTRUTURA E APLICAÇÕES")

dataprev_312RJ %>% group_by(`Tipo Concorrência`) %>% count()
dataprev_312RJ %>% dplyr::filter(Situação == "EM ANDAMENTO")
