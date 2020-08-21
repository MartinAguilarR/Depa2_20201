##################### DEPA 2 #####################
# En los siguientes sitios web aparecerán tablas de remuneraciones de distintas instituciones
# pertenecientes al sector público.

    # https://www.portaltransparencia.cl/PortalPdT/pdtta/-/ta/AV001/PR/PCONT/15762429
    # https://www.uaf.cl/transparencia/2012/per_remuneraciones_ene-nov.html
    # http://www.gorearaucania.cl/transparencia/2018/remuneraciones.html

#   Se le pide que extraiga esta información y realice la estadística pertinente respondiendo a
# alguna pregunta que usted se haga viendo los datos de estos sitios. En su análisis, debe al
# menos mostrar dos gráficos. 

#####################        #####################


#Para la realización de este ejercicios, se utilizaron las librerias "Xml12" y "Rvest", para analisis de Html
# y "ggplot2" para graficar resultados.



rm(list=ls())

install.packages("rvest")

library(xml2)
library(rvest)
library(ggplot2)


####################### PASO 1 #######################
#        EXTRACCIÓN Y VISUALIZACIÓN DE DATA           #


#Asignamos las variables HTML para su exploración y extracción,
# para ello se utilizó el comando read_html() y view()

HtmlExCNA <- read_html("https://www.portaltransparencia.cl/PortalPdT/pdtta/-/ta/AV001/PR/PCONT/15762429")
HtmlINDAP <- read_html("https://www.portaltransparencia.cl/PortalPdT/pdtta/-/ta/AR004/PR/PCONT/52470664")
HtmlGobRArauco <- read_html("http://www.gorearaucania.cl/transparencia/2018/remuneraciones.html")


#Visualización de elementos dentro del Html

View(HtmlExCNA) 
View(HtmlINDAP)
View(HtmlGobRArauco)


# A continuación se extraen las tablas de los links
# se utilizaron los comandos Html_Table (), para extracción directa
# y html_node para extracción con nodos.

#EXTRACCIÓN DIRECTA

  # Extracción Ex CNC
TablaExCNA <- html_table(HtmlExCNA)  
print(TablaExCNA)
TablaLimpia1 <- TablaExCNA[[1]]
View(TablaLimpia1)
str(TablaLimpia1)
  
  #Extracción INDAP
TablaINDAP <- html_table(HtmlINDAP)
print(TablaINDAP)
TablaLimpia2 <- TablaINDAP[[1]]
View(TablaLimpia2)
str(TablaLimpia2)

#EXTRACCIÓN CON NODES

  #Extracción UNAF
TablaRemu <- html_node(HtmlGobRArauco, "#remuneraciones > table")
print(TablaRemu)
tablaleida <- html_table(TablaRemu)
View(tablaleida)
str(tablaleida)

  # Se destaca la existencia de ruido en esta tabla


####################### PASO 2 #######################
#   VISUALIZACIÓN, LIMPIEZA Y RESPALDO DE TABLAS     #


#La tabla extraida de UNAF presenta ruido, por lo que se procede a limpiarle,
# eliminando columnas con valores N/A,  fila con ruido y renombraron las columnas con valores "Xn"
# El resto de las tablas no presentó ruido


  #Se identificaron los nombres de columnas, para ser reemplazados. Se utilizó colnames() para identificar columnas,
# y names() para asignar la posición a reemplazar.

colnames(tablaleida)

