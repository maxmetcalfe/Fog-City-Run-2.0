class SaveRaceJob < ApplicationJob
  queue_as :default

  def perform(race_id)
    race = Race.find(race_id)
    racer_ids = race.results.pluck(:racer_id)
    streak_racer_ids = Racer.where("current_streak > 0 OR longest_streak > 0").pluck(:id)
    racer_ids_to_update = (racer_ids + streak_racer_ids).uniq

    race_counts = Result.where(racer_id: racer_ids_to_update).group(:racer_id).count
    latest_bibs_by_racer = {}
    Result.joins(:race)
          .where(racer_id: racer_ids_to_update)
          .order("results.racer_id ASC, races.date DESC")
          .pluck("results.racer_id", "results.bib")
          .each do |racer_id, bib|
      latest_bibs_by_racer[racer_id] ||= bib
    end

    Racer.where(id: racer_ids_to_update).find_each do |racer|
      racer.update_columns(
        race_count: race_counts[racer.id] || 0,
        fav_bib: latest_bibs_by_racer[racer.id]
      )
      update_streak_calendar(racer)
    end

    race.update(state: 'FINISHED')
  end
end
