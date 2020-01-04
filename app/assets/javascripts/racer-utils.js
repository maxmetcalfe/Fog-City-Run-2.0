/* global document */
/*eslint-disable no-unused-vars, no-undef */

function addLikelyRacersListener() {
    "use strict";
    var likelyTable = document.getElementById("likely-table");
    if (likelyTable) {
        likelyTable.addEventListener("click", function(event) {
            var rowIndex = event.target.parentNode.rowIndex;

            // A click on the header shouldn't do anything.
            if (rowIndex === 0) {
                return;
            }

            var row = likelyTable.rows[rowIndex];
            var id = row.cells[0].textContent.trim();
            var name = row.cells[1].textContent;
            var bib = row.cells[2].textContent.trim();
            var racerField = document.getElementById("start_item_racer_id");
            var racerIdHiddenDiv = document.getElementById("racer_id_hidden");
            racerField.value = name;
            racerIdHiddenDiv.value = id;
            var bibField = document.getElementById("start_item_bib");
            bibField.value = bib;
        });
    }
}

function runAutocompleteDance(racerIdElementId) {
  "use strict";
  var racerIdHiddenDiv = document.getElementById("racer_id_hidden");
  var racerIdDiv = document.getElementById(racerIdElementId);
  if (racerIdHiddenDiv && racerIdDiv) {
    $("#" + racerIdDiv.id).bind("railsAutocomplete.select", function(event, data) {
      racerIdDiv.value = data.item.label;
      racerIdHiddenDiv.value = data.item.value;
    });
  }
}