names(tablaleida)[names(tablaleida) == "X1"] <- "Estamento"
names(tablaleida)[names(tablaleida) == "X2"] <- "Grado"
names(tablaleida)[names(tablaleida) == "X3"] <- "Unidad Monetaria"
names(tablaleida)[names(tablaleida) == "X4"] <- "Sueldo Base"
names(tablaleida)[names(tablaleida) == "X5"] <- "Incremento DL 3.501.art.2"
names(tablaleida)[names(tablaleida) == "X6"] <- "Asignación Responsabilidad Superior DL 1770/77"
names(tablaleida)[names(tablaleida) == "X7"] <- "Asignación Profesional Ley 19.185 Art.19"
names(tablaleida)[names(tablaleida) == "X8"] <- "Asignación Sustitutiva Ley 19.185 Art 18º"
names(tablaleida)[names(tablaleida) == "X9"] <- "Bonificación Ley 18.566 art. 3°"
names(tablaleida)[names(tablaleida) == "X10"] <- "Asignación Compensatoria Ley    Nº18.675 Art Nº 10"
names(tablaleida)[names(tablaleida) == "X11"] <- "Gastos de Representación DL    773/74"
names(tablaleida)[names(tablaleida) == "X12"] <- "A. de Zona"
names(tablaleida)[names(tablaleida) == "X13"] <- "Asignación de Modernización Ley 19.553"
names(tablaleida)[names(tablaleida) == "X14"] <- "Asig función Crítica"
names(tablaleida)[names(tablaleida) == "X15"] <- "Total Remuneración Bruta Mensualizada"

colnames(tablaleida)

# Se genera una nueva variable con la tabla a la que se eliminó la fila.
# Posteriormente, se eliminan las columnas de la variable sin fila, y se le asigna otra variable.
# esta es la tabla limpia.

tablaleida_modificada <- tablaleida[c(-1),]
View(tablaleida_modificada)

names(tablaleida_modificada)
TablaLimpia3 <-tablaleida_modificada[1:15]
names(TablaLimpia3)

View(TablaLimpia3)


# Una vez las tablas están limpias, se procede a respaldar los archivos en formato .csv
# Para ello se utilizó setwd() y write.csv()

  #DATA FRAME EX CNC
setwd("C:/Users/marti/OneDrive/Desktop/Data Depa")
write.csv(TablaLimpia1, file = "MArtin_Aguilar_R_ExCnC.csv")

# DATA FRAME INDAP
setwd("C:/Users/marti/OneDrive/Desktop/Data Depa")
write.csv(TablaLimpia2, file = "Martin_Aguilar_R_INDAP.csv")

  # DATA FRAME ARAUCO
setwd("C:/Users/marti/OneDrive/Desktop/Data Depa")
write.csv(TablaLimpia3, file = "Martin_Aguilar_R_ARAUCO.csv")




####################### PASO 3 #######################
#     EXPLORACIÓN Y VISUALIZACIÓN DE DATA            #

# A grandes rasgos, se puede deducir que los data frames corresponden a las remuneraciones de orgánicas gubernamentales.
# Los periodos detallados corresponden a los años 2018 y 2019.
# Las variables mas significativas fueron asignaciones por ley, grados laborales, número de empleados, cargos laborales y Regiones


# Se exploraron las tablas con el comando table()

#ALGUNAS VARIABLES GENERALES

table(TablaLimpia1$Año) 
table(TablaLimpia1$Mes)
table(TablaLimpia1$`Calificación profesional o formación`)
table(TablaLimpia1$`Fecha de inicio dd/mm/aa`)
table(TablaLimpia1$`Fecha de término dd/mm/aa`)
table(TablaLimpia1$`Grado EUS / Cargo con jornada`)

table(TablaLimpia2$Año)
table(TablaLimpia2$Mes)
table(TablaLimpia2$`Fecha de inicio dd/mm/aa`)
table(TablaLimpia2$`Fecha de término dd/mm/aa`)
table(TablaLimpia2$`Grado EUS / Cargo con jornada`)
table(TablaLimpia2$`Cargo o función`)

table(TablaLimpia3$Grado)
table(TablaLimpia3$`A. de Zona`)

########## GRAFICOS Y OTRAS VARIABLES  ##########


### GRÁFICOS E INFORMACIÓN EXCNA  ###

table(TablaLimpia1$Estamento) # El organismo está compuesto por 100 empleados, de los cuales; 33 administrativos, 56 profesionales y 11 técnicos.
ggplot(data = TablaLimpia1, aes(x=Región)) + geom_bar()+ coord_flip() + ggtitle("Empleados Ex CNA por Región")

