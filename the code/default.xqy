xquery version "1.0-ml";
xdmp:set-response-content-type("text/html"),
'<!DOCTYPE html>',
<html>
  <!-- Use the Source, Luke -->
  <head>
    <title>CodeFlower Source code visualization</title>
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8"/>
    <link type="text/css" rel="stylesheet" href="stylesheets/bootstrap.min.css"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <link href="stylesheets/bootstrap-responsive.min.css" rel="stylesheet"/>
    <link href='http://fonts.googleapis.com/css?family=Rosario:400,700' rel='stylesheet' type='text/css'/>
    <link type="text/css" rel="stylesheet" href="stylesheets/style.css"/>
    <link href="/stylesheets/triplesflower.css" rel="stylesheet" type="text/css"/>
  </head>
  <body>
    <div class="content">
      <div class="container">
        <h1>Triple Flowers are pretty and smell like awesomeness</h1>
        <p class="lead">This experiment visualizes source repositories using an interactive tree. Each disc represents a file, with a radius proportional to the number of lines of code (loc). All rendering is done client-side, in JavaScript. Try hovering on nodes to see the loc number, clicking on directory nodes to fold them, dragging nodes to rearrange the layout, and changing project to see different tree structures. Built with <a href="https://github.com/mbostock/d3">d3.js</a>. Inspired by <a href="https://code.google.com/p/codeswarm/">Code Swarm</a> and <a href="https://code.google.com/p/gource/">Gource</a>.</p>

        <form id="jsonInput">
          <fieldset>
            <textarea id="jsonData">something</textarea>
            <div class="pull-right">
              <button type="submit" class="btn btn-primary btn-large">Update</button>
            </div>
          </fieldset>
        </form>
        <div id="visualization"></div>
      </div>
    </div>
    <script type="text/javascript" src="javascripts/d3/d3.js"><!-- --></script>
    <script type="text/javascript" src="javascripts/d3/d3.geom.js"><!-- --></script>
    <script type="text/javascript" src="javascripts/d3/d3.layout.js"><!-- --></script>
    <script type="text/javascript" src="javascripts/triplesFlower.js"><!-- --></script>
    <script type="text/javascript" src="javascripts/dataConverter.js"><!-- --></script>
    <script type="text/javascript" src="javascripts/jquery-1.10.2.min.js"><!-- --></script>
    <script type="text/javascript" src="javascripts/thisPage.js"><!-- --></script>
    
  </body>
</html>
