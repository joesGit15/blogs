```
QString str = "input.jpg";

if(!img.load(str)){
    return;
}

QImage mark(img.width()/2,img.height()/2,QImage::Format_RGB32);

QPainter painter(&mark);
painter.fillRect(0,0,mark.width(),mark.height(),Qt::yellow);

QFont ft = painter.font();
ft.setPixelSize(40);
painter.setFont(ft);
painter.drawText(0,0,mark.width(),mark.height(),Qt::AlignCenter,"Qt");

QRgb rgbSrc,rgbMark;
int r,g,b;
float alpha = 0.6, beta = 1- alpha;

for(int x = 0; x < mark.width(); x++){
    for(int y = 0; y < mark.height(); y++){
	rgbSrc = img.pixel(x,y);
	rgbMark = mark.pixel(x,y);

	r = int(qRed(rgbSrc) * alpha + qRed(rgbMark) * beta);
	g = int(qGreen(rgbSrc) * alpha + qGreen(rgbMark) * beta);
	b = int(qBlue(rgbSrc) * alpha + qBlue(rgbMark) * beta);

	r = (0 <= r && r <= 255) ? r : 0;
	g = (0 <= g && g <= 255) ? g : 0;
	b = (0 <= b && b <= 255) ? b : 0;

	img.setPixel(x,y,qRgb(r,g,b));
    }
}

if(img.save("out.jpg")){
    qDebug("Save Ok!");
}
```