table(TablaLimpia1$Región) # Las regiones con mayor n° de empleados son RM y Valparaiso
ggplot(data = TablaLimpia1, aes(x=Estamento)) + geom_bar()+ coord_flip() + ggtitle("Empleados por Estamento Ex CNA")

RM <- TablaLimpia1 %>% select(Región, Estamento) %>% filter(Región == "Región Metropolitana de Santiago")
VP <- TablaLimpia1 %>% select(Región, Estamento) %>% filter(Región == "Región de Valparaíso")
View(RM)
View(VP)

table(RM$Región)
table(RM$Estamento) # De los 100 empleados, 29 son de la RM; con tendencia laboral a Profesionales (24/29)
table(VP$Región)
table(VP$Estamento)# De los 100 empleados, 37 son de Valparaíso,con una distribución similar entre administrativos (17/37) y Profesionales (16/37)

ggplot(data = RM, aes(x=Estamento)) + geom_bar() + ggtitle("Estamentos Región Metropolitana")
ggplot(data = VP, aes(x=Estamento)) + geom_bar() + ggtitle("Estamentos Valparaiso")


table(TablaLimpia1$`Asignaciones especiales`) # EL organismo cuenta con 3 tipos de asignación; (33), (37) y (131)
ggplot(data = TablaLimpia1, aes(x=`Asignaciones especiales`)) + geom_bar() + ggtitle("Número de Asignaciones Ex CNA")

Asig_RM <- TablaLimpia1 %>% select(Región, `Asignaciones especiales`) %>% filter(Región == "Región Metropolitana de Santiago")
Asig_VP <- TablaLimpia1 %>% select(Región, `Asignaciones especiales`) %>% filter(Región == "Región de Valparaíso")
View(Asig_RM)
View(Asig_VP)

table(Asig_RM$`Asignaciones especiales`) # De los 29 empleados; 21 reciben la asignación (33) y 8 reciben la asignación (131)
table(Asig_VP$`Asignaciones especiales`) # De los 37 empleados;22 reciben la asignación (33) y 15 reciben la asignación (131)

ggplot(data = Asig_RM, aes(x=`Asignaciones especiales`)) + geom_bar() + ggtitle("Número de Asignaciones CNA/ RM")
ggplot(data = Asig_VP, aes(x=`Asignaciones especiales`)) + geom_bar() + ggtitle("Número de Asignaciones CNA/ Valparaíso")


table(TablaLimpia1$`Remuneración bruta mensualizada`) # El monto de los sueldos fluctua entre los [$750.000 : $3.425.000]

table(Remu_RM$`Remuneración bruta mensualizada`) # El sueldo en la RM fluctua entre los [$750.00 : $3.283.000]
table(Remu_VP$`Remuneración bruta mensualizada`) # El sueldo en Valparaíso fluctua entre los [$859.00 : $3.283.000]

Remu_RM <- TablaLimpia1 %>% select(Región, Estamento,`Remuneración bruta mensualizada`) %>% filter(Región == "Región Metropolitana de Santiago")
Remu_VP <- TablaLimpia1 %>% select(Región, Estamento,`Remuneración bruta mensualizada`) %>% filter(Región == "Región de Valparaíso")




### GRÁFICOS E INFORMACIÓN INDAP ###

table(TablaLimpia2$Región)# Las regiones con mayor n° de empleados son RM, Región del Maule y Región de los lagos
ggplot(data = TablaLimpia2, aes(x=Región)) + geom_bar()+ coord_flip() + ggtitle("Empleados INDAP por Región") 


