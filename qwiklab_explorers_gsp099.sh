echo project = `gcloud config get-value project` > ~/.cbtrc

echo instance = quickstart-instance >> ~/.cbtrc

cbt createtable my-table

cbt ls

cbt createfamily my-table cf1

cbt ls my-table

cbt set my-table r1 cf1:c1=test-value

cbt read my-table

cbt deletetable my-table
