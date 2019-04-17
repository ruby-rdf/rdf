# How to contribute

Community contributions are essential for keeping Ruby RDF great. We want to keep it as easy as possible to contribute changes that get things working in your environment. There are a few guidelines that we need contributors to follow so that we can have a chance of keeping on top of things.

## Development

This repository uses [Git Flow](https://github.com/nvie/gitflow) to manage development and release activity. All submissions _must_ be on a feature branch based on the _develop_ branch to ease staging and integration.

* create or respond to an issue on the [Github Repository](https://github.com/ruby-rdf/rdf/issues)
* Fork and clone the repo:
  `git clone git@github.com:your-username/rdf.git`
* Install bundle:
  `bundle install`
* Create tests in RSpec and make sure you achieve at least 90% code coverage for the feature your adding or behavior being modified.
* Push to your fork and [submit a pull request][pr].

## Do's and Dont's
* Do your best to adhere to the existing coding conventions and idioms.
* Don't use hard tabs, and don't leave trailing whitespace on any line.
  Before committing, run `git diff --check` to make sure of this.
* Do document every method you add using [YARD][] annotations. Read the
  [tutorial][YARD-GS] or just look at the existing code for examples.
* Don't touch the `.gemspec` or `VERSION` files. If you need to change them,
  do so on your private branch only.
* Do feel free to add yourself to the `CREDITS` file and the
  corresponding list in the the `README`. Alphabetical order applies.
* Don't touch the `AUTHORS` file. If your contributions are significant
  enough, be assured we will eventually add you in there.
* Do note that in order for us to merge any non-trivial changes (as a rule
  of thumb, additions larger than about 15 lines of code), we need an
  explicit [public domain dedication][PDD] on record from you.

[YARD]:    https://yardoc.org/
[YARD-GS]: https://rubydoc.info/docs/yard/file/docs/GettingStarted.md
[PDD]:     https://lists.w3.org/Archives/Public/public-rdf-ruby/2010May/0013.html
[pr]:      https://github.com/ruby-rdf/rdf/compare/
