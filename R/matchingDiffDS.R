#'@export
matchingDiffDS <- function(obj, rank, varName) {
  
  ranking <- jsonlite::fromJSON(rank, simplifyMatrix = FALSE) 
  recovery.obj <- eval(parse(text=obj))
  
  idx <- 1
  map <- list()
  tol = 1e-5
  for (value in ranking) {
    map[[idx]] <- recovery.obj[(which((abs(value - recovery.obj$dif)) <= tol)),]
    idx <- idx + 1
  }
  join <- do.call(rbind, map)
  join$complete_rows <- as.numeric(join$complete_rows)
  
  rows_to_impute <- unique(join$na_rows)
  
  x <- eval(parse(text=varName))
  missing_values <- which(is.na(x))
  
  values_to_impute <- x[rows_to_impute]
  
  dataset <- eval(parse(text="D"))
  newDataSet <- dataset
  
  newDataSet[which(rownames(newDataSet) %in% rows_to_impute), varName] <- values_to_impute
  
  
  
  # return(newDataSet)
  
  return(list(join=join, values_to_impute=values_to_impute, dataset=dataset))
}