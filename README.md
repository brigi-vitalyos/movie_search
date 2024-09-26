# Movies Search

## Prerequisites

To set up your development environment, you'll need to following:

- The appropriate version of Ruby, along with the Bundler gem
- Docker

## How to setup development environment
- Clone the repo
- Install the necessary gems
```
bundle install
```
- Start resources in Docker
```
docker compose up -d
```
- You need to create a .env file (copy from .env.test) and set up the MOVIE_API_KEY environment variable
- Start the rails server and check https://loaclhost:3000
```
bundle exec rails server
```
- You can run the tests with the following command:
```
docker compose up -d
```