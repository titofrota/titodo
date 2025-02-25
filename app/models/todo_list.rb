class TodoList < ApplicationRecord
  has_many :items, class_name: "TodoItem", dependent: :destroy

  validates :name, presence: true
end
