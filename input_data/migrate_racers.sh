# Migrate racers from Fog-City-Run/data/racers.txt

grep "" racers.txt | cut -d" " -f2- | sed -e 's/ /,/' > input_racers.csv && { echo "first_name,last_name"; cat input_racers.csv; } > input_racers_final.csv

# To Join racers with results

# add id, to racers file
# and then run the following command in Vim:
# :'<,'>s/^/\=(line('.')-line("'<")+1).','/
