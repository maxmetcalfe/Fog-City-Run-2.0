"use strict";

function displayRacerChart(data) {
  var parseDate = d3.timeParse("%Y-%m-%d");

  racerData.forEach(function(d) {
    d.date = parseDate(d.date);
    d.time = +d.time;
  });

  racerData.sort(function(a, b) {
    return a.date - b.date;
  });

  var svg = d3.select("#racer_chart"),
     margin = {top: 20, right: 20, bottom: 30, left: 50},
     width = +svg.attr("width") - margin.left - margin.right,
     height = +svg.attr("height") - margin.top - margin.bottom,
     g = svg.append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");

  var line = d3.line()
      .x(function(d) { return x(d.date); })
      .y(function(d) { return y(d.time); });

  var tooltip = d3.select(".racer-chart").append("div")	
      .attr("class", "tooltip");
      
  // Get array of values from data array.
  function getValues(data, attribute) {
    array = [];
    data.forEach( function(d) {
      array.push(d[attribute])
    })
    return array;
  }

  var dates = getValues(racerData, "date");
  var times = getValues(racerData, "time");

  // Convert finish time (in seconds) to 
  // a formatted time string "00:00:00.0".
  function formatTime(seconds) {
    var m = Math.floor(seconds/60);
    var s = seconds % 60;
    var h = Math.floor(m/60);
    var m = m % 60;
    if (h < 10) {
      h = "0" + h.toString();
    } else {
      h = h.toString();
    }
    if (m < 10) {
      m = "0" + m.toString();
    } else {
      m = m.toString();
    }
    if (s < 10) {
      s = "0" + s.toString();
    } else {
      s = s.toString();
    }
    return h + ":" + m + ":" + s;
  }
  
  // Return a MM/DD/YYYY date from a JS date.
  // TO DO: Convert all dates to UTC and fix this up.
  // This is quite ugly.
  function formatDate(date) {
    return date.getMonth() + 1 + "/" + (parseInt(date.toString().split(" ")[2]) - 2).toString() + "/" + date.getFullYear();
  }

  // Get array of date values from data array.
  function getDates(data) {
    array = [];
    data.forEach( function(d) {
      array.push(d["date"])
    })
    return array;
  }

  // Get array of time values from data array.
  function getTimes(data) {
    array = [];
    data.forEach( function(d) {
      array.push(new Date(d["time"]))
    })
    return array;
  }

  var dates = getDates(data, "date");
  var times = getTimes(data, "time");

  var minTime = d3.min(times);
  var maxTime = d3.max(times);

  var minDate = new Date(d3.min(dates));
  var maxDate = new Date(d3.max(dates));

  var x = d3.scaleTime().range([0, width]);
  x.domain([minDate, maxDate]);
  var y = d3.scaleLinear().range([height, 0]);
  y.domain([minTime, maxTime]);

  var yAxis = d3.axisLeft(y)
    .tickFormat(function(d) { return formatTime(d); });

  g.append("g")
      .attr("transform", "translate(0," + height + ")")
      .call(d3.axisBottom(x))
    .select(".domain");

  g.append("g")
      .call(yAxis)
    .append("text")
      .attr("fill", "#000")
      .attr("transform", "rotate(-90)")
      .attr("y", 6)
      .attr("dy", "0.71em")
      .attr("text-anchor", "end")
      .text("Time");

  g.append("path")
      .datum(racerData)
      .attr("fill", "none")
      .attr("stroke", "grey")
      .attr("stroke-linejoin", "round")
      .attr("stroke-linecap", "round")
      .attr("stroke-width", 2.0)
      .attr("d", line);

  // Add scatter plot (dots).
  svg.selectAll("circle")
      .data(racerData)
    .enter().append("circle")
      .attr("r", 3)
      .attr("fill", function(d) { return d.group_name !== "Loop-Beer" ? "#787878" : "#00FF00"; })
      .attr("cx", function(d) { return x(d.date) + 50; })
      .attr("cy", function(d) { return y(d.time) + 20; })
      .attr("date", function(d) { return d.date; })
      .attr("time", function(d) { return d.time; })
      .on("mouseover", mouseover);

  // Handle what happens for a mouseover
  function mouseover(d) {
    var date = formatDate(new Date(d.date));
    var time = formatTime(Math.round(d.time), 2);
    var xPosition = d3.mouse(this)[0];
    var yPosition = d3.mouse(this)[1];
    var xGap = -10;
    var yGap = 5;
    tooltip.style("opacity", "1.0");
    // Position tooltip on data point and above dot.
    tooltip.style("left", xPosition + xGap + "px");
    tooltip.style("top", yPosition + yGap + "px");
    tooltip.html(time + "<br>" + date);
  }
}
