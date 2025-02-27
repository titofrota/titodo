module TodoLists
  class DestroyTodoListService
    include Dry::Monads[:result]

    def initialize(todo_list)
      @todo_list = todo_list
    end

    def call
      if @todo_list.destroy
        Success(@todo_list)
      else
        Failure(@todo_list.errors.full_messages)
      end
    end
  end
end
