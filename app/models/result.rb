class Result < ActiveRecord::Base
  belongs_to :racer
  belongs_to :race
  after_destroy :update_racer_info
  after_save :update_racer_info

  validates :rank, presence: true
  validates :bib, presence: true
  validates :racer_id, presence: true
  validates :group_name, presence: true
  validates :time, presence: true
  validates :race_id, presence: true
  validates :bib, numericality: { only_integer: true }
  validates :bib, numericality: { :greater_than_or_equal_to => 0 }
  validates :rank, numericality: { only_integer: true }
  validates :rank, numericality: { :greater_than_or_equal_to => 0 }
  validates :racer_id, numericality: { only_integer: true }
  validates :racer_id, numericality: { :greater_than_or_equal_to => 0 }
  validates :race_id, numericality: { only_integer: true }
  validates :race_id, numericality: { :greater_than_or_equal_to => 0 }
end

def update_racer_info
  racer = Racer.find(self.racer_id)
  racer.update_attribute(:race_count, racer.results.count)
  racer.update_attribute(:fav_bib, racer.results.includes(:race).order("races.date DESC").pluck(:bib).first)

  update_streak_calendar(racer)
end

def update_streak_calendar(racer)
  open_dates = []
  open_dates = open_dates.push '2013-01-16'.to_date
  while open_dates[-1] < Date.today - 1.week
    open_dates = open_dates.push open_dates[-1].advance(:weeks => 1)
  end
  races_run = racer.results.joins(:race).map {|result| race.date }
  longest_streak_count = 0
  longest_streak = []
  current_streak_count = 0
  current_streak = []
  for o in open_dates
    found = 0
    for r in races_run
      if o == r
        current_streak = current_streak.push r
        if current_streak.length > longest_streak_count
          longest_streak_count = current_streak.length
          longest_streak = current_streak
        end
        found = 1
        if open_dates[-1] == current_streak[-1]
          current_streak_count = current_streak.length
        end
      end
    end
    if found == 0
      current_streak = []
    end
  end
  attributes = {
    :longest_streak => longest_streak.length,
    :current_streak => current_streak.length,
    :longest_streak_array => longest_streak,
    :current_streak_array => current_streak
  }
  racer.update_attributes(attributes)
  return attributes
end