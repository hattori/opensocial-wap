opensocial-wap は、[OpenSocial WAP Extension](http://opensocial-resources.googlecode.com/svn/spec/1.1/OpenSocial-WAP-Extension.xml) に準拠したアプリケーションを、簡単に開発するためのツールです。

mixiアプリモバイルをはじめ、GREE Platform for FeaturePhone、モバゲーオープンプラットフォームモバイル版などの OpenSocial プラットフォームは、OpenSocial WAP Extension にほぼ準拠しています。  
しかし、現状では、OAuth Signature の生成方法や URL のルールなどの点で、プラットフォーム毎に差異があります。  
opensocial-wap を使うことにより、それぞれの OpenSocial プラットフォームに合わせた実装を行う必要がなくなります。

## 機能

Sinatra などの Ruby ウェブフレームワークに組み込むことで、次の処理を簡単に行うことができます。

* OpenSocial コンテナ からのリクエストの OAuth Signatureの検証
* Restful API リクエスト用 OAuth Signature の生成
* OpenSocial コンテナ経由のURLの構築

さらに、Ruby on Rails を拡張して、Rails が構築する URL を、OpenSocial コンテナ経由のURLに書き換えます.

* link_to, button_to などのリンク系ヘルパー
* form_tag, form_for などのフォーム系ヘルパー
* リダイレクト先ロケーション
* 静的ファイルのパス

環境毎に、上記拡張の有効/無効を切り替えることができるので、通常の方法で開発した Rails アプリを、即座に OpenSocial WAP Extension に対応させることができます。

## インストール

Gemfile に`'opensocial-wap`を追加します。

```ruby
gem 'opensocial-wap', :git => 'https://github.com/hattori/opensocial-wap.git'
```

Bundlerでgemをインストールします。

```
$ bundle install
```

## 使い方

* [wiki](https://github.com/hattori/opensocial-wap/wiki)参照

## The MIT License

```
Copyright (c) 2011 Banana Systems Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```