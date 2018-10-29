require_relative "../utils"

namespace :racer_utils do
  desc "Manually update all racers"
  task update_racers: :environment do
    racers = Racer.all
    count = racers.count
    i = 0
    for r in racers
      update_racer_info(r)
      i = i + 1
      puts i.to_s + "/" + count.to_s
    end
  end

end
