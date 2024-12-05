# README

Starting local server command:
```rails s```

Example data for web input: 
```
C7 C6 C5 C4 C8
```

Example cURL request for API:
```
curl --location 'localhost:3000/api/v1/cards/check' \
--header 'Content-Type: application/json' \
--data '{
    	"cards": [
    			  "H9 H13 H12 H11 H10",
    			  "H9 C9 S9 H2 C2",
                  "C13 D12 C11 H8 H7"
    	]
    }
```
