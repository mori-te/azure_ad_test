# 起動方法

## Azure ADのセットアップ
Azure portalでAzure ADを設定、アプリ登録を実施しする。

## configファイル作成
config.jsonファイルを作成し以下を記述
```json
{
    "CLIENT_ID": "アプリケーション（クライアント）ID",
    "CLIENT_SECRET": "クライアントシークレット値",
    "TENANT": "ディレクトリ (テナント)名（任意）",
    "TENANT_ID": "ディレクトリ (テナント) ID"
}
```

## 必要なモジュールのインストール
```bash
$ gem install webrick
$ gem install sinatra
```

## テストWEBアプリ起動
```bash
$ ruby azure_ad_sample.rb
```

## WEBアプリアクセス
```
http://localhost:4567/
```
