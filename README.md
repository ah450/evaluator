Evaluator
=========


Node version `0.12.7`


Ruby version `2.2.4`


Check wiki for additional information.






Install backend app dependencies
================================
`bundle install`

Tests
=====

`bundle exec rake`



Install frontend app
====================
`cd client`


`npm install`


`bower install`


Building frontend
=================
All the following commands inside `client` directory.


run tests `npm run test`


deploy to /srv/www (default) `npm run deploy`


deploy in client/dist directory `npm run dist`






Run development version
=======================
Make sure db is created and migrated.


`bundle exec rails s &`


`cd client`


`npm run dev`


Development server is now running on port 8000


