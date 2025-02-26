module TodoLists
  class CreateTodoList
    include Dry::Monads[:result]

    def initialize(params)
      @params = params
    end

    def call
      todo_list = TodoList.new(@params)

      if todo_list.save
        Success(todo_list)
      else
        Failure(todo_list.errors.full_messages)
      end
    end
  end
end
