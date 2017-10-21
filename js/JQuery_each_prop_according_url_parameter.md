#### 需求说明

根据URL的参数, 来批量的对某些HTML元素做统一的修改.

#### 解决思路

首先, 想办法获得这个URL的参数, 然后遍历对应的HTML元素, 做出对应的修改. 即可.

#### 代码实现

```html
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Demo</title>
</head>
 
<body>
<ul>
<li><a href="https://baidu.com/index.html" target="_blank"> Link 1 </a></li>
<li><a href="https://baidu.com/index.html" target="_blank"> Link 1 </a></li>
<li><a href="https://baidu.com/index.html" target="_blank"> Link 1 </a></li>
<li><a href="https://baidu.com/index.html" target="_blank"> Link 1 </a></li>
</ul>
</body>
 
</html>
<script src="http://libs.baidu.com/jquery/1.10.2/jquery.min.js"></script>
<script type="text/javascript">
function GetString(name)
{
     var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)");
     var r = window.location.search.substr(1).match(reg);
     if(r!=null)return  unescape(r[2]); return null;
}
 
$(document).ready(function()
{
  $("a").each(function()
  {
    var link = $(this).prop("href");
    link = link + "?id=" + GetString("id");
    $(this).prop("href", link);
  });
});

</script> 
```

#### 小结

网上,也有其他的原生js的实现,但是方法着实头疼,看懂都费劲儿. 通过利用一些库,可以把代码写的简洁,便于阅读. 这才是好的解决方法.

---
