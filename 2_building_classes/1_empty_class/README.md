# この章について

この章では空っぽのクラスを作ることでRubyにおけるクラス定義の基礎を学びます。特に、`Object`クラスの存在といくつかのメソッドについて意識することで今後のエクササイズで使えるメソッドの数を増やすことを企図しています。

# クラス定義

以前の章で学んだように、クラス定義には`class`キーワードを用います。

具体的にクラスを定義していく前に、クラスの重要性について抑えておきましょう。

## クラスの重要性

Rubyは「オブジェクト指向」のプログラミング言語です。これの意味するところは、プログラミングを「オブジェクト同士の相互作用として把握する」ことにあります。

しかし、実際のプログラミングでは登場するオブジェクトの数は数千以上になることが珍しくありません。こうなると、オブジェクトを何らかの仕組みによってグループ化しないと人間には把握することが困難となります。ここで登場する概念が「クラス」です。

クラスはオブジェクトの「種類」である、という解説をしてきました。クラスを中心とするオブジェクト指向のことを「クラスベース」と言ったりしますが、クラスベースの世界観ではオブジェクトのできること（反応できるメソッドとそれへの実際の反応）はそのクラスによってほぼ決定されます。例えば、文字列（`String`）の加算と数値（`Integer`）の加算は異なる処理となりますが、これは文字列と数値の種類、つまりクラスが異なることの直接の結果です。

```ruby
# 数値同士の加算
puts 1 + 1
# => 2
# 文字列同士の加算
puts "1" + "1"
# => "11"
```

### おまけ：異なるクラスのオブジェクト同士を相互作用させようとすると

オブジェクトがクラスに属しているということは、例えば文字列の`"1"`と数値の`1`を足すことはできない、ということも意味しています。これはほとんどの場合に納得のいくことではないでしょうか。というのは、`2`と`"11"`のどちらが正しい結果なのか自明ではないからです。

```ruby
#　数値と文字列の加算
1 + "1" # => TypeError
```

上の例で登場した`TypeError`というのは直訳すると「型のエラー」という意味です。型というのはクラスベースの言語ではクラスと似たような意味で使われます。つまり、数値に文字列を加算しようとすると、「予期していた数値ではない型（クラス）のオブジェクトが加算されようとしているよ」となってエラーになるわけです。

全ての相互作用が同じクラス同士で行われなくてはならないということではないのですが、オブジェクトの相互作用を考えるときは常にクラスの存在を意識することでエラーの少ないプログラミングが行えるでしょう。

## クラス定義

では、クラスを実際に定義してみましょう。クラス定義には`class`キーワードを使います。対応する`end`キーワードもお忘れなく。

```ruby
class Person
end
```

できました！これで`Person`クラスが定義されたことになります。しかし、待ってください。`1`はそのまま書くことで数値のオブジェクトとして有効でした。では、`Person`クラスのオブジェクト（「インスタンス」と呼ぶこともあるのでしたね）はどうやって生成するのでしょうか。

クラスの章で`.new`という書き方に触れています。`.new`という書き方は`Person`クラスにも使えるのでしょうか。試してみましょう。

```ruby
class Person
end
puts Person.new
# => #<Person:0x00007fb64d109b30>
```

数値の部分は違う数値になっているかと思いますが、似たような結果になったでしょう。これで`Person`クラスのインスタンスの生成に成功しました！

## 生成したインスタンスを変数に格納する

しかし、これだけでは不便です。というのは、生成したオブジェクトはどこかへ消えてしまっているからです。`.new`で生成したオブジェクトを後で使い回せるようにするには、「変数」にオブジェクトを代入するのでした。

```ruby
class Person
end
person = Person.new
```

## 変数に格納されたオブジェクトに対してクラスを問い合わせる

これで`person`変数には`Person`クラスのオブジェクトが代入された状態になりました。以後はこの`person`クラスに対してメソッドを実行することで色々と遊んでみましょう。

まずは、クラスを問い合わせます。予期される結果は当然`Person`ですが…

```ruby
class Person
end
person = Person.new
puts person.class
# => Person
```

やりました！しかし、よく考えるとまだ謎はあります。この`class`メソッドはどこから来たのでしょうか。私達はクラスの中身を空にしていますので、私達が書いたコードが動作しているわけでもなさそうです。

## クラス継承

実は、Rubyのクラスには「継承」と呼ばれる仕組みがあります。これはあるクラスが別のクラスの機能を拡張する場合によく用いられる技法です。概念的には、継承する側とされる側に"is-a"関係が成立するケースで継承を用いるとよいとされます。例を挙げます。

```ruby
class Person
end

class Student < Person
end

class Teacher < Person
end
```

`<`の記号が継承を示しています。左側が継承する側、右側が継承される側です。この関係性は、「全ての`Student`は`Person`であり、全ての`Teacher`は`Person`である」という意味になります。これが"is-a"関係です（"A student is a Person."）。なるほど、正しいようですね（将来的にはロボットの先生が登場するのかもしれませんが…）。

