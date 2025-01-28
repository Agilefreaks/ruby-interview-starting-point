<details>
  <summary><i>Local setup</i></summary>
    1. Install ruby: `$ rvm install 3.4.1`
    2. `$ cd .` or `$ cd <path_to_project>` to auto-create the rvm gemset
    3. Install bundler: `$ gem install bundler`
    4. Install the dependencies with bundler: `$ bundle install`
</details>

# Usage
#### Run CLI command to start the server
`$ bin/start`

#### Choose a provider to call the endpoind, I choose [Thunder Client](https://www.thunderclient.com/) inside VS Code. (Postman, Insomnia)
`http://localhost:9292/api/closest_shops?lat=47.6&lon=-122.4`
#### Should see a reponse similar to:
![image](https://github.com/user-attachments/assets/7b3f7d83-4b94-4e7a-b2c0-ad2452a09f84)


#### It can be also tested using the terminal
```curl "http://localhost:9292/api/closest_shops?lat=47.6&lon=-122.4"```
```
Coffee shops nearest (47.6, -122.4) by distance:

0.0645 <--> Starbucks Seattle2
0.0861 <--> Starbucks Seattle
10.0793 <--> Starbucks SF'
```

## Run tests
`$ bundle exec rspec`

### Disclaimers

- I thought about setting up a DB, querying the endpoint to seed it and then seeding it periodically.
- But taking into the consideration the size of the csv file, the minimal number of requests I choose to prioritize always having the latest data and calling the endpoint through my CoffeeShopFinderService on each request."
