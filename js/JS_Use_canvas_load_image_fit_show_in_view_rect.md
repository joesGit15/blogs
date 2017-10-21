### Description

In the field of image processing, We always to show image after modified the image raw data.It is very easy with using c, c++ and other compiled programming language. But, if you use the interpreted programming language like javascript. i think it will maybe more complicated.But, We always can find work way.

The below code is not all, Just some code snippet.

#### Code snippet

Here rotation ways use the temporary variable to storage temporary image every rotated. before rotatetion, should use src image.

```
var RotateImg = {
    srcImg:"",          // storage src img path, when you begin to rotate every time, you should use src image that can reduce the error of each roataiton
    tmpImg:"",          // storage temp image oath after rotated src image.
};

/** Use the canvas to rotate image raw data to show */
RotateImg.rotate = function(nAngle)
{
    var Img = new Image();
    Img.addEventListener("load",function(){
        var imgW = Img.width;
        var imgH = Img.height;

        var cvs = document.createElement("canvas");
        var context = cvs.getContext( "2d" );
        var degree = nAngle * Math.PI / 180;
        switch ( nAngle )
        {
            case 0://Clockwise 0
                cvs.width  = imgW;
                cvs.height = imgH;
                context.drawImage( Img, 0, 0, imgW, imgH );
                break;
            case 90://Clockwise 90
                cvs.width  = imgH;
                cvs.height = imgW; 
                context.rotate( degree );
                context.drawImage( Img, 0, -imgH, imgW, imgH );
                break;
            case 180://Clockwise 180
                cvs.width  = imgW;
                cvs.height = imgH;
                context.rotate( degree );
                context.drawImage( Img, -imgW, -imgH, imgW, imgH );
                break;
            case 270://Clockwise 270
                cvs.width  = imgH;
                cvs.height = imgW;
                context.rotate( degree );
                context.drawImage( Img, -imgW, 0, imgW, imgH );
                break;
        }

        /** jpeg level [0,1] */
        var dataBase64 = cvs.toDataURL( "image/jpeg", 0.8 );

        /** remove base64 description information before image data.---->data:image/png;base64,iVBORw0KG... */
        dataBase64 = dataBase64.split( "," )[1];
        dataBase64 = window.atob( dataBase64 );
        var ia = new Uint8Array( dataBase64.length );
        for ( var i = 0; i < dataBase64.length; i++ ) {
            ia[i] = dataBase64.charCodeAt( i );
        };

        var blob = new Blob( [ia], {type:"image/jpeg"} );

        /** storage temp image path in member */
        RotateImg.tmpImg = window.URL.createObjectURL( blob );
        RotateImg.showImg(RotateImg.tmpImg);
    },false);

    Img.src = RotateImg.srcImg;
};
```
Here another rotation ways not use the temporary variable, Just use the src. This way is more complex.

