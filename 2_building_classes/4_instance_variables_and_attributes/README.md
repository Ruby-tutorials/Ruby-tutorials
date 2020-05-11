#  この章について

この章ではインスタンス変数と`attr_reader`などの属性記述を扱います。また、属性を設定する主な方法である`initialize`メソッドによるオブジェクトの初期化についても解説します。

# インスタンス変数

以前変数について説明したとき、変数に種類があることは説明していませんでした。というより、その際は変数の概念の中心である「オブジェクトの名付け」のみの説明に留まっていたのでした。

あるインスタンスが内部に持っている変数を「インスタンス変数」と呼びます。インスタンス変数は`@foo`のように変数名の前にアットマークを付けます。例を見てみましょう。

```ruby
class User
  def initialize
    @name = "John Doe"
  end

  def print_name
    puts @name
  end
end

user = User.new
user.print_name
# => John Doe
```

なるほど、見たところ、`puts "John Doe"`が実行されたようです。ここではいくつかの新しい概念が登場しています。順番に見ていきましょう。

## `initialize`メソッド

Rubyには特殊なメソッドがいくつかあります。`initialize`メソッドはその一つであり、`new`メソッドが呼ばれた際に自動的に呼ばれます。

この例では、`initialize`を明示的に実行しなくても`@name`という変数（インスタンス変数）に値がセットされています。実は、`initialize`は明示的に実行できないメソッドです。私達は`initialize`というメソッドを定義するだけで、`new`した際にそこに書かれている処理を実行することができます。

### おまけ：フックメソッド

このように、なにかが起きた際に自動的に呼ばれるメソッドを「フックメソッド」と呼ぶことがあります。この場合は、`initialize`は`new`に対してのフックメソッドである、ということになります。Rubyは様々なフックメソッドを持っており、それらを使いこなすことで魔法のようなことができるようになります。

## 変数の寿命（スコープ）

突然ですが、変数には寿命があります。またの名を変数の「スコープ」とも言うこの概念は非常に重要ですので抑えておきましょう。

以下のコードを見てください。

```ruby
class User
  def initialize
    name = "John Doe"
  end

  def print_name
    puts name
  end
end

user = User.new
user.print_name
# => NameError
```

おや、クラス定義の中身は`@name`が`name`に変わっただけなのに、メソッドの実行結果がエラーになってしまいました。どうしてでしょうか。

アットマークがない変数を「ローカル変数」といいます。ここで「ローカル」というのは「局所的」くらいの意味だと思ってください。どう「局所」なのかというと、`def`の中で定義されたローカル変数は`def`を抜けると「消えて」しまうのです。

ここでは、`initialize`の中で`name`ローカル変数を定義しているのですが、その次の行で`end`となりメソッド定義が終わると`name`は消えてしまいます。そのため、`print_name`メソッドからは`name`変数のことが見えず（参照できず）、エラーとなるのです。

このことを考えると、インスタンス変数は`def`をまたいで生存する変数である、と言えるということになります。ただし、気をつけるべき点がいくつかあります。

### `def`の外側で定義されたインスタンス変数は`def`の中では見えない

以下のコードを考えます。

```ruby
class User
  @name = "John Doe"

  def print_name
    puts @name
  end
end

user = User.new
user.print_name
# =>
```

`print_name`メソッドは何も出力していないように見えます。これは実際には「空文字」が出力されているのですが、これは`@name`が`nil`である際に見られる現象です（それ以外の原因の場合もあります）。確かに`@name`はセットされているように見えますが、何が間違っているのでしょうか。

実は、`def`の中と外でインスタンス変数のスコープは変わってしまいます。`class`の内側かつ`def`の外側で定義されているインスタンス変数は「クラスインスタンス変数」という一見不思議な変数となり、通常とインスタンス変数とは分けて扱われます。

### おまけ：クラスインスタンス変数

「クラスインスタンス変数」とは、なんと不思議な名前でしょうか。クラスとインスタンスは明確に別の概念だったはずです。

