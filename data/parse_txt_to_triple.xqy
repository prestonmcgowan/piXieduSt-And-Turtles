xquery version "1.0-ml";
import module namespace sem = "http://marklogic.com/semantics" 
      at "/MarkLogic/semantics.xqy";
import module namespace functx = "http://www.functx.com" at "/MarkLogic/functx/functx-1.0-nodoc-2007-01.xqy";

let $csv := fn:doc("/gtd_sample.txt")

let $lines := fn:tokenize($csv, "(\r\n?|\n\r?)")

let $log := xdmp:log(fn:count($lines))
let $head := tokenize($lines[1], "\t")
let $body := $lines[2 to fn:last()]

let $eventUriBase := "/gtd/event#"

for $line in $body
	(: let $fields := tokenize($line, ",") :)
  let $fields := tokenize($line, "\t")
	(: Event ID :)
	let $eventId := $fields[1]
	let $eventUri := fn:concat($eventUriBase, $eventId)
	let $eventDate := fn:concat($fields[2],"-",$fields[3],"-",$fields[4])

	let $insert :=
		sem:rdf-insert(sem:triple(sem:iri($eventUri), sem:iri(fn:concat($eventUriBase, "date")), functx:date($fields[2], $fields[3], if ($fields[4] eq "0") then "1" else $fields[4] )))

	return 
		for $key at $pos in $head (: basically use the column headings as the properties :)
			let $val := $fields[$pos]
      let $insert := 
				(: skip the first 4 columns since those are the id & dates :)
        if(fn:exists($val) and fn:string-length($val) gt 0 and $pos gt 4 and $val ne ".") then
          sem:rdf-insert(sem:triple(sem:iri($eventUri), sem:iri(fn:concat($eventUriBase, $key)), $fields[$pos]))
        else
          ()
      return $insert

