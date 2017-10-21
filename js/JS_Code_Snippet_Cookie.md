```html
<a id="quitBtn" href="#" class="exit">Exit</a>
<a id="quitBtn" href="" class="exit">Exit</a>
```

```javascript
$(function(){
  $('#loginBtn').on('click',loginBtnClick);

  if(pageRefresh()){
    $('#login').hide();
    $('#home').show();
  }else{
    $('#login').show();
    $('#home').hide();
  }
});

/** 
 * @brief To check pin and token, called when use F5 to refresh.
 * @return if pin and token both exists return true, other false
 */
function pageRefresh()
{
  var pin   = getCookie(APP.pinName); 
  var token = getCookie(APP.tokenName);
  if( !pin || typeof(pin) == 'undefined' || pin.length == 0 ){
    deleteCookie(APP.pinName);  deleteCookie(APP.tokenName);
    return false;
  }

  if( !token || typeof(token) == 'undefined' || token.length == 0 ){
    deleteCookie(APP.pinName);  deleteCookie(APP.tokenName);
    return false;
  }
  /// if run here, means pin and token exist.
  var form = new FormData();
  form.append( 'pin', pin );
  form.append( 'token', token );

  var ajaxResult = false;
  $.ajax({
      url: 'POST_PAGE_REFRESH' ,
      type: 'POST',
      data: form,
      async: false,
      cache: false,
      dataType:'json',
      contentType: false,
      processData: false,
      success:function( data ){
          if( 'undefined' == typeof(data.state) ){
              alert('data.state undefined');
              ajaxResult = false;
              return;
          }

          if( typeof(data.msg) == 'undefined' ){
              ajaxResult = false;
              alert('data.msg undefined');
              return;
          }

          if( 'ok' !== data.state )
          {
              deleteCookie(APP.pinName);  deleteCookie(APP.tokenName);
              ajaxResult = false;
              alert("Error 1 :" + data.msg);
              return;
          }
          ajaxResult = true;
      },
      error:function(xhr){
          ajaxResult = false;
          return;
      }
    });

  return ajaxResult;
}

/** 
 * @beief PIN Code login click button 
 */
function loginBtnClick()
{
  var pin = $('input[name="pin"]').val();
  pin.trim();
  if( pin == "" ){
      alert("PIN Code Not Empty.");
      $('input[name="pin"]').val("");
      return;
  }

  if( pin.length !== 4 ){
      alert("The length of Input PIN Code must be 4 number char.");
      $('input[name="pin"]').val("");
      return;
  }

  var token = randomString(32);

  var form = new FormData();
  form.append( 'pin', pin );
  form.append( 'token', token );

  $.ajax({
      url: 'POST_PIN_TOKEN' ,
      type: 'POST',
      data: form,
      async: true,
      cache: false,
      dataType:'json',
      contentType: false,
      processData: false,
      success:function( data ){
        if( !checkAjaxData(data) ){
          $('input[name="pin"]').val("");
          return;
        }
        addCookie(APP.pinName,   pin,   1);
        addCookie(APP.tokenName, token, 1);
        
        $('#login').hide();
        $('#home').show();
      },
      error:function(xhr){
        console.error( "Error 2： " + xhr.status + " " + xhr.statusText );
      }
    });
}

```

```javascript
$( function(){
    $('#quitBtn').on('click', quitBtnClick);
}

/**
 * @biref: Quit Button Click Function
 *      and them tell server to delete token
 */
function quitBtnClick()
{
    var quitForm = new FormData();
    quitForm.append('pin',getCookie(APP.pinName));
    quitForm.append('token',getCookie(APP.tokenName)); 

    $.ajax({
      url: 'POST_QUIT',
      type: 'POST',
      data: quitForm,
      async: true,
      cache: false,
      dataType:'json',
      contentType: false,
      processData: false,
      success: function (data) {
          if( !checkAjaxData(data) ){
              return;
          }
          deleteCookie(APP.pinName);  deleteCookie(APP.tokenName);
          location.href = "./";
      },
      error: function (data) {
          //console.log('load Error: '+xhr.status+': '+xhr.statusText);
      }
    });
}
```

---
