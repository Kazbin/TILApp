## Run the PostqreSQL Dev Database


```bash
docker run --name postgres -e POSTGRES_DB=vapor \
-e POSTGRES_USER=vapor -e POSTGRES_PASSWORD=password \
-p 5432:5432 -d postgres
```

