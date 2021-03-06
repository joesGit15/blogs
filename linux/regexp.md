Unix 不会阻止用户干蠢事，因为那样也会妨碍用户做聪明的事。

Linux grep，sed 常用语文本的搜索和处理，所以下面也基本通过这两个命令，练习regexp patterns.

## 基础

- grep -n "string"  data.txt #最简单的正则使用，就是查询string字符串，-n 打印行号

### 量词-出现的次数

```
- +     出现次数>0, => {1,}
- *     出现次数>=0. => {0,}
- ?     出现次数0,1或指明一个非贪婪限定符 => {0,1}
- {n}   匹配确定的 n 次。非负整数
- {n,}  至少匹配n 次。
- {n,m} 最少匹配 n 次且最多匹配 m 次。注意在逗号和两个数之间不能有空格。
```

eg:
```
1. grep -P "a+" data.txt        #a出现的次数>1, -P 采用perl regexp模式，不然无法使用\d
2. grep -P "a*" data.txt        #a出现的次数>0
3. grep -P "a?" data.txt        #a出现的次数0,1
4. grep -P "a{2}" data.txt      #a只连续2次的
5. grep -P "a{2,}" data.txt     #a至少连续2次的
5. grep -P "a{2,4}" data.txt    #a至少连续2次的, 最多4次
```
**Note:** `*+?`量词都是贪婪的，因为它们会尽可能多的匹配内容(后面有记录)。

### 括号表达式() [] {}

eg:
```
1. grep -P "(wrod)" data.txt        #查询word
2. grep -P "(wrod){2}" data.txt     #查询word连续出现2次
3. grep -P "(wrod1|word2)" data.txt #查询word1 or word2, `|` 指明两项之间的一个选择。
4. grep -P "[asd|jkl]" data.txt     #查询a,s,k,|,j,k,l字符，注意这里|不是或的意思。
5. grep -P "[02468]" data.txt       #只匹配0,2,4,6,8
6. grep -P "[\d]" data.txt          #[\d] => [0-9] => [0123456789]
7. grep -P "[\D]" data.txt          #[\D] => `[^0-9]` => `[^\d]` 匹配非数字内容，^在[]起始位置，表示不匹配[]内部的内容
8. grep -P "[\w]" data.txt          #匹配单词字符，也就是英文单词的组成成分，字母数字下划线 => `[^A-Za-x0-9]`, `[\W]`就是非单词字符 => `[^_A-Za-z0-9]`
```

### 或，并集和差集

eg:
```
1. echo "2345678901234563452" | grep -P "[0-3,6-9]"    #0-3 || 6-9
1. echo "2345678901234563452" | grep -P "[0-36-9]"     #也可以
2. man ls | grep -P "[a-f,x-y]"    #并集
3. 差集待续...
```

### 定位符

```
- ^  字符串的开始,对于文本来说，一行内容就是一个字符串。
- $  字符串的结束
- \b 匹配一个字边界，即字与空格间的位置。
- \B 非字边界匹配。

对于 ^ and $, 使用vim的就非常熟悉了。
```

**Note：** 不能将限定符与定位符一起使用。

eg:
```
1. grep -P "^a" data.txt        #字符串的以a开头
2. grep -P "^abc" data.txt      #字符串的以abc开头 => `^(abc)`
3. grep -P "^(abc|def)" data.txt#字符串的以abc 或 def开头
4. grep -P "(abc|def)$" data.txt#字符串的以abc 或 def结尾
5. grep -P " $" data.txt        #字符串的以 空格 结尾
```

^$是针对于一个字符串，一个字符串中含有很多单词，\b \B就是对单词进行匹配的。

```
1. grep -P "\ba" data.txt       #以a开头的单词，a,as,and,also,...
2. grep -P "a\b" data.txt       #以a结尾的单词, a,data,meta ....
3. grep -P "\bs[\w]+e\b" data.txt  #以s开头，e结尾的单词，some,single,style,....
4. grep -P "\Bee" data.txt      #非单词边界，也就是单词中。 单词中含有ee的，three,needed,See,green...单词中，就不分单词的开始和结束了 => `ee\B`
5. grep -P "\b[1][02468]\b" data.txt                # 10-19的偶数
6. grep -P "\b[02468]\b|\b[1-9][02468]\b" data.txt  # 0-99的偶数
```

