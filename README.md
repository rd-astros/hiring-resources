## Sample code below has been tested successfully in a JSFiddle:
### https://jsfiddle.net/rxnus3p7/2/

## Ajax call to fetch players
    var players = [];
    $.ajax({
      type: "GET",
      url: "https://raw.githubusercontent.com/rd-astros/hiring-resources/master/players.json",
      data: [],
      success: function(res) {
        var json = $.parseJSON(res);
  	    players = json.queryResults.row;
      }
    });

## Ajax call to fetch pitches for one game (pk = 565609)
    $.ajax({
      type: "GET",
      url: "https://raw.githubusercontent.com/rd-astros/hiring-resources/master/game_565609.json",
      data: [],
      success: function(res) {
        var json = $.parseJSON(res);
        var pitches = json.queryResults.row;
      }
    });
