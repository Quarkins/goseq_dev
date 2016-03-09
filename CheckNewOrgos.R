#A quick script to extract the tracks for a given organism
library(rtracklayer)

common = read.table("new_organisms.txt",stringsAsFactors = FALSE)

#Find available tracks for organisms
mySession <- browserSession()

get_tracks = function(x){
  genome(mySession) <- x[[1]]
  track.names <- trackNames(ucscTableQuery(mySession))
  return(track.names)
}

common$tracks = sapply(common$V1,get_tracks)

#Now produce the text file for specific tracks


avail <- vector()
for(i in 1:dim(common)[1]){
  if("knownGene" %in% unlist(common[i,2])) avail <- c(avail,paste(paste(common[i,1],"knownGene",sep="."),"Length.RData",sep="."))     
  if("ensGene" %in% unlist(common[i,2])) avail <- c(avail,paste(paste(common[i,1],"ensGene",sep="."),"Length.RData",sep="."))     
  if("refGene" %in% unlist(common[i,2])) avail <- c(avail,paste(paste(common[i,1],"refGene",sep="."),"Length.RData",sep="."))     
}   

write.table(avail_to_make, "NewToMake.txt", sep="\t",col.names = F, row.names = F,quote=F)