### 其他字符

- . 匹配除 "\n" 之外的任何单个字符。要匹配包括 '\n' 在内的任何字符，请使用像"(.|\n)"的模式。

eg:
```
1. grep -P ".*" data.txt    # => `[^\n]` => `[^\n\r]`
2. grep -P ".+" data.txt 
```

元字符的字面值，一方面可以使用\进行转义为普通字符，另一方面可以用\Q\E把元字符包括起来，eg:\Q$\E,表达式将匹配$的字面值。

#### 非打印字符

- \a     报警字符
- [\b]   退格字符
- \cx 匹配由x指明的控制字符。
      \cM 匹配一个 Control-M 或回车符。
      x 的值必须为 A-Z 或 a-z 之一。否则，将 c 视为一个原义的 'c' 字符。
- \f  匹配一个换页符。等价于 \x0c 和 \cL。
- \n  匹配一个换行符。等价于 \x0a 和 \cJ。
- \r  匹配一个回车符。等价于 \x0d 和 \cM。
- \t  匹配一个制表符。等价于 \x09 和 \cI。

- \s  匹配任何空白字符，包括空格、制表符、换页符等等。等价于 [ \f\n\r\t\v]。
- \S  匹配任何非空白字符。等价于 [^ \f\n\r\t\v]。
- \v  匹配一个垂直制表符。等价于 \x0b 和 \cK。
- \V 非垂直制表符
- \h 水平空白符
- \H 非水平空白符

- \0     空字符

### 进制匹配

- \nml 如果 n 为八进制数字 (0-3)，且 m 和 l 均为八进制数字 (0-7)，则匹配八进制转义值 nml。
- \xn 匹配 n，其中 n 为十六进制转义值。十六进制转义值必须为确定的两个数字长。例如，'\x41' 匹配 "A"。'\x041' 则等价于 '\x04' & "1"。正则表达式中可以使用 ASCII 编码。
- \un  匹配 n，其中 n 是一个用四个十六进制数字表示的 Unicode 字符。例如， \u00A9 匹配版权符号 (?)。

### 多重含义

- \num 匹配 num，其中 num 是一个正整数。对所获取的匹配的引用。例如，'(.)\1' 匹配两个连续的相同字符。
- \n   标识一个八进制转义值或一个向后引用。如果 \n 之前至少 n 个获取的子表达式，则 n 为向后引用。否则，如果 n 为八进制数字 (0-7)，则 n 为一个八进制转义值。
- \nm  标识一个八进制转义值或一个向后引用。如果 \nm 之前至少有 nm 个获得子表达式，则 nm 为向后引用。如果 \nm 之前至少有 n 个获取，则 n 为一个后跟文字 m 的向后引用。如果前面的条件都不满足，若 n 和 m 均为八进制数字 (0-7)，则 \nm 将匹配八进制转义值 nm。

### 运算符优先级

从左到右进行计算，并遵循优先级顺序.不同优先级的运算先高后低。运算符的优先级顺序(高=>低)

```
\ => (), (?:), (?=), [] => *, +, ?, {n}, {n,}, {n,m} => ^, $, \任何元字符、任何字符 定位点和序列（即：位置和顺序）=> | 
```

## 中级

主要是一些概念的理解。

### 量词的贪心，懒惰和占有

量词自身是贪心的。贪心的量词会首先匹配整个字符串。尝试匹配时，它会选定尽可能多的内容，也就是整个输入。量词首次尝试匹配整个字符串，如果失败，则回退一个字符后再次尝试。这就是回溯。它会每次回退一个字符，直到找到匹配的内容或没有字符可尝试为止。同时，它还记录所有的行为，因此他对资源的消耗最大。