思い出してほしいのですが、、Rubyの世界では「全てはオブジェクト」でしたね。この「全て」にはクラスが含まれます。つまり、クラスもまたインスタンスであるのです。正確には、全てのクラスは`Class`クラスのインスタンスです。これは以下のコードですぐにわかります。

```ruby
puts String.class
# => Class
```

クラスインスタンス変数は、あるクラスを`Class`クラスのインスタンスとして捉えたときにそのインスタンス（つまりある特定のクラス）に属している変数のことを指します。え？ちんぷんかんぷん？はい、ですのでこの説明は「おまけ」です。今は理解できなくても、いずれわかる日がやってくるでしょう。

# 属性

ところで、「オブジェクトはデータとメソッドの集合である」と最初の章で解説があったのを覚えているでしょうか。メソッドについてはすでに取り上げていますが、データについてはまだでしたね。

勘のいい方はここで、「インスタンス変数はオブジェクトが持つデータでは」と考えたかもしれません。それは一方では正しいのですが、他方では正しいとは言い切れません。ここで「属性」の考え方が出てきます。

現実の世界では、あらゆるオブジェクトが無数の内部データを持ちます。内部データの中には純粋に内部でのみ必要で外部には存在していることすら知られたくないデータもあります。もしここで、全ての内部データが外部から取得・変更可能になっていたらどうでしょう。きっとすぐに理解不能な状態になってしまいます。

そこで、オブジェクトには「属性」があり、オブジェクトの内部データには属性を通じてしかアクセスできないようにします。その際、属性を「取得」と「変更」に区分することで以下の4象限が生まれます。

1. 取得・変更ともに不可
2. 取得のみ可
3. 変更のみ可
4. 取得・変更ともに可

## 取得・変更ともに不可

これは「インスタンス変数は存在するが、それにアクセスする方法がない」ものを指します。オブジェクトが内部でのみ利用するデータはここに属します。

Rubyでは、全てのインスタンス変数はデフォルトでこの分類になります。つまり、インスタンス変数を外部から取得・変更する方法は原則ありません（が、Rubyは自由度が高い言語なのでなんとかする方法はいくつかあります）。

## 取得のみ可

これは「インスタンス変数またはそれに準ずるデータが存在し、外部から読み込みのみできる」というものを指します。多くのデータはこの分類に属します。「読み込みのみできる」のであればどこで設定するのかというと、先程出てきた`initialize`メソッドで設定を行います（後述します）。

Rubyでは、`attr_reader`という記法を使うことで取得のみ可能な属性を定義できます。その際、属性の名前はインスタンス変数の名前からアットマークを除いたシンボルにします。

## 変更のみ可

これは「インスタンス変数またはそれに準ずるデータが存在し、外部から書き込みのみできる」というものを指します。これは比較的珍しいタイプになります。というのは、外部から設定・書き込みするタイミングを`initialize`での初期化時のみに限定することでオブジェクトの状態を管理しやすくなると考えられており、それに従うとこの種の属性はあまり使う機会がないためです。

Rubyでは、`attr_writer`という記法を使うことで取得のみ可能な属性を定義できます。その際、属性の名前はインスタンス変数の名前からアットマークを除いたシンボルにします。

## 取得・変更ともに可

これは「インスタンス変数またはそれに準ずるデータが存在し、外部から読み書きできる」というものを指します。素朴に考えると多くの属性はこの分類になりそうですが、実際には「取得のみ可」にする場合が多いのが現状です。理由は「変更のみ可」が少ない理由と同じです。

Rubyでは、`attr_accessor`という記法を使うことで取得のみ可能な属性を定義できます。その際、属性の名前はインスタンス変数の名前からアットマークを除いたシンボルにします。

## `initialize`に引数を渡す

属性について具体的なコードを示す前に、先程取り上げた`initialize`メソッドに引数を渡す方法を解説します。これにより、「取得のみ可」の項で説明した属性の取り扱い方、すなわち「初期化時にデータを設定して以後は読み込みのみ可能とする」ことができるようになります。これにより、データが処理の途中で書き換わることがなくなりバグの混入を減らすことができます。

