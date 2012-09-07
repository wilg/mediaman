# Mediaman [![Build Status](https://secure.travis-ci.org/wilg/mediaman.png)](http://travis-ci.org/wilg/mediaman)  [![Dependency Status](https://gemnasium.com/wilg/mediaman.png)](https://gemnasium.com/wilg/mediaman) [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/wilg/mediaman)

**Mediaman manages your media, man.**

Have video files you need to organize? DVD backups or something? Need to do some batch operations? Get everything in order. Mediaman has you covered.

## Command-Line Usage

Mediaman comes with a command line interface called, cleverly enough, `mediaman`. There's a few little commands for you.

### Add to Library (`mediaman add`)

The add command will probably be what you use the most. It does a few things:

1. Figures out what type of media this file represents.

2. Puts it in a simple, easily navigable folder structure.

3. Downloads metadata and artwork about the video and saves it.

4. (Optionally) Adds the video to iTunes.

#### Usage

    $ mediaman add ~/movie/file/or/folder
    
Interesting options:

- `--batch` or `-b`: Adds each file or folder in the passed-in folder to the library. (Not recursive.)
- `--library` or `-l`: : Media library base folder to sort into. (Defaults to `.`)
- `--itunes`: Tries to add the video file to iTunes after all is said and done.

#### Understanding the Media

The **[ToName gem](https://github.com/o-sam-o/toname)** is responsible for the majority of this smartness, but it can't guess everything.

Here's the general way Mediaman categorizes media files:

- **Movies**: Text followed by a four-digit year.

  For example: `Star Wars (1977)` or `star.wars.1977.stereo`.

- **TV Shows**: A name followed by season and episode number information.

  For example: `Star Trek The Next Generation S02E03` or `Psych 3x02`.

- Anything else is considered **Other Media**.

#### Library Folder Structure

Once it figures out what your media is it will throw it into a pretty folder for you. Like:

    ~/Movies/Star Wars (1977).mov
    ~/TV Shows/Star Trek - The Next Generation/Season 2/2x03 - Elementary, Dear Data.mov
    ~/Other Media/Information About Sharks.pdf

If it can, it will add the media's metadata (including artwork) to an `mp4` or `mkv` file using [MiniSubler](https://github.com/supapuerco/mini_subler).

The artwork image and metadata (in [YAML format](http://www.yaml.org)) will also be saved for your reference in an `Extras` folder in the same directory as the movie file.

### Viewing Metadata (`mediaman metadata`)

To view a YAML-formatted printout of as much metadata as Mediaman can muster, just use:

    $ mediaman metadata ~/path/to/movie.mp4

You can also just pass in a name:

    $ mediaman metadata "the truman show 1998"

### Help (`mediaman help`)

For more information, there's some help and whatnot available too.

## Configuration

To download metadata, we currently use the [Trakt](http://trakt.tv) API, for which you can get a free key [through their website](http://trakt.tv/api-docs/authentication).

Mediaman looks for this information in the environment variable `TRAKT_API_KEY`.

On systems like OS X, the simplest way to have this stick around is to set this in your `~/.bash_profile` like so:

    export TRAKT_API_KEY=86f7e437faa5a7fce15d1ddcb9eaeaea377667b8

Want another service? Pull request please!

## Requirements

- **OS X**

  Tested only with OS X 10.8 Mountain Lion (so far).

- **Ruby 1.9.x**
  
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
