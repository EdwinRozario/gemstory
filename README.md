# Gemstory
Gemstory tells the history of the Gems in your project. Its a command line tool that will read the history of the Gemfile.lock and project the output in terminal.

## Installation

    $ gem install gemstory

## Usage

Run `gemstory` in your project root folder. This will return the history of Gem upgrades of the project.

#### Options

A single Gem name can be passed as an option. This will return detailed information about the Gem's history, commits and authors.

`gemstory rails`

Or multiple Gems can be passed as options so that history can be compared.

`gemstory rails thin`

## Development

More CLI options are under construction. Output can be a json file or an HTML file in the future.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/EdwinRozario/gemstory. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Gemstory project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/gemstory/blob/master/CODE_OF_CONDUCT.md).
