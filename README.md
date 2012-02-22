# Configulations - You can have a simple configuration class for Ruby apps!

This is a bare bones, simple way to add configuration files to your ruby
apps using either json or yml. Then, you can simply call into the configurator like
any plain ol' Ruby object using the message passing dot syntax rather than
hash/ordinal accessors.

Included is a module called MagicHash that does all the magic mapping for the object.
It should be considered pretty dangerous as it augments the expected behavior of Hash.
To ensure as much flexibility without damaging Hash directly, configurator simply extends
the instance of the property bag so that we get the power of hash without messing up
hash for any one that is using it.

## EXAMPLE

by default, Configulations is going to recursively dive into a "config" directory located
by the location of the executing ruby process. from there, any files ending in .yml or .json
with the respetive content-types of YAML or JSON will be loaded. The name of the file is 
the first key and all properties can be fetched from there.

```ruby
config = Configulations.new #=> finds config/server.json and config/admins.yml
config.server.host #=> "localhost"
config.admins.include? User.find_by_name("leon") #=> true
```

Thanks to tonywok for starting the inheritance work... this is now possible: 

###structure:
```
config/
--application.yml   #=> (host: 'production.local')
--application/
-----development.yml #=> (host: 'development.local')
-----test.yml        #=> (host: 'test.local')
```

if each has a host... then you can call it like so...

```ruby
ENV["APP_ENV"] ||= "test" #=> current support vars are "RACK_ENV", "RAILS_ENV", "APP_ENV"
MyConfig.application.host.should == "test.local"
```

## Local Configuration

Sometimes configuration based on environment isn't enough. Configulations allows you to have
local configuration overrides for those times when you don't necessarily want everyone elses
config to be like yours. Just mirror the configuration hierarchy in `your_config/local`.

### Important

It's on you to put it in your .gitignore if you don't want it shared.

For example:

```
config/
--application.yml
--application/
----development.yml
--local/
----application.yml    # => (override application wide configs here)
----application/
------development.yml  # => (override applicaiton configs for development)
```

## Known Issues

* Right now data is first in- first out. If you have 2 config files with the same name
the last one in, wins.

## Future

This is all I needed for now but I'd love to work out those issues mentioned above
as well as allow for some robust Ruby configuration files that could take advantage
of run time-evaluation and flow control for those situations when you'd like to let
configuration be a bit more flexible than a yml, json file would allow.

## Contributing to configulations
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.
* This list is from Jeweler. Which is awesome...

## Contributors

Many thanks to anyone who sends patches, emails, love my way to keep this
software alive and a joy to maintain.

* github.com/tonywok
* github.com/al2o3cr (during pairing day at EdgeCase!)

## Copyright

Copyright (c) 2011 Leon Gersing. See LICENSE.txt for
further details.

