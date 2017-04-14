$(document).ready(function() {
  var likelyTable = document.getElementById('likely-table');
  likelyTable.addEventListener("click", function(){
    console.log(event.index());
  });
});