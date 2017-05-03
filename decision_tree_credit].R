library(data.table)

credit<- fread("credit.csv",header = TRUE)
dest_id_hotel_cluster_count <- train[,length(is_booking),by=list(srch_destination_id, hotel_cluster)]
