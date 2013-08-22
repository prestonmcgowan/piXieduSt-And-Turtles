xquery version "1.0-ml";
xdmp:set-response-content-type("text/html; charset=UTF-8"),
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:svg="http://www.w3.org/2000/svg">
  <!-- Use the Source, Luke -->
  <head>
    <title>CodeFlower Source code visualization</title>
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8"/>
  </head>
  <body>
    <p>Some text here</p>
    <textarea id="jsonData">{
      (: One Node with One Child :)
      '{"id":"xxx","name":"crap","index":5, "children":[{"id":"a","name":"Alice","index":0, "size":10,"children":[{"id":"s1","name":"Shared","index":3, "size":10},{"id":"s2","name":"Shared","index":4, "size":10}]}]}'
      
    (: 3 nodes with 3 interconnects
      '{"children":[{"id":"a","name":"Alice","index":0,"children":[{"id":"s1","name":"Shared","index":3},{"id":"s2","name":"Shared","index":4}]},{"id":"b","name":"Bob","index":1,"children":[{"id":"s2","name":"Shared","index":4},{"id":"s3","name":"Shared","index":5}]},{"id":"c","name":"Cally","index":2,"children":[{"id":"s1","name":"Shared","index":3},{"id":"s3","name":"Shared","index":5}]}]}'
    :)
    (: Three Node Graph 
      '{"id":"a","name":"Alice", "index":0, "children":[{"id":"b","name":"Bob","index":1, "size":10},{"id":"c","name":"Charlie","index":2, "size":10},{"id":"d","name":"David","index":3, "size":10,"children":[{"id":"c","name":"Charlie","index":2, "size":10}]}],"size":10}'
    :)
    }</textarea>
    
    
    <script type="text/javascript" src="javascripts/d3/d3.js"><!-- --></script>
    <script type="text/javascript" src="javascripts/d3/d3.geom.js"><!-- --></script>
    <script type="text/javascript" src="javascripts/d3/d3.layout.js"><!-- --></script>
    <script type="text/javascript" src="javascripts/pdt.js"><!-- --></script>
    <script type="text/javascript" src="javascripts/pdt-page.js"><!-- --></script>
    
  </body>
</html>
