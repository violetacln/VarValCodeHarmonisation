
## load the scraped data (e.g. called apimetaNNNNNN), which is first downloaded from web; or directly from url
## this file is produced by the R-tool at https://github.com/hansharaldss/pxmap/ 


pxlist <- apimetaNNNNNN
 

db_pxtables <- c()
for (i in 1:length(pxlist)) {
    
  name_i <- names(pxlist[i])
  node <- paste0("pxlist$", name_i )
  
  title_char <- paste0(node, "$pxweb_metadata$title")
  title <- eval(parse(text=title_char))
  
  url_char <- paste0(node, "$url")
  url <- eval(parse(text=url_char))   
  
  nvars <- length(eval(parse(text= paste0(node,"$pxweb_metadata$variables"))))
 
   for (iv in 1:nvars){
    name_var <- eval(parse(text=paste0( node,"$pxweb_metadata$variables[[", iv, "]]$text" )))
    code_var <- eval(parse(text=paste0( node,"$pxweb_metadata$variables[[", iv, "]]$code" )))
    names_var_values_all <- c(eval(parse(text=paste0( node,"$pxweb_metadata$variables[[", iv, "]]$valueTexts" ))))
    codes_var_values_all <- c(eval(parse(text=paste0( node,"$pxweb_metadata$variables[[", iv, "]]$values" ))))
    
    ddi <- data.frame( (cbind(names_var_values_all, codes_var_values_all, name_var, code_var, title, url) ))
    db_pxtables <- rbind(db_pxtables, ddi )
    
                     } 
}


### saving into a data-base-table 
 library(RODBC)   ### ---------------------
 dbhandle <- odbcDriverConnect('driver={SQL Server};server=XXXX;database=YYYYY;trusted_connection=true')
 sqlSave(dbhandle, db_pxtables)
###-----------------------



