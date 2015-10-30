cadernosNoticias <- c()
proxUrl <- "http://busca.estadao.com.br/?q=UFSCar&pagina=1"
baseUrl <- "http://busca.estadao.com.br"
pagina <- readLines(proxUrl)
pagina <- htmlParse(pagina)
pagina <- xmlRoot(pagina)
caderno <- getNodeSet(pagina, "//div[@class = 'listainfo']/p")
caderno <- xmlSApply(caderno, xmlValue)
cadernosNoticias <- rbind(cadernosNoticias, caderno)
proxUrl <- getNodeSet(pagina, "//a[@class = 'navegaultimas']")
proxUrl <- xmlSApply(proxUrl, xmlGetAttr, "href")
proxUrl <- paste(baseUrl, proxUrl, sep = "")
continua = 1
while(continua == 1){
  pagina <- readLines(proxUrl)
  pagina <- htmlParse(pagina)
  pagina <- xmlRoot(pagina)
  caderno <- getNodeSet(pagina, "//div[@class = 'listainfo']/p")
  caderno <- xmlSApply(caderno, xmlValue)
  cadernosNoticias <- rbind(cadernosNoticias, caderno)
  proxUrl <- getNodeSet(pagina, "//a[@class = 'navegaultimas']")
  proxUrl <- xmlSApply(proxUrl, xmlGetAttr, "href")
  if (length(proxUrl) < 2){
    continua = 0
  }
  else {
    proxUrl <- paste(baseUrl, proxUrl, sep = "")[[2]]
  }
}

