# Dgidb::Rdf

RDF Converter for DGIdb

## Usage

### With docker

```
$ docker build --tag dgidb-rdf .
$ docker run --rm -d --name dgidb-pg postgres:10
$ docker run --rm -t --link dgidb-pg:db dgidb-rdf rake db:setup
$ docker run --rm -t --link dgidb-pg:db -v $(pwd)/output:/output dgidb-rdf dgidb convert --output /output

# clean up
$ docker stop dgidb-pg
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/med2rdf/dgidb-rdf. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Dgidb::Rdf project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/med2rdf/dgidb-rdf/blob/master/CODE_OF_CONDUCT.md).
