## Sample code below has been tested successfully in a JSFiddle:

### https://jsfiddle.net/psrnbc3m/

## Ajax call to fetch pitches

    $.ajax({
      type: "GET",
      url: "https://raw.githubusercontent.com/rd-astros/hiring-resources/master/pitches.json",
      data: [],
      success: function(res) {
        const json = $.parseJSON(res);
        const pitches = json.queryResults.row;
      }
    });