懒惰，或者勉强的量词从目标的起始位置开始尝试寻找匹配，每次检查字符串的一个字符，寻找要匹配的内容。最后，会尝试匹配整个字符串。设置一个量词为懒惰的，在普通量词后添加问好?即可。

占有量词会覆盖整个目标然后尝试寻找匹配的内容，只尝试一次，不会回溯。在普通量词后面添加一个加号+即可。

#### 量词的贪心

尽可能多的匹配，这是量词本身的一个特性，不多说了。

#### 懒惰量词

量词的贪心是尽可能多的匹配，也就是选择最大的匹配次数进行匹配；而量词的懒惰，恰恰相反，就是选择最小的匹配次数进行匹配；

```
1. grep -P "a{3,6}" data.txt        # aaa,baaab,aaaa,aaaaaa...都会被匹配，量词本身的贪心,匹配的结果尽可能的长；
2. grep -P "a{3,6}?" data.txt        # aaa,baaab,..匹配的结果尽可能的短，对于aaaaa的字符串，只匹配前3个a,后两个丢弃。
```

eg: 查找< and > 之间的内容
```
1.echo "<h1>abcdefg</h1>" | grep -P "<.*>"        #返回结果：<h1>abcdefg</h1>尽可能多的贪婪匹配
2.echo "<h1>abcdefg</h1>" | grep -P "<.*?>"       #返回结果：<h1>,</h1>, 匹配到了两个
```

```
- ?? 懒惰匹配0 or 1次, 选择的匹配次数为 0
- +? 懒惰匹配1 or more，选择的匹配次数为1
- \*? 懒惰匹配0 or more，选择的匹配次数为0
- {n}? 懒惰匹配n
- {n,}? 懒惰匹配n or more， 选择的匹配次数为n
- {n,m}? 懒惰匹配n-m，选择的匹配次数为最小的n次 
```

干活偷懒，总是选择最小的次数进行匹配，这就是懒惰。

#### 占有量词 (栗子暂没有想到，待续...)

很像贪心式匹配，会选定尽可能多的内容。但是与贪心式匹配不同的是不进行回溯。不会放弃所找到的内容，很自私，所以把它称为占有式，紧紧抱住自己所选的内容，一点也不放弃。优点是速度快，因为无需回溯。当然，匹配失败的话也很快。

```
0.*+ 所有0都被匹配了
0.*+0 没有匹配，原因就是没有回溯。一下子就选定了所有的输入，不再回头查看。一下子没有在结尾找到0，也不知道该从哪里开始找。
```

在量词后面添加+，即可转变为占用。

### 捕获分组和后向引用

正则表达式两边添加圆括号，将把匹配放到一个组中，组中的每个子匹配都按照在组中从左到右出现的顺序存储。 组中每个匹配的编号从 1 开始，最多可存储 99 个子表达式。 每个子表达式都可以使用 \n 的形式访问。

eg:
```
1. grep -P "(\d)\d\1" data.txt        # 匹配:101,111,202,131...

- (\d) 匹配一个数字，并将其捕获
- \d   匹配第二个数字，可是没有进行捕获
- \1   对捕获的数字，进行后向引用

2. man ls | grep -P "(\w)\w\1"        # 匹配: SIS,non,ifi,ses,www,ewe....
3. man ls | grep -P "(\w)\w{2,3}\1"   # 匹配:indi,extension,text,stops,rever...
4. man ls | grep -P "(\w)\w(\w)\1\2"  # 匹配:enses
```

后向引用将通用资源指示符 (URI) 分解为其组件。假定您想将下面的 URI 分解为协议（ftp、http 等等）、域地址和页/路径：

```
var str = "http://www.runoob.com:80/html/html-tutorial.html";
var patt1 = /(\w+):\/\/([^/:]+)(:\d*)?([^# ]*)/;
arr = str.match(patt1);
for (var i = 0; i < arr.length ; i++) {
    console.log(arr[i]);
}
```

