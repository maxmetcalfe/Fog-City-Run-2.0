# Migrate data from Fog-City-Run/data/

# Racers
grep "" racers.txt | cut -d" " -f2- | rev | sed -e 's/ /,/' | rev > input_racers.csv && { echo "id,first_name,last_name"; cat input_racers.csv; } > input_racers_final.csv

# Races
grep -v "race" data.tsv | cut -f1 > input_dates.csv && { echo "id,race"; cat input_dates.csv; } > input_dates_final.csv

# Results
grep "" data.js | sed -e 's/\[//g' -e 's/\]//g' -e "s/'//g" -e 's/,$//g' | grep -v "aDataSet\|;" > input_results.csv
rank,bib,racer_id,group,time,race_id

# Plus, a jingle in Vim
# :'<,'>s/^/\=(line('.')-line("'<")+1).','/
