# FreCLI
Freckle CLI client in Ruby.

[![Gem Version](https://badge.fury.io/rb/frecli.svg)](https://badge.fury.io/rb/frecli)
[![Dependency Status](https://gemnasium.com/shkm/frecli.svg)](https://gemnasium.com/shkm/frecli)
[![Build Status](https://travis-ci.org/shkm/frecli.svg)](https://travis-ci.org/shkm/frecli)
[![Code Climate](https://codeclimate.com/github/shkm/frecli/badges/gpa.svg)](https://codeclimate.com/github/shkm/frecli)
[![Test Coverage](https://codeclimate.com/github/shkm/frecli/badges/coverage.svg)](https://codeclimate.com/github/shkm/frecli/coverage)

## What it does right now

This is still very basic and in development, but some functionality works. I'm working on both this and the API client behind it ([freckle-api](https://github.com/shkm/freckle-api)) consecutively.

### `projects`

#### Aliases
- `projects`
- `project`
- `p`

#### Commands
- `c[urrent]` *default* show the project which currently has a running timer
- `a[ll]` - list all projects
- `s[how] - <id>` list the given project's attributes by its ID.

### `pimers`

#### Aliases
- `timers`
- `timer`
- `t`

#### Commands
- `c[urrent]` *default* show the timer which is currently running
- `a[ll]` - list all timers
- `s[how] <id>` - list the given timer's attributes by its ID.

### TODO next...
1. Commit a timer with a description
2. Test stuff.

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
- My work, [Lico Innovations](http://lico.nl/) for using Freckle :-)
- The awesome Freckle developers — Thomas Cannon in particular — who shared interest in this project and even gave me a free account for testing!
