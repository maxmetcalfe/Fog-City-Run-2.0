class ResultMailer < ApplicationMailer

  def reformat_date(str)
    date_list = str.split('-')
    return [date_list[1], date_list[-1], date_list[0]].join("/")
  end

  def results_email(result, email)
    @racer = Racer.find(result.racer_id)
    @race = Race.find(result.race_id)
    @user_email = User.where(:racer_id => @racer_id)
    @race_date = reformat_date(@race.date.to_s)
    @race_rank = result.rank
    @race_time = result.time
    @race_url = 'https://www.fogcityrun.com/races/' + @race.id.to_s
    @racer_url = 'https://www.fogcityrun.com/racers/' + @racer.id.to_s
    mail(to: email, subject: "Fog City Run Results") do |format|
      format.text
    end
  end
end
