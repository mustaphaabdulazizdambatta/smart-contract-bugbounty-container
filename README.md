Clone the Docker Image `git https://github.com/mustaphaabdulazizdambatta/smart-contract-bugbounty-container`

create folder `cd smart-contract-bug-bounty`

Build the Docker Image `docker build -t bug-bounty-container .`

Run the Docker Image `docker run -it -p 8545:8545 -p 8080:8080 --name bug-bounty bug-bounty-container`

Root `docker exec -it --user root bug-bounty-container /bin/bash`