RM2<- TablaLimpia2%>% select(Región, Estamento,`Remuneración bruta mensualizada`, `Asignaciones especiales`) %>% filter(Región == "Región Metropolitana de Santiago")
MAULE <- TablaLimpia2%>% select(Región, Estamento,`Remuneración bruta mensualizada`, `Asignaciones especiales`)%>% filter(Región == "Región del Maule")
LAGOS <- TablaLimpia2%>% select(Región, Estamento,`Remuneración bruta mensualizada`, `Asignaciones especiales`)%>% filter(Región == "Región de Los Lagos")

table(RM2$Estamento) # De los 100 empleados, 16 pertenecen a la RM, con una tendencia hacia los empleados profesionales
table(MAULE$Estamento) # De los 100 empleados, 16 pertenencen a la Región del Maule con tendencia hacia los empleados profesionales
table(LAGOS$Estamento) # De los 100 empleados, 13 pertenecen a la REgión de los LAGOS con tendencia a empleados profesionales


table(TablaLimpia2$Estamento) #EL organismo está compuesto por 7 administrativos, 70 profesionales y 23 técnicos.
ggplot(data = TablaLimpia2, aes(x=Estamento)) + geom_bar()+ coord_flip() + ggtitle("Empleados INDAP por Estamento") 

table(TablaLimpia2$`Asignaciones especiales`) #El organismo cuenta con 4 tipos de asignaciones; (01), (33), (37), (64)
ggplot(data = TablaLimpia2, aes(x=`Asignaciones especiales`)) + geom_bar() + ggtitle("Número de asignaciones INDAP")

table(RM2$`Asignaciones especiales`) # De los 16 empleados, 7 reciben asignación tipo (01) y 9 reciben asignación tipo (33)
table(MAULE$`Asignaciones especiales`) # De los 16 empleados, 4 reciben asginación(01), 1 reciben asignación (37), y 11 reciben (33) y (37)
table(LAGOS$`Asignaciones especiales`) # De los 13 empleados 3 reciben asignación (37), 5 reciben (33) y (37), y 5 recien (33)(37)(64)

table(TablaLimpia2$`Remuneración bruta mensualizada`) # El monto de los sueldos fluctua entre los [$785.000 : $3.590.000]

table(RM2$`Remuneración bruta mensualizada`) # El monto de los sueldos en la RM [$838.000 : $2.980.000]
table(MAULE$`Remuneración bruta mensualizada`)  # El monto de los sueldos en la Región del Maule [$838.643 : 2.603.000]
table(LAGOS$`Remuneración bruta mensualizada`)# El monto de los sueldos en la Región de Los Lagos [$836.000 : $ 2.837.000]


table(TablaLimpia2$`Grado EUS / Cargo con jornada`)
ggplot(data = TablaLimpia2, aes(x=`Grado EUS / Cargo con jornada`)) + geom_bar() + ggtitle("Cantidad de grados INDAP") 

grado_RM<- TablaLimpia2%>% select(Región, Estamento,`Grado EUS / Cargo con jornada`) %>% filter(Región == "Región Metropolitana de Santiago") 
grado_ML<- TablaLimpia2%>% select(Región, Estamento,`Grado EUS / Cargo con jornada`)%>% filter(Región == "Región del Maule")
grado_LGS <- TablaLimpia2%>% select(Región, Estamento,`Grado EUS / Cargo con jornada`)%>% filter(Región == "Región de Los Lagos")

table(grado_RM$`Grado EUS / Cargo con jornada`)
table(grado_ML$`Grado EUS / Cargo con jornada`)
table(grado_LGS$`Grado EUS / Cargo con jornada`)



### GRÁFICOS E INFORMACIÓN R.ARAUCO ###

table(TablaLimpia3$Estamento) # El organismo está compuesto por 4 administrativos, 1 auxiliar, 3 directivos, 7 profesionales y 3 técnicos 
ggplot(data = TablaLimpia3, aes(x=Estamento)) + geom_bar()+ coord_flip() + ggtitle("Empleados Gob. Regional ARAUCO ")

table(TablaLimpia3$Grado)
ggplot(data = TablaLimpia3, aes(x=Grado)) + geom_bar() + ggtitle("Cantidad de grados Gob.Reg.ARAUCO")

