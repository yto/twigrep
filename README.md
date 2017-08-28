# twigrep

Twitter API でキーワード検索して TSV 出力するコマンドラインスクリプト

```
twigrep -q QUERY [-dump] [-pages N]
```

- QUERY : 検索キーワード
- "-dump" : APIの結果を Date::Dumper で出力する
- pages : 出力ページ数の指定。デフォルトの 100件/1page だと MAX は 32。
- count : 1 page あたりの取得件数。デフォルトは 100。

API基本情報：最大取得件数：3200、取得期間：1週間前まで

ソース内で自分のベアラートークンを設定する必要あり（後述）

## 実行例

```
perl twigrep.pl -q 'RT @asahi'
milanonoko	2017-08-27 19:45:45	RT @asahi: 「ガンダム」生んだ名古屋テレビアニメ枠、９月で終了 https://t.co/A0pYrgWhgi
BeanbagPenguin	2017-08-27 19:45:41	RT @asahi: 金塊レプリカ窃盗、容疑者の車に現金数千万円 https://t.co/9VMDRzDGsg
ogakikayo	2017-08-27 19:45:26	RT @asahi: メルケル氏側「こんなことまで…」　米大統領からの電話 https://t.co/1FsykLCxVR
```

```
perl twigrep.pl -q '検索 Twitter API'
who_you_me_2012	2017-08-24 00:18:03	「API 変更」でTwitter検索かけるとやっぱりみんな混乱してるみたい
loftkun	2017-08-23 22:11:52	[夏研ブログ][不定期紹介] こんなブログ記事書いてます ツイキャスAPIを...
KoheiYamashita	2017-08-23 09:04:25	Twitterの公式って検索タブでジャンル的なカテゴリからツイート探せ...
```

## ベアラートークンの取得

bearer token を取得するスクリプト

```
get_bearer_token.pl
```

ソース内の $consumer_key と $consumer_secret に自分のを設定して実行すると Bearer Token がでてくる。

これを twigrep.pl の $bearer_token に設定する。

