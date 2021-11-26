# Backend Interview Starting Point

This repo will serve as a starting point for your code challenge. Feel free to change anything in order to complete it: Change framework, other tests, new gems etc.

## Get this repo

- Fork this repo
- Clone your fork

## Prerequisites
- Have RVM installed: https://letmegooglethat.com/?q=install+rvm+on+ubuntu

## Local setup
1. Install ruby: `$ rvm install 3.0.2`
2. `$ cd .` or `$ cd <path_to_project>` to auto-create the rvm gemset
3. Install bundler: `$ gem install bundler`
4. Install the dependencies with bundler: `$ bundle install`

## Run sample CLI command
`$ bin/ruby-interview`

## Run tests
`$ bundle exec rspec`

## Tools

- Write HTTP APIs [rails](https://rubyonrails.org/) or [roda](https://roda.jeremyevans.net/documentation.html) or others
- Write CLI tools [thor](http://whatisthor.com/) or [tty](https://ttytoolkit.org/) or others (including [rake](https://github.com/ruby/rake))
- Test your code with [rspec](https://rspec.info/)

---

Good luck!

# Challenge

## Overview

You have been hired by a company that builds a app for coffee addicts.  You are 
responsible for taking the user’s location and returning a list of the three closest coffee shops.

## Input

The coffee shop list is a comma separated file with rows of the following form:
`Name,Y Coordinate,X Coordinate`

The quality of data in this list of coffee shops may vary.  Malformed entries should cause the 
program to exit appropriately. 

Your program will be executed directly from the command line and will be provided three 
arguments in the following order:
`<user x coordinate> <user y coordinate> <shop data url>`

Notice that the data file will be read from an network location (ex: https://raw.githubusercontent.com/Agilefreaks/test_oop/master/coffee_shops.csv)

## Output

Write a program that takes the user’s coordinates encoded as listed above and prints out a 
newline­separated list of the three closest coffee shops (including distance from the user) in 
order of closest to farthest.  These distances should be rounded to four decimal places. 

Assume all coordinates lie on a plane.

The output should be very simple no UI is required.

## Example

Using the [coffee_shops.csv](coffee_shops.csv)

__Input__

`47.6 -122.4 coffee_shops.csv`

__Expected output__

```
Starbucks Seattle2,0.0645
Starbucks Seattle,0.0861
Starbucks SF,10.0793
```

