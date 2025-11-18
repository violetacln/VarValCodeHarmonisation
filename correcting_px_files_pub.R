

#######----------------------------------------------------------
####### this script corrects the px-files by: 
####### replacing variable names, variable values, variable value codes with
####### the harmonised ones, according to the database table YYY.ZZZ_table
####### if needed and reporting on this action.
#######--------------------------------------------------------------


### reading into R a simplified version of the "dictionary-database" from the sql-database:
library(odbc)     
library(DBI)  
dbhandle <- RODBC::odbcDriverConnect('driver={SQL Server};server=XXX;database=YYY;trusted_connection=true')
df_harmon <- RODBC::sqlQuery(dbhandle, "SELECT distinct 
                             name_var, harmon_name_var,
                             names_var_values_all, harmon_name_var_values,
                             codes_var_values_all, harmon_codes_var_values
                             from YYY.ZZZ_table")

# Install and load the 'pxR' package if you haven't already
# install.packages("pxR")
library(pxR)

# --- Configuration ---
#file_path <- "your_px_file.px" # Replace with the actual path to your .px file
px_file <- "/Users/..../ex_educ_px.txt"
file.exists(px_file)
  
  
# --- Read the px-file ------
px_data <- read.px(px_file, na.strings="..", encoding="utf-8")



# --- Part 1: replace the names of variables, of variable values and of value-codes 
##            with the harmonised ones, into the px-object  ------------------------------


## variable names -------------------------------------------------
names(px_data$VALUES)

df_var_names <- data.frame(names(px_data$VALUES))
names(df_var_names) <- "names_px_data_VALUES"
## their NEW names are the harmonised names if exist or the original, unchanged if not:
## >>>>>>>>>>> to include the conclusion into a report-file -> to do *******************

df_var_map <-   sqldf::sqldf("select 
                            case when bb.harmon_name_var is not NULL then bb.harmon_name_var 
                            else aa.names_px_data_VALUES 
                            end as harmon_name_var,
                            case when  bb.harmon_name_var is not NULL then 'Replaced'
                            else 'Not_Replaced' end  as status_harmon_name_var,
                            aa.names_px_data_VALUES as original_name_var     
                          from df_var_names as aa left join df_harmon as bb 
                          on aa.names_px_data_VALUES = bb.name_var")


df_var_values <- list()
df_var_val_map <- list()
df_var_val_codes <- list()
df_var_val_codes_map <- list()

#####>>> for var_name in ... : ------------------------------------
for ( i in  1:dim(df_var_names)[1] ) {
          
       var_name <- df_var_names[i,1]
    
    df_var_values[[var_name]] <- data.frame( px_data$VALUES[[var_name]] )
    df_var_values[[var_name]]$names <- rep(names(df_var_values[var_name]), dim(df_var_values[[var_name]])[1] )  
    dfvv <- df_var_values[[var_name]]
    names(dfvv) <- c("var_values", "var_names")
    
    ## their new names are the harmonised ones if exist or the original unchanged if not:
    ## reminder: report into the report-file
    df_var_val_map[[var_name]] <- sqldf::sqldf("select 
                            case when bb.harmon_name_var_values is not NULL then bb.harmon_name_var_values 
                            else aa.var_values 
                            end as harmon_name_val,
                            case when  bb.harmon_name_var_values is not NULL then 'Replaced'
                            else 'Not_Replaced' end  as status_harmon_name_val,
                            aa.var_values as original_name_val     
                        from dfvv as aa left join df_harmon as bb 
                        on aa.var_names = bb.name_var and aa.var_values=bb.names_var_values_all")
    
  
        ## and for variables' values' codes: -------------
        # px_data$CODES[var_name]
        # df_var_val_codes[var_name] <- data.frame(px_data$CODES[var_name])
        ## their new names are the harmonised ones if exist or the original unchanged if not 
    df_var_val_codes[[var_name]] <- data.frame( px_data$CODES[[var_name]] )
    df_var_val_codes[[var_name]]$names <- rep(names(df_var_val_codes[var_name]), dim(df_var_val_codes[[var_name]])[1] )  
    dfvc <- df_var_val_codes[[var_name]]
    names(dfvc) <- c("var_val_codes", "var_names")
    
    df_var_val_codes_map[[var_name]] <- sqldf::sqldf("select 
                            case when bb.harmon_codes_var_values is not NULL then bb.harmon_codes_var_values 
                            else aa.var_val_codes 
                            end as harmon_code_val,
                            case when  bb.harmon_codes_var_values is not NULL then 'Replaced'
                            else 'Not_Replaced' end  as status_harmon_code_val,
                            aa.var_val_codes as original_code_val     
                        from dfvc as aa left join df_harmon as bb 
                        on aa.var_names = bb.name_var and aa.var_val_codes=bb.codes_var_values_all")
    
      }


## the element in the px-object about stubs
#px_data$STUB

## the element in the px-pbject about headings
#px_data$HEADING

## 
#px_data$DATA

##
#px_data$PRECISION


# --- Part 2: write the harmonised px-file, starting from the px-object -------------------
## check whether the original px-object gives the correct original px-file:
# write.px(px_data,  "/Users/.../ex_educ_px_writeTest.txt", 
#          write.na = TRUE, write.zero = TRUE, fileEncoding = "UTF-8")


###---or directly: --------------------------------
## replace everywhere in the text-file the string S1 with string S2 (although rather risky?), e.g.:
## modified_content <- gsub(string_to_replace, replacement_string, file_content, fixed = TRUE)
## where S1 is any of the original variable_name, variable_values, variable_value_codes
## and S2 is the harmonised pair of S1
##------------------------------------



