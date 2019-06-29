# CloudsignRubyApi

CloudsignRubyApiは、電子契約サービス「クラウドサイン」のAPIをRubyで扱いやすくしたAPIラッパーです。

# 問い合わせ

naoyanickf@gmail.com

https://twitter.com/fuji_syan

## 導入

Add this line to your application's Gemfile:

```ruby
gem 'cloudsign_ruby_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cloudsign_ruby_api

## 前提

基本的な考え方はクラウドサイン Web API 利用ガイドを参照してください。

https://help.cloudsign.jp/articles/2681259-web-api

その上で、

・クライアントIDの発行

・テンプレートの登録

をクラウドサインの管理画面から行っておいてください。

## 使い方

```
# 初期化
client = CloudsignApi.new('<YOUR CLIENT ID>')

# 動作確認
p client.documents
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/naoya0731/cloudsign_ruby_api.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
