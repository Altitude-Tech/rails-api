# README

## Setup
* [Production](PRODUCTION_SETUP.md)
* [Development](DEVELOPMENT_SETUP.md)

## Running tests
To run the test suite:
```
$ rake test
```

## Run the development server
To start a development server:
```
$ rails server
```

## Rubocop
Rubocop is used to maintain code quality.

To run rubocop:
```
$ rubocop --rails
```

To send the result to `.rubocop_todo.yml`:
```
$ rubocop --rails --auto-gen-config
```

The generated config file can then be slowly worked through and corrected as needed.

To run rubocop with the config in `rubocop_todo.yml`:
```
$ rubocop --rails --config `.rubocop_todo.yml`
