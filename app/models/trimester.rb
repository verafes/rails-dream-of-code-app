class Trimester < ApplicationRecord
  has_many :courses

  def display_name
    "#{term} #{year}"
  end

  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :application_deadline, presence: true
end
