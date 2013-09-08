xquery version "1.0-ml";
import module namespace sem = "http://marklogic.com/semantics" 
      at "/MarkLogic/semantics.xqy";

declare variable $method := xdmp:get-request-field("method", "undefined");

declare variable $event := local:unescape-from-ui(xdmp:get-request-field("event", "undefined"));
declare variable $name := local:unescape-from-ui(xdmp:get-request-field("name", "undefined"));
declare variable $relType := local:unescape-from-ui(xdmp:get-request-field("relType", "undefined"));

declare variable $respType := xdmp:set-response-content-type("application/json");


declare function local:allCountries() {
	local:sparqly("SELECT ?o WHERE { ?s </gtd/event#country_txt> ?o }")
};

declare function local:allAttackTypes() {
	fn:distinct-values((local:sparqly("SELECT ?o WHERE { ?s </gtd/event#attacktype1_txt> ?o }"), local:sparqly("SELECT ?o WHERE { ?s </gtd/event#attacktype1_txt> ?o }")))
};

declare function local:allWeaponTypes() {
	fn:distinct-values((local:sparqly("SELECT ?o WHERE { ?s </gtd/event#weaptype1_txt> ?o }"), local:sparqly("SELECT ?o WHERE { ?s </gtd/event#weaptype2_txt> ?o }")))
};

declare function local:allTargetTypes() {
	fn:distinct-values((local:sparqly("SELECT ?o WHERE { ?s </gtd/event#targtype1_txt> ?o }"), local:sparqly("SELECT ?o WHERE { ?s </gtd/event#targtype2_txt> ?o }")))
};

declare function local:allTargetOrgs() {
	fn:distinct-values((local:sparqly("SELECT ?o WHERE { ?s </gtd/event#corp1> ?o }"), local:sparqly("SELECT ?o WHERE { ?s </gtd/event#corp2> ?o }"), local:sparqly("SELECT ?o WHERE { ?s </gtd/event#corp3> ?o }")))
};

declare function local:allPerpetratorOrgs() {
	local:sparqly("SELECT ?o WHERE { ?s </gtd/event#gname> ?o }")
};

