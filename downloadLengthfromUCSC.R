######################################################################
# Description: A script to download the gene Length (in bp) [and associated mapping where posssible] from UCSC web browser
#Notes: 
#Author: Nadia Davidson, Anthony Hawkins
#Date Modified: 8/3/2016
########################################################################

library(rtracklayer)

downloadLengthfromUCSC = function(genome,track){
  #make sure in rprofile: Sys.setenv(http_proxy="http://proxy1.ap.webscanningservice.com:3128")
  mySession <- browserSession()
  genome(mySession)<-genome

  if(track=="geneSymbol") #take the geneSymbols from refSeq genes
    query <- ucscTableQuery(mySession,"refGene")
  else
    query <- ucscTableQuery(mySession,track)
  
  transTable<-getTable(query)
  
  #### Table Contents - taken from UCSC website
  #string name;        	"Name of gene (usually transcript_id from GTF)"
  #string chrom;       	"Chromosome name"
  #char[1] strand;     	"+ or - for strand"
  #uint txStart;       	"Transcription start position"
  #uint txEnd;         	"Transcription end position"
  #uint cdsStart;      	"Coding region start"
  #uint cdsEnd;        	"Coding region end"
  #uint exonCount;     	"Number of exons"
  #uint[exonCount] exonStarts; "Exon start positions"
  #uint[exonCount] exonEnds;   "Exon end positions"
  #int score;            	"Score"
  #string name2;       	"Alternate name (e.g. gene_id from GTF)"
  #string cdsStartStat; 	"enum('none','unk','incmpl','cmpl')"
  #string cdsEndStat;   	"enum('none','unk','incmpl','cmpl')"
  #lstring exonFrames; 	"Exon frame offsets {0,1,2}"
  
  #Get the length information of each gene
  starts=strsplit(as.character(transTable$exonStart),",")
  ends=strsplit(as.character(transTable$exonEnd),",")
  exons=mapply(data.frame, starts, ends, SIMPLIFY=FALSE)

  #A function to extract length, i.e. subtract end and start basepair index to get number of bass pairs
  get_length<-function(x){ 
    #Note: The extra +1 is simply to get to the same as Matt
    sum(as.integer(as.character(x[,2]))-as.integer(as.character(x[,1])) + 1)  
  }
  
  lengths=sapply(exons,get_length)

  # First get transcript names (name - Usually transcript_id from GTF)
  transcript_names=as.character(transTable$name)
  
  #Now get gene names (name2 - Alternate name: e.g. gene_id from GTF)
  gene_names = as.character(transTable$name2)
  
  #Combine into dataset
  out_data =data.frame(Gene=gene_names,Transcript = transcript_names, Length=lengths)
  

  #Combine lengths grouped by gene name
  #split function converts the second argument to factors, if it isn't already one 
  #It internally sorts lexographically, so if you want to preserve the natural ordering need to
  #define your own factors
  #transcript_names <- factor(transcript_names,levels=unique(transcript_names))
  #gene_names <- factor(gene_names,levels=unique(gene_names))
  
  #There can be multiple entries for a given gene, so we need to group these together
  
  #Group the exome lengths by gene
  #data<-split(lengths,gene_names)
  
  #Group the transcripts by gene
  #data2 <- split(transcript_names,gene_names)

  #In order to assign just one length to each gene, we store the Median, Min Max 
  #and count of transcripts for each gene for later use
  #len=data.frame(Gene=names(data),Median=sapply(data,median),Min=sapply(data,min),
  #             Max=sapply(data,max),Count=sapply(data,length))
  
  #Make dataframe with Gene Name, Transcript Name and Median Gene Length
  #out_data =data.frame(Gene=names(data),Transcript = data2$, Length=len$Median)
  
  ############################
  ## Trouble Shooting
  ############################
  #Find out track names
  #track.names <- trackNames(ucscTableQuery(mySession))
  #Find out table names for track 1
  #table.names <- tableNames(ucscTableQuery(mySession,track=track.names[1]))
  
  #Save as RData
  file_string = paste(paste(genome,track,sep="."),"LENGTH.RData",sep=".")
  save(out_data,file=file_string)
  
  return(head(out_data))
}  