namespace :racer_utils do
  desc "Manually update all racers"
  task update_racers: :environment do
    results = Result.all
    count = results.count
    i = 0
    for r in results
      r.save!
      i = i + 1
      puts i.to_s + "/" + count.to_s
    end
  end

end
