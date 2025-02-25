class TodoItem < ApplicationRecord
  belongs_to :todo_list

  validates :name, presence: true

  validates :due_date, comparison: { greater_than_or_equal_to: Date.today }, if: :due_date


  scope :completed, -> { where(completed: true) }
  scope :pending, -> { where(completed: false) }
end
