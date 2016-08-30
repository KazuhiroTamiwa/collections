# collections
適当にあつめたサンプルスクリプトたち

## dfs_sample.py ##

深さ優先探索


## backtrace_sample.php ##

debug_backtrace() の結果をスリム化する.


## wordpress.sh ##

構築。個人的に非推奨


## ImportJSON ##

https://github.com/fastfedora/google-docs

Google Spreadsheet上でjsonを読み込む

## auto_incrementの歯抜けを治す
ただし、最後に自動採番値をリセットする必要がある
```
SET @N:=0;
UPDATE `table_name` SET id=@N:=@N+1 
ORDER BY id ASC;
```


## WordpressでメディアをあとからS3にする場合にすること
1. Offload S3 Liteのインストール
2. postsのアップデート
```
update wp_posts set post_content = replace(post_content, 'src="http://example.com/wp-content/uploads/', 'src="http://media.example.com/wp-content/uploads/');
```
3. 次のSQL分でinsert分を作成してから、全部実行する。
```
select CONCAT('insert into postmeta(post_id, meta_key, meta_value) values(', post_id, ', \'amazonS3_info\', \'a:3:{s:6:\"bucket\";s:ここにhogehogeの文字数:\"hogehoge\";s:3:\"key\";s:', length(CONCAT("wp-content/uploads/", meta_value)), ':\"wp-content/uploads/', meta_value, '\";s:6:\"region\";s:14:\"ap-northeast-1\";}\');') AS record from postmeta where meta_key = '_wp_attached_file'
```