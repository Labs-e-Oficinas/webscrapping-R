library(XML)
baseurl <- "http://www.portaldatransparencia.gov.br/servidores/OrgaoLotacao-ListaServidores.asp?CodOrg=26280&Pagina="
ids <- c()
for (i in 1:154){
  print(i)
  url <- paste(baseurl, i, sep = "")
  pagina <- readLines(url)
  paginaXML <- htmlParse(pagina)
  paginaXML <- xmlRoot(paginaXML)
  idLink <- xpathSApply(paginaXML,
                        "//table[@summary= 'Lista de servidores lotados por órgão']//a",
                        xmlGetAttr,
                        "href")
  idLink <- idLink[3:17]
  idLink <- substr(idLink, 45, 51)
  ids <- c(ids, idLink)
}