table(TablaLimpia3$`Sueldo Base`) #El suendo base fluctua entre los [$194.000 : $590.500[

table(TablaLimpia3$`Total Remuneración Bruta Mensualizada`) # El monto de los sueldos fluctua entre los [$737.000 : $5.089.000 ]



###################### PASO 4 ######################
#                 PREGUNTA EFECTUADA               #

# ¿ Es mejor remunerado el trabajo gubernamental en Santiago o en otras regiones?

  # Para responder esta pregunta nos basaremos en las estadísticas efectuadas en el "PASO 3"
# En la totalidad de los 3 organismos gubernamentales, contamos con 218 observaciones.
# De estos 218 empleados observados, existe un total de 45 empleados de la RM; 37 de la R. Valparaíso ; 28 en Arauco ; 16 en Maule y 16 en Los Lagos  
#  (Solo tomaremos las regiones con mayor numero de empleados)

# Se puede apreciar una tendencia de sueldos dada por;
table(RM2$`Remuneración bruta mensualizada`) # El monto de los sueldos en la RM [$838.000 : $2.980.000]
table(Remu_RM$`Remuneración bruta mensualizada`) # El sueldo en la RM fluctua entre los [$750.00 : $3.283.000]    
                                                      # Uniendo las 2 datas, la RM fluctua entre[$750.000 : 3.283.000]
table(Remu_VP$`Remuneración bruta mensualizada`) # El sueldo en Valparaíso fluctua entre los [$859.00 : $3.283.000]
table(MAULE$`Remuneración bruta mensualizada`)  # El monto de los sueldos en la Región del Maule [$838.643 : 2.603.000]
table(LAGOS$`Remuneración bruta mensualizada`)# El monto de los sueldos en la Región de Los Lagos [$836.000 : $ 2.837.000]

#Con respecto a los perfiles de los empleados:
table(RM2$Estamento) # De los 100 empleados, 16 pertenecen a la RM, con una tendencia hacia los empleados profesionales (10/16)
table(MAULE$Estamento) # De los 100 empleados, 16 pertenencen a la Región del Maule con tendencia hacia los empleados profesionales (11/16)
table(LAGOS$Estamento) # De los 100 empleados, 13 pertenecen a la REgión de los LAGOS con tendencia a empleados profesionales (9/13)
table(RM$Estamento) # De los 100 empleados, 29 son de la RM; con tendencia laboral a Profesionales (24/29)
table(VP$Estamento)# De los 100 empleados, 37 son de Valparaíso,con una distribución similar entre administrativos (17/37) y Profesionales (16/37)

#Con respecto a las asignaciones
table(RM2$`Asignaciones especiales`) # De los 16 empleados, 7 reciben asignación tipo (01) y 9 reciben asignación tipo (33)
table(Asig_RM$`Asignaciones especiales`) # De los 29 empleados; 21 reciben la asignación (33) y 8 reciben la asignación (131)
                                            # Uniendo las 2 data, RM: 7 tipo (01), 30tipo (33) y 8 tipo (131)
table(MAULE$`Asignaciones especiales`) # De los 16 empleados, 4 reciben asginación(01), 1 reciben asignación (37), y 11 reciben (33) y (37)
table(LAGOS$`Asignaciones especiales`) # De los 13 empleados 3 reciben asignación (37), 5 reciben (33) y (37), y 5 recien (33)(37)(64)
table(Asig_VP$`Asignaciones especiales`) # De los 37 empleados;22 reciben la asignación (33) y 15 reciben la asignación (131)


# En conclusión, existe un mayor pago en La Región Metropolitana y La Región de Valparaíso, en cuanto a sueldos menzuales brutos.
# Sin embargo, en lo referente a número de asignaciones, las regiones del sur superan considerablemente el monto y la cantidad de asignaciones.
# Existe una tendencia a la existencia de empleados con títulos profesionales en los puestos laborales públicos estudiados.
