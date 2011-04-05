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

## 使い方

* [[OAuthヘルパー]] : OAuthに関する処理を行う
* [[OpensocialWap::Rack::OpensocialOauth]] : OAuthヘルパーを初期化し、シグネチャの検証をするRackミドルウェア
* [[クライアントヘルパー]] : APIサーバへにリクエストを送る
* [[URLの書き換え]]

### RailsアプリをOpenSocial WAP Extentionに対応させる

* [[Rails: OAuthヘルパー]] : リクエストの OAuth Signatureを検証する
* [[Rails: URLの書き換え]] : URLをOpenSocialコンテナ経由の形式に書き換える
* [[Rails: セッション]] : セッションを有効にする
* [[Rails: 設定例]]

## ライセンス