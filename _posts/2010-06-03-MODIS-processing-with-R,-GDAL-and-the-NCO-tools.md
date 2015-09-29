---
layout: blog
title: "MODIS processing with R, GDAL, and the NCO tools"
teaser: "Open-source tools for MODIS processing"
category: blog
tags: [research]
imagefeature:
comments: true
share: true

---

I use MODIS data for analysis of vegetation dynamics around the world.  The native HDF file format provided by NASA is great for archiving the data (it's amazing how much information they include in each file), but unfortunately there aren't many tools for directly (and easily) extracting data stored across files like there are for the NetCDF format.  I wanted to be able to use the NCO tools to extract timeseries of a sub-setted region stored in many files.  This is quite easy with the ncrcat and similar NCO utilities.  The trouble is that the NCO tools require the data to be in netcdf3 or netcdf-4 classic to do this. I triedto use various HDF->netCDF conversion tools but eventually decided it was easiest to convert HDF->geotiff->netcdf.  The hierarchical nature of the HDF files makes them difficult to parse and so far the netcdf tools are not able to work with them unless they are 'flattened' to a single group.

So to use the NCO tools with MODIS data, I had to develop a processing routine that will convert them to netcdf-4 classic format.  This post will show you how.

I generally use R for my data processing and workflow scripting, though much of this could be done with shell scripting or other languages.  The code below is specific to my situation and will almost certainly require some editing if you want to use it.  I'm posting it to serve as general guidelines on how one might do this, not as a ready to use and generally applicable set of functions. I appreciate any suggestions on improvements.

First you need to identify which tiles you need by looking at the map:


Then run something like this to download the entire MOD13Q1 (vegetation indices) data from MODIS.  Get ready for lots of data (the following list of tiles results in 269GB!):

{% highlight r %}
 ### Some specifications  
 ftpsite="ftp://e4ftl01u.ecs.nasa.gov/MOLT/MOD13Q1.005/" #for veg index  
 hdffolder="1_HDF" #folder to hold HDF files  
 ofolder="2_netcdf" #this is where the output NetCDF files will go  
 bandsubset=paste(1) #keep only these bands from HDF file  
 regionbounds="49 113 30 146" # Set region boundaries for clipping  
 ## Get tiles to download - get these from the map  
 tiles=c("h25v04","h26v04","h26v05","h27v04","h28v04","h27v05","h28v05","h29v05") #list of tiles to download, they will be mosaiced and clipped later - format is important, see wget command below  
 ### download HDFs  
 ### Use wget to recursively download all files for selected tiles - will not overwrite unless source is newer  
 searchstring=paste("\"*",tiles,"*\"",sep="",collapse=",")  
  system(paste("wget -S --recursive --no-parent --no-directories -N -P",hdffolder," --accept",searchstring," --reject \"*xml\"",ftpsite))  
{% endhighlight %}

This will put all the files in the hdffolder (which I set to "1_HDF").  You now have each tile for time period as a separate file.  I find it convenient to mosaic the tiles and perhaps warp them to another projection and subset it to a smaller region than all of the tiles together.  To do this I use the following functions (note that some details are specific to extracting NDVI, if you want something else it will need to be edited).  The first converts a MODIS date code to the R date format:

{% highlight r %}modday2date<-function(i) as.Date(paste(c(substr(i,2,5),substr(i,6,9)),collapse="-"),"%Y-%j")
{% endhighlight %}

The second converts a geotiff to a netcdf with a single-date record dimension:

{% highlight r %}geotiff2netcdf=function(geotiff,output,date=NULL,startday=as.Date("2000-01-01"),varname="NDVI",scale=0.0001,missing=-3000,range=c(-1,1)){
  ## Create netcdf file from modistool geotiff output
  ##create file and open for editing
  ## convert Date
  utdates=as.numeric(date-startday)
  ## Read in geotiff to set netCDF attributes
  print(paste("Importing ",geotiff))
  x=readGDAL(geotiff)
  ## Set dimentions
  print("Defining NetCDF")
  create.nc(output,clobber=T)
  nc=open.nc(output,write=T) # Opens connection with netcdf file and write permission
  dim.def.nc(nc, "latitude", dimlength=x@grid@cells.dim[2], unlim=FALSE)
  dim.def.nc(nc, "longitude", dimlength=x@grid@cells.dim[1], unlim=FALSE)
  dim.def.nc(nc, "time", dimlength=length(utdates), unlim=TRUE)
  var.def.nc(nc,"time","NC_SHORT","time")
  var.put.nc(nc,"time",utdates, start=NA, count=NA, na.mode=0)
  att.put.nc(nc,"time", "units","NC_CHAR",paste("days since ",startday," 0",sep=""))
  att.put.nc(nc,"time", "standard_name","NC_CHAR","time")
  var.def.nc(nc,"longitude","NC_DOUBLE","longitude")
  att.put.nc(nc,"longitude", "units","NC_CHAR","degrees_east")
  att.put.nc(nc,"longitude", "standard_name","NC_CHAR","longitude")
  var.put.nc(nc,"longitude",seq(x@coords[1],x@coords[2],x@grid@cellsize[1]), start=NA, count=NA, na.mode=0)
  var.def.nc(nc,"latitude","NC_DOUBLE","latitude")
  att.put.nc(nc,"latitude", "units","NC_CHAR","degrees_north")
  att.put.nc(nc,"latitude", "standard_name","NC_CHAR","latitude")
  var.put.nc(nc,"latitude",seq(x@coords[3],x@coords[4],x@grid@cellsize[2]), start=NA, count=NA, na.mode=0)
  var.def.nc(nc,varname,"NC_SHORT",c("longitude","latitude","time"))
  att.put.nc(nc,varname, "missing_value","NC_DOUBLE",missing)
  att.put.nc(nc,varname, "units","NC_CHAR",varname)
  att.put.nc(nc,varname, "standard_name","NC_CHAR",varname)
  ## Process the data
  print("Processing data and writing to disk")
  notnull=x@data!=missing
  x@data[notnull][x@data[notnull]range[2]/scale]=missing #get rid of occasional weird value
  ## write the data to netCDF file
  var.put.nc(nc,varname,as.matrix(x)[,ncol(as.matrix(x)):1], start=c(1,1,1),count=c(x@grid@cells.dim[1],x@grid@cells.dim[2],1))
  close.nc(nc)
  print("Finished!")
 }
{% endhighlight %}

And the third puts it all together by first using the mrtmosaic tool to mosaic the tiles and subset to the band of interest, then using resample tool (available at the link above) to convert the HDF to a geotiff and then calling the function above to convert that to a netCDF:

{% highlight r %}
 ### Function to procss the files using the commands above.  
 modis2netcdf<-function(i,hdffolder,outputfolder,files,bandsubset=1){  
  tdir="/media/fynbos/public/tmp"  
  dir.create(tdir)  
  tparams=paste(tdir,"/",i,"_params.txt",sep="")  
  tmos=paste(tdir,"/",i,"_mosaic.hdf",sep="")  
  tclip=paste(tdir,"/",i,".tif",sep="")  
  ofile=paste(outputfolder,"/",i,".nc",sep="")  
  f=file.exists(ofile) # file exists?  
  if(f) print(paste(ofile," already exists, moving to next file...."))  # if exists, stop  
  if(!f) {  
  ## Mosaic and subset  
   fs=paste(hdffolder,"/",grep(i,files,value=T),sep="")  
  write.table(fs,file=tparams,row.names=F,col.names=F,quote=F)  
  system(paste("mrtmosaic -i ",tparams," -s ",bandsubset," -o ",tmos,sep=""))  
  ## Clip and reproject  
  if(!file.exists("ModisToolParams.prm")) {print("Parameter file missing, stopping process") ; stop}  
  system(paste("resample -p ModisToolParams.prm -i ",tmos," -o ",tclip," -t GEO -l \'",regionbounds,"\' -a INPUT_LAT_LONG -r CC",sep=""))  
  geotiff=paste(tdir,"/",i,".250m_16_days_NDVI.tif",sep="")  
  geotiff2netcdf(geotiff,output=ofile,date=modday2date(i))  
  file.remove(tmos,tclip,tparams); gc()  
  print(paste(which(dates%in%i), "out of ", length(dates)))  
 }}  
{% endhighlight %}

You can then run these functions to process a folder of HDF files with the following commands.  If you are on a *nix system with multiple cores, I recommend using the multicore package to parallelize the processing.  Otherwise you'll need to change the mclapply() below to lapply():

{% highlight r %}
 allfiles=as.character(list.files(path = paste(getwd(),hdffolder,sep="/"))) # build file list  
 dates=unique(do.call("rbind",strsplit(allfiles,".",fixed=T))[,2]) #get unique dates  
 type=do.call("rbind",strsplit(allfiles,".",fixed=T))[1,1] #get prefix of file type  
 band=1  
 ### Run the files - will not overwrite existing mosaics  
 mclapply(dates,modis2netcdf,hdffolder,outputfolder=ofolder,files=allfiles,bandsubset=band,mc.cores=8,mc.preschedule=F)  
{% endhighlight %}
Now you can use the NCO commands to extract a timeseries from these files, perhaps for only a subset of the data using ncrcat.
