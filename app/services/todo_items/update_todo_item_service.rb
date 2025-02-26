module TodoItems
  class UpdateTodoItemService
    include Dry::Monads[:result]

    def initialize(todo_item, params)
      @todo_item = todo_item
      @params = params
    end

    def call
      if @todo_item.update(@params)
        Success(@todo_item)
      else
        Failure(@todo_item.errors.full_messages)
      end
    end
  end
end