```
RotateImg.rotateExampleImage = function( nAngle )
{
    imgLoaded = true;
    var  img = new Image();

    img.onload = function()
    {
        var imgW = img.width;
        var imgH = img.height;
        var degree = nAngle * Math.PI / 180;
        var cvs  = document.getElementById( "canvas" );
        var context = cvs.getContext( "2d" );

        switch ( nAngle ) 
        {
            case 0://Clockwise 0
                var xyImgScale    = imgW / imgH;
                var xyCanvasScale = cvs.width / cvs.height;
                var finalHeight   = 0;
                var finalWidth    = 0;
                if( xyImgScale >= xyCanvasScale ) {
                    finalWidth = cvs.width * 1;
                    finalHeight = finalWidth / xyImgScale;
                } else {
                    finalHeight = cvs.height * 1;
                    finalWidth = finalHeight * xyImgScale;
                }
                var xPos = ( cvs.width - finalWidth   ) / 2;
                var yPos = ( cvs.height - finalHeight ) / 2;

                var maxV = cvs.width > cvs.height ? cvs.width : cvs.height;
                context.clearRect( -maxV, -maxV, 2*maxV, 2*maxV );
                context.rotate( degree );
                context.drawImage( img, 0, 0, imgW, imgH, xPos, yPos,finalWidth, finalHeight );
                context.rotate( -degree );
                break;
            case 90://Clockwise 90
                var xyImgScale    = imgW / imgH;
                var xyCanvasScale = cvs.height / cvs.width;
                var finalHeight   = 0;
                var finalWidth    = 0;
                if( xyImgScale >= xyCanvasScale ) {
                    finalWidth = cvs.height * 1;
                    finalHeight = finalWidth / xyImgScale;
                } else {
                    finalHeight = cvs.width * 1;
                    finalWidth = finalHeight * xyImgScale;
                }
                var xPos = ( cvs.height - finalWidth   ) / 2;
                var yPos = ( cvs.width - finalHeight ) / 2;

                var maxV = cvs.width > cvs.height ? cvs.width : cvs.height;
                context.clearRect( -maxV, -maxV, 2*maxV, 2*maxV );
                context.rotate( degree );
                context.drawImage( img, 0, 0, imgW, imgH, xPos, yPos-cvs.width , finalWidth,finalHeight );
                yPos = yPos-cvs.width;
                context.rotate( -degree );
                break;
            case 180://Clockwise 180
                var xyImgScale    = imgW / imgH;
                var xyCanvasScale = cvs.width / cvs.height;
                var finalHeight   = 0;
                var finalWidth    = 0;
                if( xyImgScale >= xyCanvasScale ) {
                    finalWidth = cvs.width * 1;
                    finalHeight = finalWidth / xyImgScale;
                } else {
                    finalHeight = cvs.height * 1;
                    finalWidth = finalHeight * xyImgScale;
                }
                var xPos = ( cvs.width - finalWidth   ) / 2;
                var yPos = ( cvs.height - finalHeight ) / 2;

                var maxV = cvs.width > cvs.height ? cvs.width : cvs.height;
                context.clearRect( -maxV, -maxV, 2*maxV, 2*maxV );

                context.rotate( degree );
                context.drawImage( img, 0, 0, imgW, imgH, xPos-cvs.width, yPos-cvs.height,finalWidth, finalHeight );
                context.rotate( -degree );
                break;
            case 270://Clockwise 270
                var xyImgScale    = imgW / imgH;
                var xyCanvasScale = cvs.height / cvs.width;
                var finalHeight   = 0;
                var finalWidth    = 0;
                if( xyImgScale >= xyCanvasScale ) {
                    finalWidth = cvs.height * 1;
                    finalHeight = finalWidth / xyImgScale;
                } else {
                    finalHeight = cvs.width * 1;
                    finalWidth = finalHeight * xyImgScale;
                }
                var xPos = ( cvs.height - finalWidth   ) / 2;
                var yPos = ( cvs.width - finalHeight ) / 2;

                var maxV = cvs.width > cvs.height ? cvs.width : cvs.height;
                context.clearRect( -maxV, -maxV, 2*maxV, 2*maxV );

                context.rotate( degree );
                context.drawImage( img, 0, 0, imgW, imgH, xPos-cvs.height, yPos, finalWidth,finalHeight );
                context.rotate( -degree );
                break;
        }

    };

    img.src = RotateImg.srcImg;
}

```

Fit show image in view rect center

```
RotateImg.showImg = function( imgSrc )
{
    var img = new Image();
    var loaded = false;

    function loadHandler() {
        if (loaded) {
            return;
        }

        loaded = true;

        /** core code for fit view rect to show image */
        var imgW = img.width;
        var imgH = img.height;
        var xyImgScale  = imgW / imgH;

        var mycvs  = document.getElementById( "canvas" );
        var xyCanvasScale = mycvs.width / mycvs.height;

        var finalHeight = 0;
        var finalWidth  = 0;

        if( xyImgScale >= xyCanvasScale ){
            finalWidth  = mycvs.width * 1;
            finalHeight = finalWidth / xyImgScale;
        }else{
            finalHeight = mycvs.height * 1;
            finalWidth  = finalHeight * xyImgScale;
        }

        var xPos = ( mycvs.width - finalWidth  ) / 2; 
        var yPos = ( mycvs.height - finalHeight ) / 2;

        var context = mycvs.getContext( "2d" );
        context.clearRect( 0, 0, mycvs.width, mycvs.height );
        context.drawImage( img, 0, 0, img.width, img.height, xPos, yPos,finalWidth, finalHeight );
    }

    img.addEventListener('load', loadHandler);
    img.addEventListener('error', function(event){
        //alert("error:");
    });

    img.src = imgSrc;

    if (img.complete) {
        loadHandler();
    }

};
```


### Reference

> [segmentfault](https://segmentfault.com/q/1010000004563468)
> [stackoverflow](https://stackoverflow.com/questions/5933230/javascript-image-onload)
> [stackoverflow](https://stackoverflow.com/questions/5933230/javascript-image-onload)
> [stackoverflow](https://stackoverflow.com/questions/18773531/iphone-img-onload-fails)

---
