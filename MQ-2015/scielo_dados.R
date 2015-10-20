rm(list=ls())
options(warn=-1)
options(show.error.messages = T)
library(XML)

url.scielo <- "http://www.scielo.br/scielo.php?script=sci_issues&pid=0011-5258&lng=en&nrm=iso"
pagina <- readLines(url.scielo)
pagina <- htmlParse(pagina)
pagina <- xmlRoot(pagina)
links <- getNodeSet(pagina,"//font[@color]/a[@href]")
links <- xmlSApply(links, xmlGetAttr, name = "href")
links.numeros.scielo <- unlist(links)[2:length(links)]

links.artigos.scielo <- c()
for (i in links.numeros.scielo){
  pagina <- readLines(i)
  pagina <- htmlParse(pagina)
  pagina <- xmlRoot(pagina)
  links <- getNodeSet(pagina,"//div[@align='left']/a[@href]")
  links <- xmlSApply(links, xmlGetAttr, name = "href")
  links <- grep("arttext", links, value = T)
  links.artigos.scielo <- c(links.artigos.scielo, links)
}
links.artigos.scielo <- unlist(links.artigos.scielo)

contador = 1
links.problema = c()
dados <- data.frame()
for (j in links.artigos.scielo){
  print(contador)
#  j = links.artigos.scielo[100]
  pagina <- readLines(j)
  pagina <- htmlParse(pagina)
  pagina <- xmlRoot(pagina)
  link.xml <- getNodeSet(pagina,"//a[@target='xml']")
  link.xml <- xmlSApply(link.xml, xmlGetAttr, name = "href")
  pagina.xml <- readLines(link.xml)
  erro <- try(xmlParse(pagina.xml), silent=TRUE)
  if ('try-error' %in% class(erro)){
    links.problema = c(links.problema, j)
  }
  else {
    pagina.xml <- xmlParse(pagina.xml)
    pagina.xml <- xmlRoot(pagina.xml)
    autores.sobrenomes <- getNodeSet(pagina.xml,"//article-meta/contrib-group/contrib/name/surname")
    autores.sobrenomes <- xmlSApply(autores.sobrenomes, xmlValue)
    autores.nomes <- getNodeSet(pagina.xml,"//article-meta/contrib-group/contrib/name/given-names")
    autores.nomes <- xmlSApply(autores.nomes, xmlValue)
    autores <- data.frame(autores.nomes, autores.sobrenomes)
    referencia.sobrenomes <- getNodeSet(pagina.xml,"//back/ref-list/ref/nlm-citation/person-group/name/surname")
    referencia.sobrenomes <- xmlSApply(referencia.sobrenomes, xmlValue)
    referencia.nomes <- getNodeSet(pagina.xml,"//back/ref-list/ref/nlm-citation/person-group/name/given-names")
    referencia.nomes <- xmlSApply(referencia.nomes, xmlValue)
    if (length(referencia.sobrenomes) == length(referencia.nomes)){
      referencias <- data.frame(referencia.nomes, referencia.sobrenomes)    
    }
    if (length(referencia.sobrenomes) != length(referencia.nomes)){
      referencia.completa <- getNodeSet(pagina.xml,"//back/ref-list/ref/nlm-citation/person-group/name")
      referencia.completa <- xmlSApply(referencia.completa, xmlValue)
      referencias <- data.frame("referencia.nomes" = referencia.completa, referencia.sobrenomes = NA)    
    }
    dados.artigo <- merge(autores, referencias)
    dados <- rbind(dados, dados.artigo)    
  }
  contador = contador + 1
}


