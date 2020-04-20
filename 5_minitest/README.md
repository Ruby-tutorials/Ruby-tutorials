# この章について

この章では、このチュートリアルにおいて極めて重要である演習問題の解き方について解説します。演習問題は`MiniTest`というフレームワークを通じて行われます。これまでに学んできたオブジェクトやメソッド、変数などの概念を使って実際にテストコードを読解し、コードを記述していきます。

# MiniTest

`MiniTest`はRubyとともにインストールされる（別途のインストールが不要の）テストツールです。MiniTestを使うことで、プログラムが期待通りの動作をしていることを確かめながらプログラムを記述することができます。

### おまけ：gemについて

MiniTestのようなプログラムは一般的に「ライブラリ」と呼ばれます。Rubyの世界では、ライブラリは`gem`と呼ばれることが多いです。

gemを使うことで一般的な問題の多くをプログラムを書くことなしに解決することができます。コマンドラインから（例えば）`gem install rails`と実行すると`rails`という名前のgemをインストールすることができます（繰り返しになりますが、MiniTestは個別にインストールする必要がありません）。

## テストについて

このチュートリアルを通じて、「テスト」という単語は特に断りがなければ「自動テスト」を意味します。「自動テスト」というのは、プログラムの正しさを別のプログラムを使うことで検証する、ぐらいの意味に捉えてください（プログラムを使うということは人間の手を借りずに「自動で」テストを行えるということになります）。

## MiniTestの記述法

MiniTestでは、通常のRubyと同様にクラスとメソッドを定義することでテストを作成していきます。以下のコードを見てください。

```ruby
require 'minitest/autorun'

class MyTest < MiniTest::Test
  def test_one_plus_one_equals_two
    assert_equal 2, 1 + 1
  end
end
```

以下、順に解説していきます。

### require

`require`はRubyにおける重要な仕組みの一つで、他のファイルからプログラムを読み込むことができます。MiniTestを使うためには`require 'minitest/autorun'`の行が必要となります。

`require`については後ほど説明します。

### MiniTest::Testを継承したクラスを定義する

`class`キーワードについてはすでに取り上げていますが、ここでは見慣れない記法が多く登場していますね。

`<`の記号は「継承」を意味します。継承についてはクラス継承を扱った章で取り上げますが、継承とは端的に言うと「機能を受け継ぐ」機構です。この場合、`MiniTest::Test`というクラスの機能を受け継いだ新しいクラスを作っているわけです。

`MiniTest::Test`の`::`という記号は今のところはおまじない程度に考えていただいて大丈夫ですが、一応解説すると「ネームスペース」を意味します。単に`Test`とだけ書くと他の名前と衝突してしまう（同じプログラム中で同じ名前を異なる意味で使うことはできない）ので、「これはMiniTestが使っている意味のTestだよ」ということを示すために`MiniTest::Test`と書くわけです。

### テスト定義

`def`はメソッドの定義でしたね。MiniTestというツールは`test_`で始まるメソッドを自動的に認識し、テストとして実行してくれます。

`assert_equal`というのはなんだか変わった名前ですが、これはカンマの左と右が一致することを確かめるための方法です。`assert`で始まるメソッドを総称して「アサーション」と呼びます（日本語でいうと「断言」ですが、要は「こうであるはず」という表明ですね）。この場合、`1 + 1`の結果が（当然）`2`になることを検証しています。

## MiniTestの実行法

MiniTestの実行については、通常のRubyファイルの実行方法と何ら変わりありません。上のテストの内容を`my_test.rb`と名付けたファイルに保存して`ruby my_test.rb`で実行してみます。

何が起こったでしょうか？おそらく以下のような出力になったと思います。

```
Run options: --seed 27489

# Running:

.

Finished in 0.001130s, 884.9558 runs/s, 884.9558 assertions/s.
1 runs, 1 assertions, 0 failures, 0 errors, 0 skips

```

これはテストの成功を示しています。私達は`1 + 1`が`2`であることを自動テストによって検証しました！

