# Pagerduty CLT

## Installation

Add this line to your application's Gemfile:

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
    o, oncall                     Who is currently on call
    s, schedules                  Schedules
    l, list                       List incidents needing attention (triggered + acknowledged)
    a, ack, acknowledge           Acknowledge incidents
    r, resolve                    Resolve incidents

Options:
    -h, --help                    print help
    -c, --config_file CONFIG      Config file (default: "/Users/ash/.pagerduty_env")
    --version                     show version
```

### list

```shell
$ pd list --help
Usage:
    pd list [OPTIONS]

Options:
    --everyone                    All incidents, not just mine (default: false)
```

### ack

```shell
$ pd ack --help
Usage:
    pd ack [OPTIONS] PATTERN

Parameters:
    PATTERN                       pattern to match (on node)

Options:
    --everyone                    ALL incidents, not just mine (default: false)
    --batch                       Non-interactively acknowledge (default: false)
    --yes                         Don't confirm, just do it! (default: false)
```

### resolve

```shell
$ pd resolve --help
Usage:
    pd resolve [OPTIONS] PATTERN

Parameters:
    PATTERN                       pattern to match (on node)

Options:
    --everyone                    All incidents, not just mine (default: false)
    --batch                       Non-interactively acknowledge (default: false)
    --yes                         Don't confirm, just do it! (default: false)
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ashmckenzie/pagerduty-clt. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
