module TodoItems
  class CreateService
    include Dry::Monads[:result]

    def initialize(todo_list, params)
      @todo_list = todo_list
      @params = params
    end

    def call
      todo_item = @todo_list.items.new(@params)

      if todo_item.save
        Success(todo_item)
      else
        Failure(todo_item.errors.full_messages)
      end
    end
  end
end
