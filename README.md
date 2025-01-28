# Backend Interview Starting Point

This repo will serve as a starting point for your code challenge. Feel free to change anything in order to complete it: Change framework, other tests, new gems etc.


## Local setup
1. Install ruby: `$ rvm install 3.4.1`
2. `$ cd .` or `$ cd <path_to_project>` to auto-create the rvm gemset
3. Install bundler: `$ gem install bundler`
4. Install the dependencies with bundler: `$ bundle install`

## Run CLI command to start the server
`$ bin/start`

## Run tests
`$ bundle exec rspec`

## Tools


---
## Use
# Start the server: `$ bin/start`
# Choose a provider to call the endpoind, I choose Thunder Client in VS Code. (Postman, Insomnia)
`http://localhost:9292/api/closest_shops?lat=47.6&lon=-122.4`
# Should see a reponse similar to:


# Also can test from terminal
'curl "http://localhost:9292/api/closest_shops?lat=47.6&lon=-122.4"'
'Coffee shops nearest (47.6, -122.4) by distance:

0.0645 <--> Starbucks Seattle2
0.0861 <--> Starbucks Seattle
10.0793 <--> Starbucks SF'


## Disclaimer

# Authentication is not taken into account
# I did not deploy it anywhere

# I tought about setting up a DB, querying the endpoint to seed it and then seeding it periodically.
# But taking into the consideration the size of the csv file, the minimal number of requests I choose to prioritize always having the latest data and calling the endpoint through my CoffeeShopFinderServiceon each request
