/*global test:true, equal:true, notEqual:true */

var expectedBatmanMatches = 9;

test("Simple search", function(){
    equal(Factlink.search("Batman").length, expectedBatmanMatches, "Found Batman nine times");
    equal(Factlink.search("character").length, 2, "Found character once");
    equal(Factlink.search("spiderman").length, 0, "No results for spiderman");

    equal(document.getSelection().rangeCount, 0, "Selection has been reset");
});

test("Search with ranges", function(){
    var selection = document.getSelection();
    var range = document.createRange();
    range.selectNode($('#search-test p')[0]);
    selection.addRange(range);

    equal(Factlink.search("Batman").length, expectedBatmanMatches, "Found Batman twice with selected text");

    notEqual(selection.rangeCount, 0, "Rangecount is bigger then one");
    equal($.trim(selection.getRangeAt(0).toString()), range.toString(), "Range was reset");
});