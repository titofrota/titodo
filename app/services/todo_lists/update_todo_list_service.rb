module TodoLists
  class UpdateTodoListService
    include Dry::Monads[:result]

    def initialize(todo_list, params)
      @todo_list = todo_list
      @params = params
    end

    def call
      if @todo_list.update(@params)
        Success(@todo_list)
      else
        Failure(@todo_list.errors.full_messages)
      end
    end
  end
end