output
```
http://www.runoob.com:80/html/html-tutorial.html
http
www.runoob.com
:80
/html/html-tutorial.html
```

- 第一个括号子表达式捕获 Web 地址的协议部分。该子表达式匹配在冒号和两个正斜杠前面的任何单词。
- 第二个括号子表达式捕获地址的域地址部分。子表达式匹配 / 和 : 之外的一个或多个字符。
- 第三个括号子表达式捕获端口号（如果指定了的话）。该子表达式匹配冒号后面的零个或多个数字。只能重复一次该子表达式。
- 最后，第四个括号子表达式捕获 Web 地址指定的路径和 / 或页信息。该子表达式能匹配不包括 # 或空格字符的任何字符序列。

第一个括号子表达式包含"http"
第二个括号子表达式包含"www.runoob.com"
第三个括号子表达式包含":80"
第四个括号子表达式包含"/html/html-tutorial.html"

### 非捕获分组：不会将其内容存储在内存中。所以会带来较高的性能。

可以使用非捕获元字符 ?:、?= 或 ?! 来重写捕获，忽略对相关匹配的保存。

捕获分组 => 非捕获分组

eg:
```
(the|The|THE) => (?:the|The|THE) =>不区分大小写 (?i)(?:the) or (?:(?i)the)  The better way: (?i:the)
```

- (?:pattern) 匹配 pattern 但不获取匹配结果，也就是说这是一个非获取匹配，不进行存储供以后使用。这在使用 "或" 字符 (|) 来组合一个模式的各个部分是很有用。例如， 'industr(?:y|ies) 就是一个比 'industry|industries' 更简略的表达式。
- (?=pattern) 正向预查，在任何匹配 pattern 的字符串开始处匹配查找字符串。这是一个非获取匹配，也就是说，该匹配不需要获取供以后使用。例如，'Windows (?=95|98|NT|2000)' 能匹配 "Windows 2000" 中的 "Windows" ，但不能匹配 "Windows 3.1" 中的 "Windows"。预查不消耗字符，也就是说，在一个匹配发生后，在最后一次匹配之后立即开始下一次匹配的搜索，而不是从包含预查的字符之后开始。
- (?!pattern) 负向预查，在任何不匹配 pattern 的字符串开始处匹配查找字符串。这是一个非获取匹配，也就是说，该匹配不需要获取供以后使用。例如'Windows (?!95|98|NT|2000)' 能匹配 "Windows 3.1" 中的 "Windows"，但不能匹配 "Windows 2000" 中的 "Windows"。预查不消耗字符，也就是说，在一个匹配发生后，在最后一次匹配之后立即开始下一次匹配的搜索，而不是从包含预查的字符之后开始。

### 原子分组

有的正则表达式引擎是进行回溯操作，回溯操作会尝试每一种可能性，消耗时间和计算资源，有时候会占用大量时间，可能产生巨大的负面效应。通过原子分组(?>the)可以关闭回溯操作，可是只针对原子分组内的部分，不针对整个表达式。

### 环视

一种非捕获分组，根据某个模式之前或之后的内容匹配其他模式。又叫做零宽度断言，环视分为 正前瞻，反前瞻，正后顾，反后顾

Perl语言有这种功能,grep测试失败，待续...

```
正前瞻：要匹配keyword,且要求紧随其后的单词是anotherword,可以使用正前瞻 (?i)keyword (?=anotherword)
反前瞻: 对正前瞻的取反操作，匹配某个模式的时候，需要在它后面找不到含有给定前瞻模式的内容。eg: (?i)keyword (?!anotherword)
正后顾: 会查看左边的内容，与正前瞻方向相反。eg: `(?i)(?<keyword) anotherword`
反后顾: 会查看某个模式在从左到右的文本流的后面没有出现。eg:`(?i)(?<!keyword) anotherword`
```

## grep的正则基础

统计单词a|A出现的次数

```
1. man ls | grep -Eoc "(a|A)"    #101

-E 使用扩展的正则表达式
-o 只显示一行中与模式相匹配的那部分
-c 只返回结果的数量
```

