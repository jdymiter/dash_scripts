# install.packages("odbc", "DBI") # USE ONCE IF LIBRARIES NOT FOUND

# library(DBI)
library(odbc)


# PROVIDE PATH TO A SERVER
server_path <- 'HH-SQL-ABCDEFG' # MAKE SURE DATA SOURCE IS SET UP FIRST!!!

# SOME VARIABLES REQUIRED FOR LATER
data <- data.frame()
all_files <- list()

# MAKE A CONNECTION TO THE SERVER
con <- dbConnect(odbc::odbc(), server_path, timeout = 10)

# BUILD YOUR QUERY SELECTING THE TABLES TO BE EXTRACTED
list_tables <- "select t.name
	from __YOUR_DATABASE__.sys.tables t 
	where t.name like '%__YOUR FILTER__%'"

# SAVE TABLE NAMES
tables <- odbc::dbGetQuery(con, list_tables)
rm(list_tables) # housekeeping

# GET DATA FROM ALL TABLES
for (i in 1:nrow(tables)) {
  query <- paste('select * from __YOUR_DATABASE__.dbo.', tables[i,1], sep = '')
  data <- as.data.frame(dbGetQuery(con, query))
  all_files[[i]] <- as.data.frame(data)
}
rm(data, query) # housekeeping

# OUTPUT PATH
path_out <- 'Z:/123/Project data/'

# SAVE CSVs
for (j in 1:length(all_files)){
  # CONCATENATE FILENAME
  filename <- paste(path_out, unlist(tables[j,1]), '.csv', sep='')
  # WRITE CSV INCLUDING COLUMN NAMES (NOT REALLY REQUIRED), DOUBLE QUOTES AND EXCLUDING ROW NAMES/NUMBERS
  write.csv(x = all_files[[j]], file = filename, row.names = F, col.names = T, quote = T, na = '')
}


# FOR CHECKING NUMBERS AND NAMES OF COLUMNS IN THE DOWNLOADED TABLES
# for(f in 1:length(all_files)){
#  cat(paste('\n\t\t',unlist(tables[f,1])))
#  cat(paste('\t', ncol(all_files[[f]])))
#  	for (t in 1:ncol(all_files[[f]])){
#  		cat(paste('\n',colnames(all_files[[f]][t])))
#  	}
#  }