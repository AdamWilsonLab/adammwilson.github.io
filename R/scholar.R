library(scholar)
library(jsonlite)
library(stringdist)

## Download google scholar citations
id="zgVlijsAAAAJ"
pubs=get_publications(id)
pubs$title=as.character(pubs$title)

## Download impactstory information
download.file("https://impactstory.org/api/person/0000-0003-3362-7806.json",
              destfile = "_data/is.json")
is=fromJSON("_data/is.json")

## Get fuzzy string matches
dm=stringdistmatrix(is$products$title,
                    pubs$title)
dm_min=apply(dm,
             1,
             min)

dm2=apply(dm,
          1,
          which.min)

dm2[dm_min>15]=NA

for(i in 1:length(is$products$title)){
  writeLines(paste(i,":    ",dm_min[i]))
  writeLines(pubs$title[dm2][i])
  writeLines(is$products$title[i])
}

is$products$citations=pubs$cites[dm2]
is$products$citationlink=as.character(pubs$cid[dm2])


is_out=prettify(toJSON(is,auto_unbox=T))
#is_out=enc2native(is_out)
is_out=iconv(is_out, "us-ascii", "us-ascii",sub="")

## write the file
write(is_out,
    file="_data/pubs.json")