```
2. man ls | grep -Eo "(a|A)" | wc -l #263
```

第二条命令的结果大一些。因为-c给出的是匹配的行的数目，但是一行中可能有多个单词匹配。
而第二条命令，指定的单词不管是哪一种形式出现，每次出现都会最为单独的一行统计。所以，结果就大一些。

```
- (THE|The|the) 三个子模式的匹配互不影响
- (t|T)h(e|eir) 后面子模式(e|eir)的匹配依赖于前面子模式(t|T)的匹配。
```

## sed的正则基础使用

### sed替换

```
1. echo Hello | sed 's/Hello/Goodbye/'    #单引号
```

sed 的s表示，将Hello替换成Goodbye, 就相当于vim命令下的:0,$s/Hello/Goodbye/gc

```
sed -n 's/^/<h1>/;s/$/<\/h1>/p;' data.txt    # 符合命令，这样尝试失败

- sed默认的操作是直接复制每行输入并输出。-n选项覆盖默认操作。这样只让正则表达式影响第一行。
- 's/^/<h1>/' 在行的开头添加 '<h1>'
- 分号;用于分割命令
- 's/$/<\/h1>/' 在行的末尾添加...
- 命令p会打印受影响的一行
- q结束程序
```

或者使用-e分别引导命令

```
3. sed -ne 's/^/<h1>/' -e 's/$/<\/h1>/p' -e 'q' data.txt    #注意/的转义\/
```

或者，将命令写入文件：

```
#!/usr/bin/sed

s/^/<h1>/
s/$/<\/h1>/
q
```

```
sed -f h1.sed data.txt
```

4. 用br标签代替空行来分割内容

```
sed -E 's/^$/<br\/>/' data.txt
```

5. 后向引用

eg:
```
1. echo hello | sed 's/\(hello\)/<title>\1<\/title>/'
2. echo hello | sed 's/\(hello\)/<h1>\1<\/h1><title>\1<\/title>/'
```

### sed 插入与追加

sed中的插入命令i允许你在文件或字符串中的某个位置之前插入文本；
sed中的追加命令a允许你在文件或字符串之后添加文本；

```
1. sed '1 i\this is first line' data.txt    #在第一行的位置，插入
2. sed -i '5i\this is a new line' data.txt  #在第五行的位置插入
```

追加标签

```
1. sed '$a\append a new line' data.txt
```

### sed捕获分组和后向引用

```
1. echo onetwothree | sed -E 's/(one)(two)/\2 \1 /'    #two one three
```

-E 选项调用ERE扩展的正则表达式
-n 覆盖打印每一行的默认设置

### sed 处理罗马数字

```
1. sed -En 's/^(ARGUMENT\.|I{0,3}V?I{0,2}\.)$/<h2>\1<\/h2>/' data.txt
```

### sed处理特定段落

```
1. sed -En '5s/^([A-Z].*)$/<p>\1<\/p>/' data.txt
```

仅仅处理第5行的内容。这个和vim的替换有相同的语法。哈哈

sed 处理多行内容

```
2. sed -E '9s/^[ ]*(.*)/ <p>\1<br\/>/;10,832s/^([ ]{5,7}.*)/\1<br\/>/;833s/^(.*)/\1<\/p>' data.txt
```

### 常用正则

> [runoob](https://c.runoob.com/front-end/854)

### 缩写

- ASCII American Standard Code for Information Interchange.美国信息交换标准代码
- POSIX Portable Operating System Interface 可移植操作系统接口

### Reference

> [runoob.com](http://www.runoob.com/regexp/regexp-tutorial.html)
> [POSIX Basic Regular Expressions](https://en.wikibooks.org/wiki/Regular_Expressions/POSIX_Basic_Regular_Expressions)
> [wikipedia](https://en.wikipedia.org/wiki/Regular_expression)
> [regex online tool](http://regex.zjmainstay.cn/?t=0.839102050679827)
> [sed comand](http://man.linuxde.net/sed)

---
