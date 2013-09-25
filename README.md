Storm
=====
The Open Source Web Console for Cloud Foundry
---------------------------------------------

Cf Storm is the open source web console for Cloud Foundry.
It allows to connect to any Cloud Foundry API endpoint,
for easy administration.
At the moment only it alllows to manage spaces and apps
but we are planning to add users, organizations, services
and more in the near future.

Tech details
------------

The web console was created using Cuba microframework, Redis, Ohm (Object-hash mapping library for Redis.)
Cutest abd Capybara for testing.

Why Cuba?
---------
The first answer that come to our minds is Why not?
**Is simple, small and we think that it fits perfectly for this project**,
which is basically a GUI for an API. 
You can extend a Cuba app extremely easy, and not only that, 
it's very fast due to its small size.

**We like to keep things simple and as small as posible** to easily maintain
and improve our code, so that's why Cuba.

Install
=======

Performing this task is really simple. Just grab the code clonning the repository,
execute bundle install to download all dependencies (which are very few):

```
git clone git@github.com:Altoros/cf-storm.git
bundle install
```
Then you can either setup some env variables on your server like this:

```
export REDIS_URL=redis://user:password@myredis.com:6379/0
export API_URL=http://mycfoundryapi.com
```

Or you can edit the file env.sh with your information:

```
REDIS_URL=redis://user:password@myredis.com:6379/0
API_URL=http://mycfoundryapi.com
```

We recommend you export these variables to not alter the code. You can
add these exports in some .bashrc file or something.

Finally, you can run:

```
rackup -p 9393
```

Or:

```
shotgun
```

To run the console. You can chose a port of your interests, the default port
for rackup is 9292, and for shotgun is 9393.

The difference between rackup and shotgun is subtle. Shotgun reloads classes
and other code on each requests, perfect for a development enviorement, and
rackup does not do that, perfect for a production enviorement.

In a browser type the URL http://localhost:9393/ or http://localhost:9292/
and you're ready to go.

How to Contribute
=================

The Basics
----------

Since Cuba was the prefered framework, contributing is easy, and we encourage
you to do so for a better console for everyone.

The Cuba infrastructure is really simple. You can define a file that acts as a
route matcher and controller, in where you define all the routes of your extension
and actions to do upon call. Here is an example:

```
class MySection < Cuba
  define do
    on get, 'index' do
      res.write view('my_section/index')
    end
  end
end
```

We just defined a section with an index action that renders a view. Once you
have your awesome functionalities coded in one (or several) files like the
example avobe, you need to integrate it with the console, this is a tricky
part, but not really difficult.

Matchers scope routes nesting Cuba applications. The file app.rb defines
the root level '/' of the entire application. Each 'on' statement in this
file defines a subroute, for example:
```
Cuba.define do
  on 'favicon.ico' do
  end
end
```

This defines a subroute 'favicon.ico', so a route that will match this code
is '/favicon.ico'. So to integrate your awesome section with the console, you
can do something like this:

```
require_relative './my_section'
Cuba.define do
  on 'my_section' do
    run MySection
  end
end

```

This will create a route like '/my_section/index' (remember the section defined avobe).
Also, this will match all routes with '/my_section' and pass it to MySection class to
handle it.

Verbs
-----

You can use proper HTTP verbs like DELETE, PUT, etc. To use one of those you simple
pass it as parameter while defining the section:

```
class MySection < Cuba
  define do
    on delete, 'index' do
      res.write view('my_section/index')
    end
  end
end
```
All HTTP verbs works, and if you use them, you'll follow more properly the
protocol definition, and of course you'll make it easier for other people
to understand your code.

Cuba docs
=========

- http://cuba.is/
- https://github.com/soveran/cuba

Some cuba example apps
----------------------

- https://github.com/citrusbyte/cuba-app/
- https://github.com/punchgirls/job_board/

Tests
=====

In CF-Storm we use TDD for the development cycle, writing a test and
then coding the feature that passes the test. In the folder 'test' you wil
find the acceptance and unit tests for this application. However, **we were
not fanatized to the extreme with TDD, simply because adding more tests
slows down the overall process**.

If you decide to contribute to CF-Storm, make sure you write any necesary
test for any new feature you add and make them pass properly.

The console uses a cfoundry client gem which makes the requests needed
for everything implemented on CF-Storm, from getting spaces to scale applications
deployed on the server, validating all data along the way. Since there are
requests going on while using the console, there's a small delay on each
request. Writing tests and making all these requests slows down the running
speed of tests. We don't want that, so we should use the mocks.

BUT, **we don't use mocks for the testing, and this is because mocks aren't that
easy to maintain and reduces the clarity of tests**, instead, we fake the client 
with several classes to speed up the running. These classes are located on the 
'lib' folder. Add any necesary methods to the fake classes if you need them 
for your awesome features.

There are also integration tests available that runs agains a real API, be
aware that doing this will dramatically slow down the running.

The commands to run these tests are these:

```
rake
```

This will run the tests using the fake classes doing a fast run over all tests,
you can specify a kind of tests to run by doing:

```
rake test:acceptance
```

Finally, there are benchmark tests to measure the speeds, this is usefull
to verify the response speeds of the overall console. If you contribute,
we encourage you to run these tests and verify that there are not significant
increase in response times:

```
rake test:benchmark
```
These kind of tests are tied to the overall performance of the computer
they are running on, so before you start creating your awesome feature,
run these tests once and keep track of changes.
