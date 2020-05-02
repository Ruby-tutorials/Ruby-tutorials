# この章について

この章では引数を扱います。通常の引数に加えてキーワード引数やデフォルト引数についても扱います。

# 引数

「引数」という単語は英語の"Parameter"または"Argument"の日本語訳です。前者は仮引数、後者は実引数とも訳されます。引「数」となっていますが、実際は数ではなくオブジェクトです。

引数を使うことでメソッドに外からデータその他を流し込むことができます。また、引数の定義の仕方については主に2つのやり方がありますので、どちらとも使いこなせるようにしましょう。

### おまけ：パラメータ

パラメータ（"Parameter"）という単語はRPGゲームをプレイしたことのある方には馴染みのある単語だと思います。イメージとしては、パラメータ（引数）が変わると与えるダメージ（メソッドの結果）が変わる、というような感じです。

## 通常の引数

挨拶をするだけのオブジェクト、`Greeter`を考えます。これまでと`puts`の位置が違うことに気をつけてください（`puts`はプログラム内のあらゆる場所におけます）。

```ruby
class Greeter
  def hello
    puts "Hello!"
  end
end

greeter = Greeter.new
greeter.hello
# => Hello!
```

しかし、これだけではなんとも味気ないですね。どうせ挨拶されるなら名前を呼んでほしいものです。そこで引数を使います。

```ruby
class Greeter
  def hello(name)
    puts "Hello!" + name
  end
end

greeter = Greeter.new
greeter.hello("Masafumi")
# => Hello!Masafumi
```

`def hello(name)`の行における`name`が引数です。ここでは文字列の加算（`+`）を使って挨拶の後ろに名前を足しています。このようにメソッドの内部で何らかの計算に使うのが引数の基本的な使い方です。

## デフォルト引数

しかし、この実装には問題があります。名前がないと挨拶できなくなってしまったのです。

```ruby
class Greeter
  def hello(name)
    puts "Hello!" + name
  end
end

greeter = Greeter.new
greeter.hello
# => ArgumentError (wrong number of arguments (given 0, expected 1))
```

エラーになってしまいました。エラーメッセージを読むと、期待されている引数の数は1つなのに実際の数は0だった、となっています。

ここで「デフォルト引数」の出番です。デフォルト引数の機能を使うと省略可能な引数を定義することができます。省略可能ということは省略したときにどう扱われるのかも併せて定義する必要があり、これが「デフォルト」（既定の）引数という名前の由来となっています。

デフォルト引数を定義するには引数の名前の後ろに`= <デフォルトの値>`を付けます。

```ruby
class Greeter
  def hello(name = "")
    puts "Hello!" + name
  end
end

greeter = Greeter.new
greeter.hello
# => Hello!
```

ここではデフォルトの値を空の文字列にしてみました。これでエラーはなくなりましたね。

## 複数の引数

引数は複数個定義することができます。例を見てみましょう。

```ruby
class Greeter
  def greet(greeting, name = "")
    puts greeting + ", " + name
  end
end

greeter = Greeter.new
greeter.greet("Good morning", "Masafumi")
# => Good morning, Masafumi
```

ここでは挨拶の種類（おはようとかこんにちはとか）と相手の名前を指定できるようにしています。しかし、`greeter.greet("Good morning", "Masafumi")`の行だけを見ると、種類と名前を取り違えてしまう可能性がありそうですね。

```ruby
class Greeter
  def greet(greeting, name = "")
    puts greeting + ", " + name
  end
end

greeter = Greeter.new
greeter.greet("Masafumi", "Good morning")
# => Masafumi, Good morning
```

これはもしかしたら望んでいた結果ではないかもしれません。ここではたまたまどちらの引数も文字列なのでなんとなく動いているような感じになりますが、引数の扱い方によってはより破滅的な結果になるかもしれません。2つの引数ですでに入れ違いの可能性が生じるとしたら、引数の数が例えば5つになったら…あまり考えたくはありませんね。

これを防ぐにはどうすればいいのでしょうか。もちろん、「引数の数が増えすぎないようにする」ことはできるかもしれません。しかし、どうしても避けられないケースというのは存在します。では、メソッドを実行する側が引数を（順番ではなく）名前で渡すようにできたらどうでしょうか。それこそが「キーワード引数」です。

## キーワード引数

「キーワード引数」は引数を名前で渡せるようにするための機構です。例を見るとよくわかります。

```ruby
class Greeter
  def greet(greeting:, name: "")
    puts greeting + ", " + name
  end
end

greeter = Greeter.new
greeter.greet(greeting: "こんばんは", name: "太郎")
# => こんばんは, 太郎
```

先程の例より読みやすくなっていると思いませんか？名前はプログラミングにおいてとても重要ですが、キーワード引数は名前の重要性を示す良い例です。

気をつけるべきこととして、キーワード引数においてもデフォルト値を指定できますが、指定の仕方はコロンの後に値を書く方法になります。コロンの後に値なしでカンマが来た場合、その引数は必須引数（デフォルト値なし）となります。

また、キーワード引数は名前で引数の種類を指定しますので、順番を入れ替えることもできます。

```ruby
class Greeter
  def greet(greeting:, name: "")
    puts greeting + ", " + name
  end
end

greeter = Greeter.new
greeter.greet(name: "太郎", greeting: "こんばんは")
# => こんばんは, 太郎
```
