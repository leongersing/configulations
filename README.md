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

## Known Issues

* Right now data is first in- first out. If you have 2 config files with the same name
the last one in, wins.
* There is no inheritence. You can't set global options and then over-ride them with
another file.

You can however, augment the settings anytime you like. 

```ruby
config.admins.pop #=> gives one of our admins.
```

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

## Copyright

Copyright (c) 2011 Leon Gersing. See LICENSE.txt for
further details.