継承が行われると、継承した側のクラスは継承された側のクラスの機能を全て持つことになります。実際には継承した後でそのクラスに独自の機能を付け足していくことになるのですが（継承の章で詳しく取り上げます）、ここで注目していただきたいのは`Person`クラスの継承関係です。一見何もないように見えますが、実はここに隠し継承があるのです。

## `Object`クラス

Rubyには見えない継承関係の機能があります。Rubyの世界では、（ほとんど）全てのクラスは`Object`クラスを継承しているのです。

```ruby
# この書き方が好まれるが…
class Person
end

# こう書いても同じ
class Person < Object
end
```

では、この`Object`クラスは一体何なのでしょうか。

このクラスはRubyのオブジェクトが当然持っていてほしい機能一式を詰め合わせたクラスだと考えてください。このクラスが存在するおかげで、私達は何も気にせずに`class`メソッド（以前使いましたね）のような便利メソッドを全てのオブジェクトに対して使うことができるわけです。

## `Object`クラスのメソッドたち

ここから先は`Object`クラスが持つメソッドを取り上げます。これらのメソッドは全てのクラスで使うことができるため、覚えておいて損はありません。

### `class`

繰り返しの登場ですが、あるオブジェクトのクラスを問い合わせるメソッドです。

```ruby
class Person
end

person = Person.new
puts person.class
# => Person
```

### `is_a?`

`class`メソッドの亜種で、あるオブジェクトが指定したクラスに属しているなら真を、そうでなければ偽を返します。

```ruby
class Person
end

person = Person.new
puts person.is_a?(Person)
# => true
puts person.is_a?(String)
# => false
```

ここで、括弧の中にあるクラスは「引数」と呼ばれるものでしたね（自作メソッドの章で詳しく取り上げます）。

#### おまけ：真偽値

ここで初めて登場した`true`と`false`は真偽値と言われるものです。真偽値は主に条件分岐のために使われます（条件分岐の章で取り上げます）。真偽値はあまりにも単純な、単に「正しい」「正しくない」という状態を表現するだけのものですが、これもオブジェクトなのでしょうか？

```ruby
puts true.class
# => TrueClass
puts false.class
# => FalseClass
```

なんと、ちゃんと`class`メソッドに応答しますし、結果はなんだか不思議な名前のクラスになりました。ここからわかる通り、Rubyの世界では`true`と`false`の真偽値もオブジェクトであり、それ専用のクラスを持ちます。

### `respond_to?`

あるオブジェクトが指定したメソッドに応答するかを調べるためのメソッドです。

```ruby
puts "I love Ruby.".respond_to?(:length)
# => true
puts 42.respond_to?(:no_such_method)
# => false
```

見ての通り、文字列`"I love Ruby."`は以前取り上げたように`'length'`メソッドに応答しますが、整数`42`は`no_such_method`という（名前どおりに）存在しないメソッドには応答しません（ので`false`が返っています）。

#### おまけ：`Symbol`

ここで初めて登場した`:length`のような表記ですが、これは`Symbol`と呼ばれるものです（以下「シンボル」と表記）。シンボルは文字列と似ていますが、いくつかの点で異なります。具体的な違いについては折に触れて説明しますが、実践的な違いとしては変化しない名前を表現するときにシンボルがよく用いられます。このケースではメソッド名という名前を扱うので、シンボルがふさわしい場面と言えるでしょう。

### `nil?`

`nil`は`puts`の説明の際に一瞬だけ登場しましたが、深くは触れていませんでした。今こそその時です。

`nil`という単語は「何もない」を意味します。これは色々な解釈が可能であり、実際にRubyの世界で`nil`は頻出します（そしてある理由により多くのプログラマを困らせます）。


例えば、空っぽの文字列の最初の一文字を取得することを考えます。最初の文字列の取得には以前使った`[0]`を使えばいいとして、結果は何であるべきなのでしょうか。そう、答えは「なにもない」です。そこで`nil`の出番です。

```ruby
puts ""[0]
# =>
```

おや、出力が見えませんね？これは`nil`は`puts`で表示される際に空白として表現されるという仕様によるものです。

`nil`は単に`nil`と書くだけでも生成することができます（「生成」という単語は本来おかしいのですが、これまでのオブジェクトとの整合性を重視しています）。

```ruby
puts nil
# =>
```

では、`nil`に`nil?`メソッドを呼んでみましょう。ついでに他の色々にも呼んでみましょうか。

```ruby
puts nil.nil?
# => true
puts "I love Ruby.".nil?
# => false

class Person
end
person = Person.new
puts person.nil?
# => false
```

なるほど、それはそう、という結果になりましたね。この`nil?`メソッドは結果が`nil`かどうか不明なケース、例えば「任意の長さの文字列の最初の一文字を取得したその結果」みたいなものを扱う際に便利です。