declare function local:perpetratorSubOrgs($parentOrgName as xs:string) {
	let $ret :=
    	for $uri in local:sparqly(fn:concat("SELECT ?s WHERE { ?s </gtd/event#gname> """, $parentOrgName, """}"))
     		return local:sparqly(fn:concat("SELECT ?o WHERE { <", $uri, "> </gtd/event#gsubname> ?o }"))
  return fn:distinct-values($ret)
};

declare function local:allDataSources() {
	local:sparqly("SELECT ?o WHERE { ?s </gtd/event#dbsource> ?o }")
};

declare function local:allEvents() {
  local:sparqly("SELECT ?s WHERE { ?s ?p ?o }")
};

declare function local:allEventsWithSummary() {
  local:sparqly-map(fn:concat("SELECT ?s ?o WHERE { ?s </gtd\event#summary> ?o }"))
};

declare function local:eventsForCountry($country as xs:string) {
	local:sparqly(fn:concat("SELECT ?s WHERE { ?s </gtd/event#country_txt> """, $country, """ }"))
};

declare function local:eventsForDateRange($startDate as xs:date, $endDate as xs:date) {
	(: SJS - couldn't get the sparql filter to work with dates, so resorted to this :)
	cts:search(/sem:triples,
  		cts:and-query((
    		cts:triple-range-query((), sem:iri("/gtd/event#date"), $startDate, "<="),
    		cts:triple-range-query((), sem:iri("/gtd/event#date"), $endDate, ">="))
  		)
	)//sem:subject/text()
};

declare function local:eventDetails($eventUri as xs:string) {
	local:sparqly-map(fn:concat("SELECT * WHERE { <", $eventUri, "> ?p ?o }"))
};

declare function local:eventsForProperty($predicate as xs:string, $object as xs:string) {
	local:sparqly(fn:concat("SELECT ?s WHERE { ?s <", $predicate, "> """, $object, """ }"))
};

declare function local:sparqly($sparql as xs:string) {
	fn:distinct-values(local:map-values(sem:sparql($sparql)))
};

declare function local:sparqly-map($sparql as xs:string) {
	local:result-to-map(sem:sparql(fn:concat($sparql)))
};

declare function local:map-values($m as map:map) {
  for $key in map:keys($m)
    return map:get($m, $key)
};

declare function local:result-to-map($seqOfMaps) as map:map {
  let $ret := map:map()
  let $_ := 
    for $map in $seqOfMaps
      let $vals := local:map-values($map)
        return map:put($ret, $vals[1], $vals[2])
  return $ret
};

declare function local:escape-for-ui($string as xs:string) as xs:string {
      let $val := fn:replace($string, "&amp;", "&amp;amp;")
      let $val := fn:replace($val, '"', '')
      return $val
};

declare function local:unescape-from-ui($string as xs:string) as xs:string {
      let $val := fn:replace($string, "&amp;amp;", "&amp;")
      let $val := fn:replace($val, '', '"')
      return $val
};

declare function local:ui-map-entry($relType, $id, $name, $index, $children) as map:map {
    let $m := map:map()
	let $put := (
		if($relType) then map:put($m, "relType", $relType) else (),
		if($id) then map:put($m, "id", xs:string($id)) else (),
		if($name) then map:put($m, "name", local:escape-for-ui($name)) else (),
		if($index) then map:put($m, "index", $index) else (),
		if($children) then map:put($m, "children", $children) else ()
	)
	return $m
};

declare function local:transform-properties-for-ui($uri as xs:string, $map as map:map) {
 
  let $children :=
    for $key at $count in map:keys($map)
      let $val := map:get($map, $key)
      return local:ui-map-entry($key, $count, $val, $count, ())
      
  return local:ui-map-entry((), "0", $uri, 0, $children)
};

declare function local:transform-events-for-ui($relType as xs:string, $value as xs:string, $event_uris) { 
	
	let $children := 
		for $uri at $count in $event_uris
			return local:ui-map-entry($relType, $count, $uri, $count, ())

  	return local:ui-map-entry((), "0", $value, 0, $children)
};

(:
local:eventDetails("/gtd/event#201101010001")
:)

(: local:eventsForDateRange(xs:date("2011-01-01"), xs:date("2011-01-31")) :)

(:
let $result := map:map()
let $_ :=
  for $event at $count in local:eventsForCountry("Iraq")
    return map:put($result, $event, local:eventDetails($event))

return $result 
:)
(: local:sparqly("SELECT ?s WHERE { ?s ?p ?o }") :)
(:
let $result := map:map()
let $_ :=
  for $event in local:eventsForCountry("Iraq")[1]
      return map:put($result, $event, local:eventDetails($event))
    
return xdmp:to-json($result)    
:)
(:
local:sparqly-map("SELECT ?s1 ?s2 ?o WHERE { ?s1 </gtd/event#country_txt> ?o . ?s2 </gtd/event#country_txt> ?o . }")
:)
(:
xdmp:to-json(
  local:transform-for-ui("/gtd/event#201101010001", local:eventDetails("/gtd/event#201101010001"))
)
:)
(: local:propertyDetails("/gtd/event#natlty1_txt", "Iraqi")

local:sparqly("SELECT ?s WHERE { ?s </gtd/event#natlty1_txt> ""Iraq"" }")


xdmp:to-json(
  local:transform-properties-for-ui($event, local:eventDetails($event))
)

:)
(:
xdmp:to-json(
  local:transform-events-for-ui("/gtd/event#natlty1_txt", "Iraq", local:eventsForProperty("/gtd/event#natlty1_txt", "Iraq"))
)
:)

if ($method eq "properties") then
	xdmp:to-json( local:transform-properties-for-ui($event, local:eventDetails($event)) )
else if($method eq "events") then
	xdmp:to-json( local:transform-events-for-ui($relType, $name, local:eventsForProperty($relType, $name)) )
else if($method eq "allEvents") then
  xdmp:to-json( local:allEvents() )
else if($method eq "allEventsWithSummary") then
  xdmp:to-json( local:allEventsWithSummary() )
else ()



  
