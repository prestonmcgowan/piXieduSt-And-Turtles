
var width =  400,
    height = 400;

var viz = d3.select("body");
var svg = viz.append("svg:svg")
    .attr("width", width)
    .attr("height", height)
    .attr("id", "svgBox")
    .style("border", "solid 2px");

var nodes = [];
var links = [];
var ids = [];
var i = 0;

var force = d3.layout.force()
    .linkDistance(80)
    .charge(-120)
    .gravity(.05)
    .size([width, height]);

function makeCircles(){

  force.nodes(nodes);
  force.links(links);
  
  force.start();

  var link = 
    svg
    .selectAll("line.link")
    .data(links)
    .enter()
    .append("svg:line")
    .attr("class", "link")
    .style("stroke", "#CCC");

  var circles = 
    svg
      .selectAll("circle")
      .data(force.nodes())
      .enter()
      .append("svg:circle")
      .attr("cx", 0)
      .attr("cy", 0)
      .attr("r", 5)
      .attr("id", function(d) { return d.id; })
      .attr("title", function(d) { return d.name; })
      .style("fill", "purple");
  circles.call(force.drag);
  
  
  var updateLink = function() {
		this.attr("x1", function(d) {
			return d.source.x;
		}).attr("y1", function(d) {
			return d.source.y;
		}).attr("x2", function(d) {
			return d.target.x;
		}).attr("y2", function(d) {
			return d.target.y;
		});
	};	
	var updateNode = function() {
		this.attr("transform", function(d) {
			return "translate(" + d.x + "," + d.y + ")";
		});

	}
		
	link.call(updateLink);
  
  
  
  
  force.on("tick", function() {

		circles.call(updateNode);

		link.call(updateLink);

	});
  
}

function findNodes(data) {
  var kids = [];
  if (data.children != undefined) {
    for (var c in data.children) {
      findNodes(data.children[c]);
      kids.push(data.children[c].index);
    }
  }
  for (var k in kids) {
    links.push(
      { source: kids[k], target: data.index, weight: 1}
    );
  }
  
  var me = {'id':data.id, 'name':data.name, 'index': data.index};
  if (ids.indexOf(data.id) < 0) {
    ids.push(data.id);
    nodes.push(me);
  }
}

var json = JSON.parse(document.getElementById("jsonData").value);

findNodes(json);
makeCircles();