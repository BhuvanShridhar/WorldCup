// from data.js
var tableData = [
  {
    datetime: "2022-01-01 00:00:00",
    city: "New York",
    state: "NY",
    country: "US",
    shape: "Circle"
  },
  {
    datetime: "2022-01-02 12:00:00",
    city: "Los Angeles",
    state: "CA",
    country: "US",
    shape: "Triangle"
  }
];

var tbody = d3.select("#tbody");

tableData.forEach((UFOsighting) => {
  var row = tbody.append("tr");
  Object.entries(UFOsighting).forEach(([key, value]) => {
    var cell = tbody.append("td");
    cell.text(value);
  })
});

var FilterTable = d3.select("#filter-btn");
FilterTable.on("click", function() {
  // Prevent the page from refreshing
  d3.select("#tbody")
 .append("tr")
 .text("New row");
 d3.csv("data.csv", function(data) {
  d3.select("#chart")
   .selectAll("div")
   .data(data)
   .enter()
   .append("div")
   .style("width", function(d) { return d.value + "px"; })
   .text(function(d) { return d.name; });
});
  d3.event.preventDefault();

  // Get the value property of the input element
  var inputValueD = d3.select("#datetime").property("value");
  var inputValueCi = d3.select("#city").property("value");
  var inputValueSt = d3.select("#state").property("value");
  var inputValueCo = d3.select("#country").property("value");
  var inputValueSh = d3.select("#shape").property("value");

  console.log(inputValueD);
  console.log(inputValueCi);
  console.log(inputValueSt);
  console.log(inputValueCo);
  console.log(inputValueSh);

  var filteredData = tableData;

  if (inputValueD!== "") {
    filteredData = filteredData.filter((tdata1) => tdata1.datetime === inputValueD);
  }
  if (inputValueCi!== "") {
    filteredData = filteredData.filter((tdata2) => tdata2.city === inputValueCi);
  }
  if (inputValueSt!== "") {
    filteredData = filteredData.filter((tdata3) => tdata3.state === inputValueSt);
  }
  if (inputValueCo!== "") {
    filteredData = filteredData.filter((tdata4) => tdata4.country === inputValueCo);
  }
  if (inputValueSh!== "") {
    filteredData = filteredData.filter((tdata5) => tdata5.shape === inputValueSh);
  }

  console.log(filteredData);

  tbody.text("");
  filteredData.forEach((UFOsighting) => {
    var row = tbody.append("tr");
    Object.entries(UFOsighting).forEach(([key, value]) => {
      var cell = tbody.append("td");
      cell.text(value);
    })
  })
});