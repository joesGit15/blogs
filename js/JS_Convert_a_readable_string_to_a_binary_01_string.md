#### 问题起源

看过一个漫画, 两位程序员在办公司交流, 可是说的语言却是010101类似的字符串.周围人很是惊异.计算机的世界,确实是由01组成的.今天突然想实现这个编码转换.

#### 解决思路

1. 学过C语言的都知道, 一个`char`类型的字符,实际存储的是这个字符的ASCII码. 最终转换是数值的进制.也就是把10进制的数字转换成2进制的数值, 然后,每位转换成字符, 输出即可. 当然, 如果你考虑到多种语言环境的话, 那么就会复杂很多. 使用强类型语言的话, 这里建议使用Qt类库的`QChar`和`QString`.Qt支持多国语言非常好.
2. 对于弱类型的JS来说, 访问底层的编码没有强类型语言那么直接方便. 那么Js能否实现呢? 所以,本人尝试了JS的实现方法.通过查阅资料,JS也提供了方便的类可以用于解决这样的问题.

#### js代码
```javascript
var str = "看不懂,我可不管.";
console.log('编码前:'+ str);

var total2str = "";
for (var i = 0; i < str.length; i++) {
      var num10 = str.charCodeAt(i);  ///< 以10进制的整数返回 某个字符 的unicode编码
      var str2 = num10.toString(2);   ///< 将10进制数字 转换成 2进制字符串

      if( total2str == "" ){
        total2str = str2;
      }else{
        total2str = total2str + " " + str2;
      }
}
console.log("编码后:" + total2str);

var goal = "";
var arr = total2str.split(' ');
for(var i=0; i < arr.length; i++){
  var str2 = arr[i];
  var num10 = parseInt(str2, 2); ///< 2进制字符串转换成 10进制的数字
  goal += String.fromCharCode(num10); ///< 将10进制的unicode编码, 转换成对应的unicode字符
}

console.log('解码后:'+ goal );
```

#### 效果

```javascript
编码前:支持中文吗? ying gai shi zhi chi de.
编码后:110010100101111 110001100000001 100111000101101 110010110000111 101010000010111 111111 100000 1111001 1101001 1101110 1100111 100000 1100111 1100001 1101001 100000 1110011 1101000 1101001 100000 1111010 1101000 1101001 100000 1100011 1101000 1101001 100000 1100100 1100101 101110
解码后:支持中文吗? ying gai shi zhi chi de.
```

#### 参考引用

> [Js String 标准库](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/String)

---
