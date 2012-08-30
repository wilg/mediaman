# Mediaman [![Build Status](https://secure.travis-ci.org/supapuerco/mediaman.png)](http://travis-ci.org/supapuerco/mediaman) [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/supapuerco/mediaman)

**Mediaman manages your media, man.**

Have video files you need to organize? DVD backups or something?

## Usage

Mediaman comes with a command line interface called, cleverly enough, `mediaman`. There's a few little commands for you.

#### Add to Library


    $ mediaman add ~/path/to/movie.mp4

This will take the video file at the passed in path and try to organize it into a library directory structure. Mediaman will try to figure out what the video file represents, and if it can, download metadata about the film or television show.

It does this based on a few simple rules:

- Movies

  If the filename contains text followed by a year, it's assumed to be a movie.

  For example: `Star Wars (1977)` or `star.wars.1977.stereo`.

- TV Shows

  If the filename contains season and episode number info, it's assumed to be a TV show.

  For example: `Star Trek The Next Generation S02E03`.

- Other Media

  Anything else is considered "Other Media".

The parsing logic is handled by the [ToName gem](https://github.com/o-sam-o/toname).

Then it will throw it into a pretty folder for you. Like this:

    ../Movies/Star Wars (1977).mov

or

    ../TV Shows/Star Trek - The Next Generation/Season 2/2x03 - Elementary, Dear Data.mov

The library root directory is your current directory, or pass in something else with the `-l` flag.

If it can, it will add the media's metadata (including artwork) to an `mp4` or `mkv` file using Subler.

The artwork image and metadata (in YAML format) will also be saved for your reference in an `Extras` folder in the same directory as the movie file.

#### Get Metadata Only

To view a YAML-formatted printout of as much metadata as Mediaman can muster, just use:

    $ mediaman metadata ~/path/to/movie.mp4

You can also just pass in a name:

    $ mediaman metadata "the truman show 1998"

#### Help

For more information, try:

    $ mediaman help

## Configuration

To download metadata, we currently use the [Trakt](http://trakt.tv) API, for which you can get a free key [through their website](http://trakt.tv/api-docs/authentication).

Mediaman looks for this information in the environment variable `TRAKT_API_KEY`.

On systems like OS X, the simplest way to have this stick around is to set this in your `~/.bash_profile` like so:

    export TRAKT_API_KEY=86f7e437faa5a7fce15d1ddcb9eaeaea377667b8

Want another service? Pull request please!

## Requirements

- OS X

  Tested only with OS X 10.8 Mountain Lion (so far).

- Ruby 1.9.x
  
  This is not the default Ruby shipped with Mountain Lion. You'll have to figure that one out yourself.

## Installation

Install as a Ruby gem:

    $ gem install mediaman

Or throw it in your Gemfile and use it directly from Ruby. Your move.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
