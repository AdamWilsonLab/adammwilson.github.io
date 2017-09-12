library(scholar)
library(tidyjson)
library(stringdist)
library(stringr)

## Download google scholar citations
id="zgVlijsAAAAJ"
pubs=get_publications(id)
pubs$title=as.character(pubs$title)

## Download impactstory information
download.file("https://impactstory.org/api/person/0000-0003-3362-7806.json",
              destfile = "_data/is.json")
is=read_json("_data/is.json")

validate(toJSON(is))

is2=is%>%
  spread_values(products=jstring("products"))%>%
  enter_object("products")%>%
  gather_array()%>%
  str()
  



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

if(F){
for(i in 1:length(is$products$title)){
  writeLines(paste(i,":    ",dm_min[i]))
  writeLines(pubs$title[dm2][i])
  writeLines(is$products$title[i])
}
}

is$products$citations=pubs$cites[dm2]
is$products$citationlink=as.character(pubs$cid[dm2])

# clean up double quotes in title fields
#lapply(is$products$posts,function(x) 

# clean up json
is_out=toJSON(is,auto_unbox=T,pretty=T,force=T)
#is_out=enc2native(is_out)
#is_out=iconv(is_out, "us-ascii", "us-ascii",sub="")
#is_out=gsub("[\\]","",is_out)
#is_out=gsub("href=\"","href='",is_out)
#is_out=gsub("\"\"","",is_out)
#is_out=gsub("\">","'>",is_out)

if(!validate(is_out)) stop("JSON is not valid")

## write the file
write(is_out,
    file="_data/pubs.json")
file.remove("_data/is.json")
