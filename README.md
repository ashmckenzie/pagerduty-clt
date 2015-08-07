# Pagerduty command line tool (CLT)

pagerduty-ctl is a command line tool that supports the following Pagerduty operations:

* Listing incidents, schedules and who is oncall
* Formatting options for Incidents - Table, CSV and JSON
* Acknowledge incidents
* Resolve incidents
* Reassign incidents
* Supports incident filtering
* Batch mode by default, specify `--interactive` to one-by-one
* YES mode (just do it, don't prompt)
* Console mode (pry session)

## Installation

There is no gem as yet so for now:

```shell
cd /tmp
git clone https://github.com/ashmckenzie/pagerduty-clt.git
cd pagerduty-clt
bundle install
bundle exec rake install
```

## Setup

You need a `${HOME}/.pagerduty_env` setup like:

```
PAGERDUTY_ACCOUNT_NAME="<FILL_ME_IN>"
PAGERDUTY_ACCOUNT_TOKEN="<FILL_ME_IN>"
PAGERDUTY_USER_ID="<FILL_ME_IN>"
```

* `PAGERDUTY_ACCOUNT_NAME` - the subdomain in `https://<account>.pagerduty.com`
* `PAGERDUTY_ACCOUNT_TOKEN` - your individual API token.  Visit `https://<account>.pagerduty.com/api_keys` and create a 'Full access' / write key.
* `PAGERDUTY_USER_ID` - needed so only incidents assigned to you are returned (unless you define the ```--everyone``` parameter).  It can be determined by clicking on your avatar in the top right hand corner and then inspecting the URL - `https://<account>.pagerduty.com/users/<user_id>`

## Usage

```shell
pd --help
Usage:
    pd [OPTIONS] SUBCOMMAND [ARG] ...

Parameters:
    SUBCOMMAND                    subcommand
    [ARG] ...                     subcommand arguments

Subcommands:
    s, schedules                  Schedules
    o, oncall                     Who is currently on call
    l, list                       List incidents needing attention (triggered + acknowledged)
    a, ack, acknowledge           Acknowledge incidents
    r, resolve                    Resolve incidents
    ra, reassign                  Reassign incidents

Options:
    -h, --help                    print help
    -c, --config_file CONFIG      Config file (default: "/Users/ash/.pagerduty_env")
    --version                     show version
```

## TODO

* Specs
* Upload to rubygems.org
* Support more incident data types
* Improve the way incident matching works
* Support `--format` (json, csv) when listing incidents
* Extract out TerminalTable

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ashmckenzie/pagerduty-clt. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
