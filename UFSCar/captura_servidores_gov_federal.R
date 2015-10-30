baseurl <- "http://www.portaldatransparencia.gov.br/servidores/Servidor-ListaServidores.asp?bogus=1&Pagina="
dados <- data.frame()
for (i in 1:15) {
  print(i)
  url <- paste(baseurl, i, sep = "")
  lista.tabelas <- readHTMLTable(url, stringsAsFactors = FALSE)
  tabela <- lista.tabelas[[1]]
  dados <- rbind(dados, tabela)
  print(nrow(dados))
}