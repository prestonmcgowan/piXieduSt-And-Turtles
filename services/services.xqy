xquery version "1.0-ml";
import module namespace sem = "http://marklogic.com/semantics" 
      at "/MarkLogic/semantics.xqy";

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

declare function local:eventsForCountry($country as xs:string) {
	local:sparqly(fn:concat("SELECT ?s WHERE { ?s </gtd/event#country_txt> """, $country, """ }"))
};

declare function local:eventsConnectedBy($predicate as xs:string) {
	local:sparqly(fn:concat("SELECT ?s1 ?s2 WHERE { ?s1 <", $predicate, "> ?o . ?s2 <", $predicate "> ?o }"))
}

declare function local:allEvents() {
	local:sparqly(fn:concat("SELECT ?s WHERE { ?s ?p ?o }"))
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

declare function local:transform-properties-for-ui($uri as xs:string, $map as map:map){
 
  let $children :=
    for $key at $count in map:keys($map)
      let $val := map:get($map, $key)
      let $m := map:map()
      let $put := (
        map:put($m, "relType", $key),
        map:put($m, "id", $val),
        map:put($m, "name", $val),
        map:put($m, "index", $count+1)
      )
      return $m
      
  let $parent := map:map()
  let $put := (
    map:put($parent, "children", $children),
    map:put($parent, "index", 1),
    map:put($parent, "name", $uri),
    map:put($parent, "id", $uri)    
  )
  return $parent
};

declare function local:transform-events-for-ui($relType as xs:string, $value as xs:string, $event_uris) { 
	
	let $children := 
		for $uri at $count in $event_uris
			let $m := map:map()
			let $put := (
				map:put($m, "relType", $relType),
        		map:put($m, "id", $uri),
        		map:put($m, "name", $uri),
        		map:put($m, "index", $count+1)
			)
			return $m

  let $parent := map:map()
  let $put := (
    map:put($parent, "children", $children),
    map:put($parent, "index", 1),
    map:put($parent, "name", $value),
    map:put($parent, "id", $value)    
  )
  return $parent
};

(:
local:eventDetails("/gtd/event#201101010001")
:)

local:eventsForDateRange(xs:date("2011-01-01"), xs:date("2011-01-31"))
(: local:attackType2sForAttackType1("Hostage Taking (Kidnapping)") :)
