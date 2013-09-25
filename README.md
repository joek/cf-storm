Storm 
=====
The Open Source Web Console for Cloud Foundry
---------------------------------------------

Cf Storm is the open source web console for Cloud Foundry.
It allows to connect to any Cloud Foundry API endpoint,
for easy administration.
At the moment only it alllows to manage spaces and apps
but we are planning to add users, organizations and services
and more in the near future.

Tech details
------------

The web console is made using Cuba microframework, Redis, Ohm (Object-hash mapping library for Redis.)
Cutest abd Capybara for testing.

Why Cuba?
---------
The first answer that come to our minds is Why not?
Is simple, small and we think that it fits perfectly for this project
which is basically a GUI for an API. You can extend a Cuba app extremelly
easy, and not only that, it's very fast due to its small size.

We like to keep things simple and as small as posible to easily maintain
and improve our code, so that's why Cuba.

Install
=======

Performing this task is really simple. Just grab the code clonning the repository,
execute bundle install to download all dependencies (which are very few):

```
git clone git@github.com:Altoros/cf-storm.git
bundle install
```
Then you can either setup some env variables on your server

```
export REDIS_URL=redis://user:password@myredis.com:6379/0
export API_URL=http://mycfoundryapi.com
```


```
rackup
```

Then open a browser in http://localhost:9292/
