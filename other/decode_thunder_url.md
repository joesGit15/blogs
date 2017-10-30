###decode the thunder url 

在迅雷软件中，我们看到的资源链接通常是以下这样的：

In the thunder application, we can find the url like bellow example:

```
URL: QUFmdHA6Ly95Z2R5ODp5Z2R5OEB5MjE5LmR5ZHl0dC5uZXQ6ODIzMC9bJUU5JTk4JUIzJUU1JTg1JTg5JUU3JTk0JUI1JUU1JUJEJUIxd3d3LnlnZHk4LmNvbV0uJUU1JUE1JTg3JUU1JUJDJTgyJUU1JThEJTlBJUU1JUEzJUFCLkhELjEwODBwLiVFNSU5QiVCRCVFOCVBRiVBRCVFNCVCOCVBRCVFNSVBRCU5Ny5ta3ZaWg==
```

this content of url is encode by base64, so first, we should to decode it from linux terminal tool base64.

```
#save url content to txt file
#echo QUFmdHA6Ly95Z2R5ODp5Z2R5OEB5MjE5LmR5ZHl0dC5uZXQ6ODIzMC9bJUU5JTk4JUIzJUU1JTg1JTg5JUU3JTk0JUI1JUU1JUJEJUIxd3d3LnlnZHk4LmNvbV0uJUU1JUE1JTg3JUU1JUJDJTgyJUU1JThEJTlBJUU1JUEzJUFCLkhELjEwODBwLiVFNSU5QiVCRCVFOCVBRiVBRCVFNCVCOCVBRCVFNSVBRCU5Ny5ta3ZaWg== > url.txt
#use base64 to decode it
#base64 -D -i url.txt -o decode.txt # -D means decode, -i means input file, -o means output file
```

ok, after decode it, we will see the decode content in decode.txt, like below:

```
AAftp://ygdy8:ygdy8@y219.dydytt.net:8230/[%E9%98%B3%E5%85%89%E7%94%B5%E5%BD%B1www.ygdy8.com].%E5%A5%87%E5%BC%82%E5%8D%9A%E5%A3%AB.HD.1080p.%E5%9B%BD%E8%AF%AD%E4%B8%AD%E5%AD%97.mkvZZ
```

**Note:** remove AA which in the head and remove ZZ which in the tail.

```
ftp://ygdy8:ygdy8@y219.dydytt.net:8230/[%E9%98%B3%E5%85%89%E7%94%B5%E5%BD%B1www.ygdy8.com].%E5%A5%87%E5%BC%82%E5%8D%9A%E5%A3%AB.HD.1080p.%E5%9B%BD%E8%AF%AD%E4%B8%AD%E5%AD%97.mkv
```

we get the new url content is ftp url. but, it also decode by [what is url encode](https://www.thoughtco.com/encoding-urls-3467463),

we have many ways to decode it.

First way, and it is easy, copy the content of decode url to this [urldecode](http://urldecode.org/?text=&mode=encode) website, and then, click decode button to decode it. you will see the changed of content in the text area. you can also to click encode button to encode it, it will changed before. it is very easy and intersting.

Second way is some complicated,but it seems your level is very powerful. you can go to here [url encode](http://unix.stackexchange.com/questions/159253/decoding-url-encoding-percent-encoding),use the bash alias urldecode decode url,and ,also has the urlencode

That's all.

---