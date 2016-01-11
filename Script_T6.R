#-------------------------------------------------------------------------
#                 MAESTRIA EN CIENCIAS EN INFORMATICA
#-------------------------------------------------------------------------
#     ALUMNO    : CARLOS DANIEL MARTINEZ ORTIZ
#     MATERIA   : ALMACENAMIENTO DE DATOS Y SU ADMINISTRACION
#     PROFESOR  : M.EN C. EDUARDO RENE RODRIGUEZ AVILA
#     TAREA     : NO. 6
#-------------------------------------------------------------------------
#     NOTA: SE OMITEN ACENTOS
#-------------------------------------------------------------------------

# Creamos una Lista con los nombres de los paquetes que vamos a utilizar
PACKAGES <- list("base","utils","R.utils","R.oo","R.methodsS3")


# Muestra los paquetes que estan cargados
(.packages())

# A) Cargamos los paquetes necesarios en caso de que no esten cargados

  for (package in PACKAGES ) 
  {
    if (!require(package, character.only=T, quietly=T)) 
    {
      # Instalar paquete
      install.packages(package)
      cat("Paquete instalado:",package,"\n")
      
      # Cargar paquete
      library(package, character.only = TRUE)
      cat("Paquete cargado:",package,"\n")
    }
  }
  
# Muestra los paquetes que estan cargados
(.packages())

# B) Establece un directorio de trabajo
  setwd("C:/") 

# C) Valida la existencia y crea un directorio de descarga en caso de no existir

# Establece variable con el directorio
DIR_Desc <- "C:/ScriptT6/Descargas"

# Verifica y crea el directorio de Descarga
if( !file.exists(DIR_Desc) ) 
{
  dir.create(file.path(DIR_Desc), recursive=TRUE) 
  
  if( !dir.exists(DIR_Desc) ) 
  {
    stop("No existe directorio")
  }
}

# D) Valida la existencia de un directorio para los conjuntos de datos y lo crea de ser necesario.
DIR_Dat <- "C:/ScriptT6/Datos"

if( !file.exists(DIR_Dat) ) 
{
  dir.create(file.path(DIR_Dat), recursive=TRUE) 
  
  if( !dir.exists(DIR_Dat) ) 
  {
    stop("No existe directorio")
  }
}


# E) El script contara con la lista de los nombres de archivos a trabajar. 
#    Si el archivo no esta presente en el directorio de datos debera buscarse en el directorio de descarga, 
#    si no esta presente debera descargarse.
# F) Una vez descargado el archivo, y ya presente en el sistema debera descompactarse dejando 
#   el archivo de datos en el directorio apropiado.  


URL_file <- "http://www1.ncdc.noaa.gov/pub/data/swdi/stormevents/csvfiles/"

# Creamos una Lista con los nombres de los archivos que vamos a utilizar (1 DECADA)
FILES <- list("StormEvents_fatalities-ftp_v1.0_d2000_c20150826.csv",
              "StormEvents_fatalities-ftp_v1.0_d2001_c20150826.csv",
              "StormEvents_fatalities-ftp_v1.0_d2002_c20150826.csv",
              "StormEvents_fatalities-ftp_v1.0_d2003_c20150826.csv",
              "StormEvents_fatalities-ftp_v1.0_d2004_c20150826.csv",
              "StormEvents_fatalities-ftp_v1.0_d2005_c20150826.csv",
              "StormEvents_fatalities-ftp_v1.0_d2006_c20151230.csv",
              "StormEvents_fatalities-ftp_v1.0_d2007_c20151120.csv",
              "StormEvents_fatalities-ftp_v1.0_d2008_c20150826.csv",
              "StormEvents_fatalities-ftp_v1.0_d2009_c20151120.csv",
              "StormEvents_fatalities-ftp_v1.0_d2010_c20150826.csv" )

for( file in FILES )
{
  # Arma ruta de directorio de Datos
  DIR_A <- paste(DIR_Dat,"/",file,sep="")
  
  # Se valida si el archivo descompactado ya existe en el area de datos.
  if( !file.exists(DIR_A)) 
  {
    cat("NO EXISTE ARCHIVO EN DATOS:",file,"\n")
    # Arma ruta de directorio de Descargas
    DIR_B <- paste(DIR_Desc,"/",file,".gz",sep="")
    
    # Si no existe se busca el archivo compactado en el area de descarga.
    if( !file.exists(DIR_B) )
    {    
      cat("NO EXISTE ARCHIVO EN DESCARGA:",file,"\n")
      # Arma URL de para la descarga de los archivos
      URL_A <- paste(URL_file,file,".gz", sep="") 
      
      # Descarga de los archivos y los deja el el directorio Descargas
      download.file(URL_A, destfile = (DIR_B))
      cat("Archivo que se descarga:",file,"\n")
      
    }
    # Descomprime los archivos y los deja el directorio Datos
    gunzip(DIR_B,destname=DIR_A,remove = FALSE)
    cat("Archivo que se descomprime:",file,"\n")
    
  }  
}

  
# G) Una vez con todos los archivos presentes, se leeran todos los archivos, mostrando por cada uno
#    el numero de registros y estos archivos se fusionaran en una sola estructura de datos. 
#    Para esto ultimo es necesario considerar lo siguiente:
#    - La lectura de los archivos debe considerar dos casos: La lectura inicial, en la que la estructura
#      es inicialmente llenada con la lectura del primer archivo:
#    - Las lectura subsecuentes (la union de datos se logra empleando una variable temporal y la funcion rbind().):

# Establece un directorio para la lectura de los archivos
setwd("C:/ScriptT6/Datos") 

# Se elimina frame del consolidado de archivos en caso de que exista 
if (exists("Fatalities"))
{
  rm(Fatalities)
}

for( file in FILES )
{
  if( !exists("Fatalities" ) ) 
  {
    Fatalities <- read.csv( file = file, header=TRUE, sep=",", na.strings="")
    cat("Primer archivo agregado:", file," -Contiene un total de",nrow(Fatalities)," registros", "\n" )
    summary(Fatalities)
    
  }
  else 
  {
    data<-read.csv(file = file, header=TRUE, sep=",", na.strings="")
    Fatalities <- rbind(Fatalities,data)
    
    cat("Archivo subsecuente agregado:", file," -Contiene un total de",nrow(data)," registros", "\n" )
    summary(Fatalities)
    
  }
}

# H)  Al final se desplegarA el numero de registros del data frame creado, que debera ser la suma 
#     de los registros de cada archivo
cat("Archivo consolidado Final: Fatalities"," -TOTAL DE REGISTROS",nrow(Fatalities), "\n" )

# Se elimina la variable temporal.
rm(data)
