###################################
# Description: A little script to reproduce the dataset used for geneLenDataBase
# Author: Anthony Hawkins
# Date last mdoified: 07/03/16
####################################

source("downloadLengthfromUCSC.R")

library(limma)  
#Read in file with common tables
common = read.table("myfiles.txt",stringsAsFactors = FALSE)

tmp = strsplit2(common[,1],"[.]")
common_df = data.frame(Genome=tmp[,1], track =tmp[,2])


  #Make the function which produces an RData with gene length info
make_data<-function(x){ 
  downloadLengthfromUCSC(x[[1]],x[[2]])
}

  #Now create the files
apply(common_df,1,make_data)

#common_df

