git checkout -- game_565609.json game_566664.json game_566767.json

for x in game*; do tr -d '\r' <$x >xxx && mv xxx $x; done

for x in game*; do sed -i 's/  "_/  "/' $x; done

for x in game*; do sed -i 's/"top_inning_sw": "Y"/"inning_half": "0"/' $x; done
for x in game*; do sed -i 's/"top_inning_sw": "N"/"inning_half": "1"/' $x; done

for x in game*
do
  cat $x | gawk -F'\t' '
    BEGIN {
      while ((getline < "players.txt") > 0) {
	if (NF != 2) {
	  print "ERROR: Incorrect number of fields (" NF ") in line from players.txt: " $0 > "/dev/stderr";
	  exit(1);
	}
	name[$1] = $2;
      }
      close("players.txt");
    }

    {
      print;
      if (/"game_id":/) {
        id = $0;
        sub(/^.*: "/, "", id);
        sub(/",/, "", id);
        if (id == "2019/04/02/houmlb-texmlb-1") {
          away_team_name = "Houston Astros";
          away_team_code = "HOU";
          home_team_name = "Texas Rangers";
          home_team_code = "TEX";
        }
        else if (id == "2019/03/28/houmlb-tbamlb-1") {
          away_team_name = "Houston Astros";
          away_team_code = "HOU";
          home_team_name = "Tampa Bay Rays";
          home_team_code = "TB";
        }
        else if (id == "2019/04/08/nyamlb-houmlb-1") {
          away_team_name = "New York Yankees";
          away_team_code = "NYY";
          home_team_name = "Houston Astros";
          home_team_code = "HOU";
        }
        else {
	  print "ERROR: Did not recognize game id " id " in " FILENAME > "/dev/stderr";
          exit(1);
        }
        printf "            \"away_team_name\": \"%s\",\n", away_team_name;
        printf "            \"away_team_code\": \"%s\",\n", away_team_code;
        printf "            \"home_team_name\": \"%s\",\n", home_team_name;
        printf "            \"home_team_code\": \"%s\",\n", home_team_code;
      }
      else if (/"inning_half":/) {
        id = $0;
        sub(/^.*: "/, "", id);
        sub(/",/, "", id);
        if (id == "0") {
          batting_team_name = away_team_name;
          batting_team_code = away_team_code;
          fielding_team_name = home_team_name;
          fielding_team_code = home_team_code;
        }
        else if (id == "1") {
          batting_team_name = home_team_name;
          batting_team_code = home_team_code;
          fielding_team_name = away_team_name;
          fielding_team_code = away_team_code;
        }
        else {
	  print "ERROR: Did not recognize inning half code " id " in " FILENAME > "/dev/stderr";
          exit(1);
        }
        printf "            \"batting_team_name\": \"%s\",\n", batting_team_name;
        printf "            \"batting_team_code\": \"%s\",\n", batting_team_code;
        printf "            \"fielding_team_name\": \"%s\",\n", fielding_team_name;
        printf "            \"fielding_team_code\": \"%s\",\n", fielding_team_code;
      }
      else if (/"batter_id":/) {
        id = $0;
        sub(/^.*: "/, "", id);
        sub(/",/, "", id);
        if (!(id in name)) {
	  print "ERROR: Did not recognize batter id " id " in " FILENAME > "/dev/stderr";
          exit(1);
        }
        printf "            \"batter_name\": \"%s\",\n", name[id];
      }
      else if (/"pitcher_id":/) {
        id = $0;
        sub(/^.*: "/, "", id);
        sub(/",/, "", id);
        if (!(id in name)) {
	  print "ERROR: Did not recognize pitcher id " id " in " FILENAME > "/dev/stderr";
          exit(1);
        }
        printf "            \"pitcher_name\": \"%s\",\n", name[id];
      }
    }
  ' >xxx-$x
  mv xxx-$x $x
done
