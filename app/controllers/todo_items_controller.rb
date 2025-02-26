class TodoItemsController < ApplicationController
  include Dry::Monads[:result]

  before_action :set_todo_list
  before_action :set_todo_item, only: %i[ show edit update destroy ]

  # GET /todo_items or /todo_items.json
  def index
    @todo_items = @todo_list.items.order(created_at: :desc)
  end

  # GET /todo_items/1 or /todo_items/1.json
  def show
  end

  # GET /todo_items/new
  def new
    @todo_item = @todo_list.items.new
  end

  # GET /todo_items/1/edit
  def edit
    render partial: "edit", locals: { todo_item: @todo_item }
  end

  # POST /todo_items or /todo_items.json
  def create
    result = TodoItems::CreateTodoItemService.new(@todo_list, todo_item_params).call
    
    case result
    when Success
      @todo_item = result.success # Store the created item

      respond_to do |format|
        format.turbo_stream
        # format.html { redirect_to @todo_list, notice: 'Todo item was successfully created.' }
      end
    when Failure
      render :new, status: :unprocessable_entity, locals: { errors: result.failure }
    end
  end

  # PATCH/PUT /todo_items/1 or /todo_items/1.json
  def update
    respond_to do |format|
      if @todo_item.update(todo_item_params)
        format.turbo_stream { }
        format.json { render :show, status: :ok, location: @todo_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @todo_item.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /todo_items/1 or /todo_items/1.json
  def destroy
    @todo_item.destroy!

    respond_to do |format|
      format.turbo_stream { }
      # format.html { redirect_to todo_items_path, status: :see_other, notice: "Todo item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def set_todo_list
      @todo_list = TodoList.find(params[:todo_list_id])
    end

    def set_todo_item
      @todo_item = TodoItem.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def todo_item_params
      params.require(:todo_item).permit(:name, :completed, :due_date)
    end
end
