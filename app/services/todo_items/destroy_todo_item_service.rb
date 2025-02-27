module TodoItems
  class DestroyTodoItemService
    include Dry::Monads[:result]

    def initialize(todo_item)
      @todo_item = todo_item
    end

    def call
      if @todo_item.destroy
        Success(@todo_item)
      else
        Failure(@todo_item.errors.full_messages)
      end
    end
  end
end
