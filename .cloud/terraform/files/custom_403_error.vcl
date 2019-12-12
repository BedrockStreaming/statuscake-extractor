if (obj.status == 666) {
  set obj.status = 403;
  set obj.response = "Forbidden";
  synthetic {"
    <!DOCTYPE html>
    <html>
        <head>
            <meta charset="UTF-8">
            <title>403</title>
        </head>
        <body>
        <h1>Forbidden</h1>
        </body>
    </html>
  "};
  return(deliver);
}
