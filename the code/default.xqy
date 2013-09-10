xquery version "1.0-ml";
xdmp:set-response-content-type("text/html; charset=UTF-8"),
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:svg="http://www.w3.org/2000/svg">
  <!-- Use the Source, Luke -->
  <head>
    <title>piXiduSt and Turtles Visualization</title>
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8"/>
    <link type="text/css" rel="stylesheet" href="stylesheets/pdt.css"/>
  </head>
  <body>
    <div id="title">piXieduSt and Turtles</div>
    <div id="description">XQuery<br/>Semantics<br/>Triples</div>
    <button id="Execute" onClick="loadIt();">Magic Time</button>
    <textarea id="jsonData">{
      (: One Node with One Child - works:)
      (: '{"id":"a","name":"Alice", "index":0, "children":[{"id":"b","name":"Bob","index":1, "size":10}],"size":10}' :)
      
    (: Three Node Graph - works 
    '{"id":"a","name":"Alice", "index":0, "children":[{"id":"b","name":"Bob","index":1, "size":10},{"id":"c","name":"Charlie","index":2, "size":10},{"id":"d","name":"David","index":3, "size":10,"children":[{"id":"c","name":"Charlie","index":2, "size":10}]}],"size":10}'
    :)
    
    (: Bunches of nodes - works 
    '{"id":"a","name":"Alice", "index":0, "children":[{"id":"a1","name":"Bob","index":1, "size":10, "children":[{"id":"ab","name":"Bob","index":4, "size":10},{"id":"b","name":"Bob","index":5, "size":10}]},{"id":"a2","name":"Bob","index":2, "size":10},{"id":"ac","name":"Bob","index":3, "size":10, "children":[{"id":"c","name":"Bob","index":6, "size":10}]}],"size":10}'
    :)
    
    (: Scott's sample :)
    '
   {"children":[{"relType":"\/gtd\/event#multiple", "index":1, "name":3160823025, "id":"31608230251"}, {"relType":"\/gtd\/event#vicinity", "index":2, "name":3160823025, "id":"31608230252"}, {"relType":"\/gtd\/event#nperps", "index":3, "name":3176308888, "id":"31763088883"}, {"relType":"\/gtd\/event#scite2", "index":4, "name":2678628706, "id":"26786287064"}, {"relType":"\/gtd\/event#targtype1", "index":5, "name":4061309204, "id":"40613092045"}, {"relType":"\/gtd\/event#weapdetail", "index":6, "name":3385170255, "id":"33851702556"}, {"relType":"\/gtd\/event#date", "index":7, "name":3391584057, "id":"33915840577"}, {"relType":"\/gtd\/event#doubtterr", "index":8, "name":3160823025, "id":"31608230258"}, {"relType":"\/gtd\/event#nkill", "index":9, "name":2204738654, "id":"22047386549"}, {"relType":"\/gtd\/event#summary", "index":10, "name":1678782154, "id":"167878215410"}, {"relType":"\/gtd\/event#crit1", "index":11, "name":3176308888, "id":"317630888811"}, {"relType":"\/gtd\/event#targtype1_txt", "index":12, "name":2591228417, "id":"259122841712"}, {"relType":"\/gtd\/event#motive", "index":13, "name":1620709284, "id":"162070928413"}, {"relType":"\/gtd\/event#nkillter", "index":14, "name":3176308888, "id":"317630888814"}, {"relType":"\/gtd\/event#provstate", "index":15, "name":675926570, "id":"67592657015"}, {"relType":"\/gtd\/event#guncertain1", "index":16, "name":3176308888, "id":"317630888816"}, {"relType":"\/gtd\/event#dbsource", "index":17, "name":2863676892, "id":"286367689217"}, {"relType":"\/gtd\/event#claimed", "index":18, "name":3160823025, "id":"316082302518"}, {"relType":"\/gtd\/event#location", "index":19, "name":516533251, "id":"51653325119"}, {"relType":"\/gtd\/event#nkillus", "index":20, "name":3160823025, "id":"316082302520"}, {"relType":"\/gtd\/event#extended", "index":21, "name":3160823025, "id":"316082302521"}, {"relType":"\/gtd\/event#natlty1_txt", "index":22, "name":3229223622, "id":"322922362222"}, {"relType":"\/gtd\/event#nwoundte", "index":23, "name":3160823025, "id":"316082302523"}, {"relType":"\/gtd\/event#nwoundus", "index":24, "name":3160823025, "id":"316082302524"}, {"relType":"\/gtd\/event#weaptype1", "index":25, "name":3253738203, "id":"325373820325"}, {"relType":"\/gtd\/event#nperpcap", "index":26, "name":3160823025, "id":"316082302526"}, {"relType":"\/gtd\/event#city", "index":27, "name":2349037774, "id":"234903777427"}, {"relType":"\/gtd\/event#gname", "index":28, "name":3486588377, "id":"348658837728"}, {"relType":"\/gtd\/event#country_txt", "index":29, "name":3229223622, "id":"322922362229"}, {"relType":"\/gtd\/event#ishostkid", "index":30, "name":3160823025, "id":"316082302530"}, {"relType":"\/gtd\/event#propextent", "index":31, "name":3207280614, "id":"320728061431"}, {"relType":"\/gtd\/event#attacktype1", "index":32, "name":3207280614, "id":"320728061432"}, {"relType":"\/gtd\/event#weapsubtype1_txt", "index":33, "name":1476500824, "id":"147650082433"}, {"relType":"\/gtd\/event#scite3", "index":34, "name":4114918184, "id":"411491818434"}, {"relType":"\/gtd\/event#country", "index":35, "name":3383876909, "id":"338387690935"}, {"relType":"\/gtd\/event#property", "index":36, "name":3176308888, "id":"317630888836"}, {"relType":"\/gtd\/event#crit3", "index":37, "name":3176308888, "id":"317630888837"}, {"relType":"\/gtd\/event#region_txt", "index":38, "name":1765187175, "id":"176518717538"}, {"relType":"\/gtd\/event#weapsubtype1", "index":39, "name":4045823341, "id":"404582334139"}, {"relType":"\/gtd\/event#propcomment", "index":40, "name":1193083321, "id":"119308332140"}, {"relType":"\/gtd\/event#nwound", "index":41, "name":2263991185, "id":"226399118541"}, {"relType":"\/gtd\/event#scite1", "index":42, "name":3340971665, "id":"334097166542"}, {"relType":"\/gtd\/event#region", "index":43, "name":3999365752, "id":"399936575243"}, {"relType":"\/gtd\/event#natlty1", "index":44, "name":3383876909, "id":"338387690944"}, {"relType":"\/gtd\/event#attacktype1_txt", "index":45, "name":4220577147, "id":"422057714745"}, {"relType":"\/gtd\/event#success", "index":46, "name":3176308888, "id":"317630888846"}, {"relType":"\/gtd\/event#suicide", "index":47, "name":3176308888, "id":"317630888847"}, {"relType":"\/gtd\/event#propextent_txt", "index":48, "name":2221134028, "id":"222113402848"}, {"relType":"\/gtd\/event#crit2", "index":49, "name":3176308888, "id":"317630888849"}, {"relType":"\/gtd\/event#weaptype1_txt", "index":50, "name":8820581, "id":"882058150"}, {"relType":"\/gtd\/event#target1", "index":51, "name":2515678378, "id":"251567837851"}], "index":0, "name":2597693512, "id":2597693512}
    '
    }</textarea>
    
    
    <embed id="peter" src="/images/Peter_Pan_by_nk.svg" type="image/svg+xml" />
    
    <embed id="turtle" src="/images/cute_turtle.svg" type="image/svg+xml" />
    
    <script type="text/javascript" src="javascripts/d3/d3.js"><!-- --></script>
    <script type="text/javascript" src="javascripts/d3/d3.geom.js"><!-- --></script>
    <script type="text/javascript" src="javascripts/d3/d3.layout.js"><!-- --></script>
    <script type="text/javascript" src="javascripts/pdt.js"><!-- --></script>
    <script type="text/javascript" src="javascripts/pdt-page.js"><!-- --></script>
    
  </body>
</html>
