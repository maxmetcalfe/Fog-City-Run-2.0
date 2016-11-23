class ResultMailer < ApplicationMailer

  def results_email(result, email)
    @racer = Racer.find(result.racer_id)
    @race = Race.find(result.race_id)
    @user_email = User.where(:racer_id => @racer_id)
    @race_date = @race.date
    @race_rank = result.rank
    @race_time = result.time
    @race_url = 'http://fogcityrun.com/races/' + @race.id.to_s
    @racer_url = 'http://fogcityrun.com/racers/' + @racer.id.to_s
    mail(to: email, subject: "Fog City Run Results") do |format|
      format.text
    end
  end
end
