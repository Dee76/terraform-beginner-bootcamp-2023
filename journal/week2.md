# Terraform Beginner Bootcamp 2023 - Week 2

## Table of Contents

## Working with Ruby

### Bundler

_Bundler_ is the package manager for the [_Ruby_ programming language](https://www.ruby-lang.org/en/).

It is the primary way to isntall Ruby packages (known as _gems_) for Ruby.

#### Install Gems

You need to create a `Gemfile` and define your gems in that file.

Example:

```ruby
source "https://rubygems.org"

gem 'sinatra'
gem 'rake'
gem 'pry'
gem 'puma'
gem 'activerecord'
```

Then you need to run the `bundle install` command.

This will install the gems on the system locally (unlike _Node.js_ which installs packages in place in a folder called `node_modules`).

A `Gemlock.file` will be created to lock down the Gem versions being used in this projects.

#### Executing Ruby Scripts via Bundler

We have to use `bundle exec` to tell future Ruby scripts to use the gems we installed. This is the way we set context.

### Sinatra

_Sinatra_ is a micro web-framework for Ruby to build web-apps.

It's great for mock or development servers or for very simple projects.

You can create a web server in a single file.

[Sinatra](https://sinatrarb.com/)

## TerraTowns Mock Server

### Running the Web Server

You can run the web server by executing the following commands:

```ruby
bundle install
bundle exec ruby server.rb
```

All of the code for our server is stored in the `server.rb` file.



:end:
