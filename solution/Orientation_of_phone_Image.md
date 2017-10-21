### 相机拍摄的图像方向问题

#### Description

很多时候，我们习惯把手机相机拍摄的图像在电脑上面查看。有的时候在手机上面看图像是正的，可是电脑端查看是反的；有的时候手机和电脑都是反的；有的时候都是正的；还有的时候电脑是正的，手机是反的；所有的这些不一致现象，都是和图像的拍摄方向Orientation有关。

#### What's Orientation of image

对于单反相机，不太清楚。对于手机，我们知道手机拿在手中照相的时候，有竖直的放式，同时也有横向的方式，又由于目前的手机内部都有陀螺仪和重力感应，所以你拍摄时候的手机方式是可以知道的，这就是图像的方向，至于什么方式才是正方向，不同的手机类型设置不一样，自己可以测试一下。图像的方向，就是相机拍摄时候的方向，一般为上下左右四个方向。

#### How to see the Orienation of one image

信息一般存储在[Exif中](http://www.exif.org/), 

1. 图像的属性信息；
2. 第三方的看图软件；
3. Linux command `exif`

#### Hot to get exif infomation in programe

1. [exif.js](http://code.ciaoca.com/javascript/exif-js/)
2. [c exif](https://github.com/mayanklahiri/easyexif)

#### Notes

1. 对于苹果手机, 在手机旋转后,进行的照相. 会保存当前的图像有方向的数据. 然后,在相册或在其他地方使用的时候, 系统会进行自动的根据orientation进行旋正. 这是苹果系统自己的功能.
2. 有的安卓手机, 不管你的手机是否旋转, 照相的时候, 保存的图像都是旋正的图像. 也就是orientation == 1.
3. 有的手机浏览器的img标签，会自动根据exif orientation自动进行纠正旋转。可是使用canvas读取图像的数据进行绘制的时候，却是使用的真是数据，不进行任何的旋转。

### Reference

> [exif](http://www.exif.org)
> [stackoverflow](https://stackoverflow.com/questions/19463126/how-to-draw-photo-with-correct-orientation-in-canvas-after-capture-photo-by-usin)
> [exif orientation tag](http://sylvana.net/jpegcrop/exif_orientation.html)
> [C get exif Info](https://github.com/mayanklahiri/easyexif)

---
