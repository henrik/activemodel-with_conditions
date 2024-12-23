# ActiveModel::WithConditions

Adds `with_conditions` to Rails apps, or other projects using Active Model or Active Record.

`with_conditions` is like Active Support's [`with_options`](https://guides.rubyonrails.org/active_support_core_extensions.html#with-options), but only supports `:if` and `:unless`, and it merges these.

So you can do:

``` ruby
with_conditions(if: :feature_x_is_on?) do
  validate :free_plans_must_have_x, if: :free_plan?
end
```

It supports all forms of `:if` and `:unless` – symbols, lambdas (with or without a block argument), and arrays of the same.

## Compared to `with_options`

This improves on Active Support's `with_options`, where the inner `:if` would overwrite the outer one, and you'd need to work around it with something like:

``` ruby
with_options(unless: -> { !feature_x_is_on? }) do
  validate :free_plans_must_have_x, if: :free_plan?
end
```

You can still use `with_options` for other things (though this gem's author only ever uses it for validations and callback conditions). You could even combine them:

``` ruby
with_conditions(if: :feature_x_is_on?) do
  with_options(presence: true) do
    validates :x
  end
end
```

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add activemodel-with_conditions

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install activemodel-with_conditions

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome at <https://github.com/henrik/activemodel-with_conditions>.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