```ruby
class User
  def initialize(name)
    @name = name
  end

  def print_name
    puts @name
  end
end

user = User.new("Jane Doe")
user.print_name
# => Jane Doe
```

見ての通り、`new`に渡した引数がそのまま`initialize`へと渡っています。`new`への引数の渡し方は通常のメソッドへのそれと何ら変わりありません。キーワード引数も利用できます。

## 属性の具体例

では、この章で学んだことを利用したコードを見てみましょう。

```ruby
class User
  attr_reader :first_name, :last_name, :age
  attr_accessor :country
  def initialize(first_name:, last_name:, age:, country:, secret_number:)
    @first_name = first_name
    @last_name = last_name
    @age = age
    @country = country
    @secret_number = secret_number
  end

  def full_name
    last_name + " " + first_name
  end
end

user = User.new(first_name: "John", last_name: "Doe", age: 26, country: "Japan", secret_number: 42)
puts user.full_name
# => John Doe
puts user.age
# => 26
puts user.country
# => Japan
user.country = "United States"
puts user.country
# => United States
user.secret_number
# => NoMethodError
```

`User.new`にキーワード引数でいくつかの引数を渡しています。それを受けた`initialize`ではそれぞれの変数をインスタンス変数に格納しています。

その上の行には`attr_reader`と`attr_accessor`があります。これは`def`の外側に書かれることに気をつけてください（`initialize`の真上に書かれることが多いです）。名前や年齢は後で変更されそうもないので読み込み専用にしていますが、国名は変わるかもしれないので外部から変更可能にしています（そう、実際には名前も変わるのですが、あくまで例ということで！）。秘密の数（`secret_number`）は秘密なので一度設定したらアクセスはできなくなっています。

`full_name`メソッドに注意してください。これはインスタンス変数を返すだけのメソッドではなく、`first_name`と`last_name`を半角スペースでつなげた文字列を返しています。これも見方によっては立派な属性ということになるでしょう。Rubyの世界では`attr_reader`などの記法が使えますが、それ以外の方法でも（`full_name`のように）属性を定義することはできます。

`age`や`country`は読み込み可能なので`user.age`のようにアクセスできます。`user.country`は変更も可能なので、`user.country = "United States"`とすることで内容が変わります。


### おまけ：`attr_`は実際は何をしているのか

属性の定義はできました。しかし、`attr_reader`のような記法は特殊に見えます。これらは実際には何をしているのでしょうか。

まず、`attr_reader`などは実は全てメソッドです。また、上で見たするように`attr_reader`系のメソッドは`class`の内側かつ`def`の外側に記述されます。このような箇所に記述される、一見メソッドのように見えないメソッドは「クラスマクロ」と呼ばれたりします。「マクロ」は「コードを記述するコード」くらいの意味です。

`attr_`系マクロは引数に渡した名前のインスタンス変数に対して作用するようなコードを裏で生成していると考えられます。つまり、

```ruby
attr_reader :foo
```

と

```ruby
def foo
  @foo
end
```

はほぼ同義です。同様に

```ruby
attr_writer :foo
```

と

```ruby
def foo=(attr)
  @foo = attr
end
```

はほぼ同義であり、

```ruby
attr_accessor :foo
```

と

```ruby
def foo
  @foo
end

def foo=(attr)
  @foo = attr
end
```

もまたほぼ同義です。

こう考えると、Rubyがいかにコードの記述量を減らしてくれているかわかるかと思います。さらに重要なことは、これは「特殊命令」のようなものではありません。これらは単なるメソッドであり、Rubyの世界では他のメソッドと対等な立場にあります。つまり、その気になればあなたもこのようなメソッドを書くことができます。

`attr_reader`のようなメソッドを自分で書くとき、それを「メタプログラミング」と呼ぶことがあります。「メタ」は「上」という意味で、プログラムを書くようなプログラムを書くことをメタプログラミングと言います。Rubyの世界では、通常のプログラミングとメタプログラミングの境目は曖昧です。実際、Rubyの世界で最も有名なソフトウェアであるRuby on Railsはメタプログラミングを多用しています。このチュートリアルでは後半でメタプログラミングを取り上げる予定です。