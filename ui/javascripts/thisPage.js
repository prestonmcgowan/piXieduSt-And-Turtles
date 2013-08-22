var currentCodeFlower;
var createCodeFlower = function(json) {
  // update the jsonData textarea
  document.getElementById('jsonData').value = JSON.stringify(json);
  // remove previous flower to save memory
  if (currentCodeFlower) currentCodeFlower.cleanup();
  // adapt layout size to the total number of elements
  var total = countElements(json);
  w = 800; //parseInt(Math.sqrt(total) * 30, 10);
  h = 600; //parseInt(Math.sqrt(total) * 30, 10);
  // create a new CodeFlower
  currentCodeFlower = new CodeFlower("#visualization", w, h).update(json);
};

$(document).ready(function() {

  document.getElementById('jsonInput').addEventListener('submit', function(e) {
    e.preventDefault();
    var json = JSON.parse(document.getElementById('jsonData').value);
    if (currentCodeFlower === undefined) 
        createCodeFlower(json);
    else
        currentCodeFlower.update(json);
  });
});