これだけだと面白くないですか？では、`2`を`3`に置き換えてみましょう。結果が変わりますね。

```
Run options: --seed 30378

# Running:

F

Failure:
MyTest#test_one_plus_one_equals_two [my_test.rb:5]:
Expected: 3
  Actual: 2


rails test my_test.rb:4



Finished in 0.002777s, 360.1008 runs/s, 360.1008 assertions/s.
1 runs, 1 assertions, 1 failures, 0 errors, 0 skips
```

これはテストの失敗を示しています。真ん中あたりに期待される結果と実際の結果が書いてありますね。このように、自動テストを使うとプログラムの実際の結果と期待される結果を比較しながらプログラムを記述することができます。

## `String`クラスの`first`メソッドをテストする

以下のテストコードを見てください。

```ruby
require 'minitest/autorun'

class StringFirstTest < MiniTest::Test
  def test_string_first
    assert_equal "I", "I love Ruby.".first
  end
end
```

ここまで来た皆さんなら読めますね？このテストでは私達がメソッドの章で実装した`String`クラスの`first`メソッドを検証しています。では、ファイルを`string_first_test.rb`と名付けて保存し、`ruby string_first_test.rb`で実行してみましょう。

```
Run options: --seed 52614

# Running:

E

Error:
MyTest#test_string_first:
NoMethodError: undefined method `first' for "I love Ruby.":String
    string_first_test.rb:5:in `test_string_first'


rails test string_first_test.rb:4



Finished in 0.002764s, 361.7945 runs/s, 0.0000 assertions/s.
1 runs, 0 assertions, 0 failures, 1 errors, 0 skips
```

おや、失敗してしまいました。`NoMethodError`と見えるのは「このクラスにはそんなメソッドは存在しないよ」という意味のエラーです。

理由は単純で、別のファイルでメソッドを定義していたとしても、このテストのファイルからはそれが見えていないのです。

ここで、メソッドの章でやったように`string_first.rb`というファイルでメソッドが定義されているとします。また、`string_first.rb`は`string_first_test.rb`と同じディレクトリに存在するとします。

```ruby
# string_first.rb

class String
  def first
    self[0]
  end
end
```

ここで、

```ruby
# string_first_test.rb

require 'minitest/autorun'
require_relative 'string_first' # この行を追加

class StringFirstTest < MiniTest::Test
  def test_string_first
    assert_equal "I", "I love Ruby.".first
  end
end
```

すると実行結果は

```
Run options: --seed 32792

# Running:

.

Finished in 0.001404s, 712.2507 runs/s, 712.2507 assertions/s.
1 runs, 1 assertions, 0 failures, 0 errors, 0 skips
```

のようになるかと思います。テストは通りましたが、一体何が起こったのでしょうか。

### `require_relative`

異なるファイルの内容を読み込む方法の一つが`require_relative`です。先程出てきた`require`とはまた別のもので、"relative"（「相対的な」）が示すように現在の相対位置からファイル名を検索してその内容を読み込みます。その際、`.rb`は省略することができます（`require_relative 'foo'`はファイル`foo.rb`を読み込みます）。

今回は`require_relative 'string_first'`を実行しています。これにより、同じディレクトリの中にある`string_first.rb`が読み込まれて`String`クラスに`first`メソッドが定義された状態になります。そのため、失敗していたテストが成功するようになったのです。

## まとめ

ここまで、MiniTestを使ってテストを実行する方法とテストの記述方法について解説してきました。テストを自由に記述できるようになることはとても重要ですが、それ以上に重要なのはテストが実行される仕組みを理解することです。というのは、ライブラリの読み込み・別ファイルの読み込み・クラスの定義・メソッドの定義・ライブラリによるメソッドの実行といった、Rubyプログラムが動作する際の中核となる概念がテストの実行において表れているからです。

## このあとの流れ

このチュートリアルでは、演習問題としてのテストが用意されていてそれを解くという形式で学習を進めていきます。その際、この章で説明した要領でテストケースが書かれていますので、皆さんはそのテストが成功するようなコードを書いてください。
