#### Get The Client Info From PHP SERVER Arrary

```php
<?php

    date_default_timezone_set( "Asiz/Shanghai" );
    $userInfo ="----------\n";
    $userInfo += date( "y-m-d G:i:s\n" )."\n";
    $userInfo += $_SERVER["REMOTE_ADDR"]."\n";
    $userInfo += $_SERVER["REMOTE_HOST"]."\n";
    $userInfo += $_SERVER["REMOTE_USER"]."\n";
    $userInfo += $_SERVER["REMOTE_PORT"]."\n";
    $userInfo += $_SERVER["HTTP_USER_AGENT"]."\n";
    $file = fopen( "data.txt", "a") or exit( "unable open file" );
    fputs( $file, $userInfo );
    fclose( $file );

?>
```

---
