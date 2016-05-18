# Migrate data from Fog-City-Run/data/

# Racers
grep "" racers.txt | cut -d" " -f2- | sed -e 's/ /,/' > input_racers.csv && { echo "first_name,last_name"; cat input_racers.csv; } > input_racers_final.csv

# Races
grep -v "race" data.tsv | cut -f1 > input_dates.csv && { echo "id,race"; cat input_dates.csv; } > input_dates_final.csv

# Plus, a jingle in Vim
# :'<,'>s/^/\=(line('.')-line("'<")+1).','/
