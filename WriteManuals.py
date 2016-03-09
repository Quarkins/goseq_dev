#A quick script to write the manual entries for GeneLengthDatabase

f = open('NewToMake.txt','r')

for line in f:
	dataname = line.split('\n')[0]
	parts = dataname.split('.')
	print(parts)

	outname = "man/" + dataname + ".Rd"
	fout = open(outname, "w")
	
	#Now write the manual

	out_string = """\\name{{{dataname}}}
\docType{{data}}
\\alias{{{dataname}}}
\title{{Transcript length data for the organism {db} }}
\description{{ {dataname} is an R object which maps transcripts to the length (in bp) of their mature mRNA transcripts.  Where available, it will also provide the mapping between a gene ID and its associated transcripts.  The data is obtained from the UCSC table browser (http://genome.ucsc.edu/cgi-bin/hgTables) using the {track} table.
	
The data file was made by calling downloadLengthFromUCSC({db}, {track}) on the date on which the package was last updated.}}
\seealso{{
\code{{\link{{ downloadLengthFromUCSC }}}}}}
\examples{{
data({dataname})
head({dataname})
}}
\keyword{{datasets}}"""

	context = {
		"dataname":dataname,
		"db":parts[0],
		"track":parts[1]
	}

	fout.write(out_string.format(**context))

	fout.close()
