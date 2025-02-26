class TodoListsController < ApplicationController
  include Dry::Monads[:result]

  before_action :set_todo_list, only: %i[ show edit update destroy ]

  # GET /todo_lists or /todo_lists.json
  def index
    @todo_lists = TodoList.all
  end

  # GET /todo_lists/1 or /todo_lists/1.json
  def show
    @todo_items = case params[:filter]
    when "completed"
                    @todo_list.items.completed
    when "pending"
                    @todo_list.items.pending
    else
                    @todo_list.items
    end

    if turbo_frame_request?
      render @todo_items
    else
      render :show
    end
  end

  # GET /todo_lists/new
  def new
    @todo_list = TodoList.new

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  # GET /todo_lists/1/edit
  def edit
    render partial: "edit", locals: { todo_list: @todo_list }
  end

  # POST /todo_lists or /todo_lists.json
  def create
    result = TodoLists::CreateTodoListService.new(todo_list_params).call
  
    case result
    when Success
      respond_to do |format|
        format.html { redirect_to todo_lists_path, notice: "Todo list was successfully created." }
        format.turbo_stream
      end
    when Failure
      render :new, status: :unprocessable_entity, locals: { errors: result.failure }
    end
  end  


  # PATCH/PUT /todo_lists/1 or /todo_lists/1.json
  def update
    result = TodoLists::UpdateTodoListService.new(@todo_list, todo_list_params).call

    case result
    when Success
      respond_to do |format|
        format.html { redirect_to todo_lists_path, notice: "Todo list was successfully updated." }
        format.turbo_stream
      end
    when Failure
      render :edit, status: :unprocessable_entity, locals: { errors: result.failure }
    end
  end

  # DELETE /todo_lists/1 or /todo_lists/1.json
  def destroy
    @todo_list.destroy!

    respond_to do |format|
      format.html { redirect_to todo_lists_path, status: :see_other, notice: "Todo list was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_todo_list
      @todo_list = TodoList.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def todo_list_params
      params.expect(todo_list: [ :name ])
    end
end
