# Search App

Using the provided data (tickets.json, users.json and organization.json) write a simple command line application to search the data and return the results in a human readable format. Where the data exists, values from any related entities should be included in the results. The user should be able to search on any field, full value matching is fine (e.g. “mar” won’t return “mary”). The user should also be able to search for empty values, e.g. where description is empty.

The test suite is a little flakey in spots at the moment, mostly around the integration side of the CLI app. A lot of stuff there serves around unit tests for the actual searching functionality. There's also a bit of room for some extension to move concerns out of places they shouldn't be, one

I've made a couple of assumptions about the application in regards to how things are implemented:

* `_id` is the primary key of all records.
* Array fields match the search term if they contain the entered value.

# Usage

Search App requires ruby and bundler to be installed. Before you begin; install the dependencies by running `bundle install`.

`bundle exec rake` will attempt to run the application.

# Tests

To run the test suite, you can run the command `bundle exec rspec`.



