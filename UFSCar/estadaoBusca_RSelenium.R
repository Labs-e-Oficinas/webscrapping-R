checkForServer()
startServer()
remDrv <- remoteDriver(browserName = 'firefox')
remDrv$open()
vetorBuscas <- c("UFSCar", "USP", "UNESP", "UNICAMP", "UNIFESP")
for (busca in vetorBuscas){
  remDrv$navigate('http://busca.estadao.com.br/')
  remDrv$findElement(using = "xpath", "//input[@id = 'myInputBusca']")$sendKeysToElement(list(busca))
  remDrv$findElement(using = "xpath", "//input[@type = 'submit']")$clickElement()
}
remDrv$closeWindow()
remDrv$quit()
remDrv$closeServer()

