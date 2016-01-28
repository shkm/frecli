# FreCLI
Freckle CLI client in Ruby.

[![Gem Version](https://badge.fury.io/rb/frecli.svg)](https://badge.fury.io/rb/frecli)
[![Dependency Status](https://gemnasium.com/shkm/frecli.svg)](https://gemnasium.com/shkm/frecli)
[![Build Status](https://travis-ci.org/shkm/frecli.svg)](https://travis-ci.org/shkm/frecli)
[![Code Climate](https://codeclimate.com/github/shkm/frecli/badges/gpa.svg)](https://codeclimate.com/github/shkm/frecli)
[![Test Coverage](https://codeclimate.com/github/shkm/frecli/badges/coverage.svg)](https://codeclimate.com/github/shkm/frecli/coverage)

## What you can do with it right now

- Basic time tracking (start, pause, log)

I'd eventually like FreCLI to be a real alternative UI for interacting with Freckle, but have had to scale it down in the short-term due to time constraints. Currently, I'd like to get basic time tracking and logging nailed, as that's the most interesting functionality to me and those around me.

Having said that, I do intend to implement considerably more features. Also note that I'm working on the API client behind this, [freckle-api](https://github.com/shkm/freckle-api), as FreCLI is developed.


## Commands

### `frecli time`

Presents you with a list of projects. Simply enter the number of the project you'd like to time, and away you go.

### `frecli status`

Displays the time on the running timer, if there is one.

### `frecli pause`

Pauses the running timer.

### `frecli log [description]`

Logs the current timer, adding a description if one is given.


## TODO

- Project selection by name/alias/fuzzy
- Daily report (time logged, unlogged, total)
- More specs
- Log timers of other projects
- Deal with exceptions / errors
- Project selection via settings
- Caching
- Expanded reports (e.g. weekly, monthly, with natural time parsing)
- Various report outputs (e.g. stdout, csv, html)
- Administrative features
  - Project management
  - Invoices
  - Tags
  - Reports for other users

## Configuration

There are a couple of ways to configure FreCLI.

### Global

A 'global' configuration can be achieved through a `~/.frecli` file or directory. If `~/.frecli` is a file, FreCLI will parse it as YAML. If it's a directory, it will parse and merge settings for all files within.

### Cascading

frecli configuration always cascades down to the current directory. This means that if you have the following directory structure:

```bash
$HOME/
|-- .frecli # setting_one: foo, api_key: qwerty1234
|-- repos/
   |-- .frecli/
       |-- settings.yml # setting_one: bar
       |-- more_settings.yml # setting_two: 2 , api_key: asdf5678
   |-- project/
       |-- .frecli # project_setting: my_project

```

and you run FreCLI from `~/repos/project`, your settings will be as follows:

```yml
setting_one: bar
setting_two: 2
api_key: asdf5678
project_setting: my_project
```

This will become rather powerful. For example, if you're working on the same project as a team, settings relevant to the project can be added to the project's repository, and everyone in the team will benefit. Such a setting may be the project's ID (though this is not currently implemented), allowing anyone on the team to clock their time on the relevant project when running FreCLI from that project's directory.

### Settings

The following are available as settings.


#### `api_key` *required*
Your Freckle API key. You can get this from the [Freckle site](https://letsfreckle.com) under 'Integrations & apps' -> 'Freckle API'. Just click on 'Settings' next to 'Personal Access Tokens' and create a token for FreCLI.

If you commit your FreCLI settings — with your dotfiles, for example — you can use a more secure approach:

1. Set it as an environment variable: `export FRECKLE_API_KEY="YOURKEY"` in a file which is in your repo's ignore list.
2. Set it in a YAML file such as `~/.frecli/secrets.yml'`and add it to your repo's ignore list.

Note that for security, you can also set this as an environment variable, which is recommended. Simply add the following to your environment:

```
export FRECKLE_API_KEY="YOURKEY"
```

I prefer to put sensitive env variables in `~/.secrets`, with the following in my ~/.profile:
```
if [ -f "$HOME/.secrets" ]; then
  source $HOME/.secrets
fi

```

## Thanks
- My work, [Lico Innovations](http://lico.nl/) for using Freckle and employing the coolest kids in town (I'm the exception).
- The awesome Freckle developers — Thomas Cannon in particular — who shared interest in this project and even gave me a free account for testing!
