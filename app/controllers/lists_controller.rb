class ListsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_list, only: %i[ show edit update destroy ]

  # GET /lists or /lists.json
  def index
    order = params[:order]
    flat_mode = params[:flat_mode].present?

    if flat_mode
      # Listas soltas, sem agrupamento por pasta
      @lists = current_user.lists.includes(:tasks)
      if order == 'priority'
        @lists = @lists.left_joins(:tasks).group('lists.id').order(Arel.sql('COALESCE(MAX(tasks.priority), 0) DESC'))
      elsif order == 'due_date'
        @lists = @lists.left_joins(:tasks).group('lists.id').order(Arel.sql('MIN(tasks.due_date) ASC NULLS LAST'))
      else
        @lists = @lists.order(:name)
      end
      @folders = []
    else
      # Agrupado por pasta
      @folders = current_user.folders.includes(lists: :tasks).to_a
      if order == 'priority'
        @folders.sort_by! do |folder|
          -(folder.lists.map { |l| l.tasks.maximum(:priority) || 0 }.max || 0)
        end
      elsif order == 'due_date'
        @folders.sort_by! do |folder|
          folder.lists.map { |l| l.tasks.minimum(:due_date) || Date.new(3000,1,1) }.min
        end
      else
        @folders.sort_by!(&:name)
      end
    end

    current_month = Time.current.beginning_of_month..Time.current.end_of_month

    @monthly_tasks = current_user.tasks.where("due_date IS NULL OR due_date BETWEEN ? AND ?", Time.current.beginning_of_month, Time.current.end_of_month)
    @completed_monthly_tasks = @monthly_tasks.where(completed: true)
  end

  # GET /lists/1 or /lists/1.json
  def show
  end

  # GET /lists/new
  def new
    @list = List.new
  end

  # GET /lists/1/edit
  def edit
  end

  # POST /lists or /lists.json
  def create
    @list = current_user.lists.build(list_params)

    respond_to do |format|
      if @list.save
        format.html { redirect_to @list, notice: "List was successfully created." }
        format.json { render :show, status: :created, location: @list }
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @list.errors, status: :unprocessable_entity }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("list-modal-#{@list.folder_id}", partial: 'lists/form', locals: { list: @list, folder: @list.folder }) }
      end
    end
  end


  # PATCH/PUT /lists/1 or /lists/1.json
  def update
    respond_to do |format|
      if @list.update(list_params)
        format.html { redirect_to @list, notice: "List was successfully updated." }
        format.json { render :show, status: :ok, location: @list }
        format.turbo_stream
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @list.errors, status: :unprocessable_entity }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("list-edit-modal-#{@list.id}", partial: 'lists/edit_form', locals: { list: @list }) }
      end
    end
  end

  # DELETE /lists/1 or /lists/1.json
  def destroy
    @list.destroy!

    respond_to do |format|
      format.html { redirect_to lists_path, status: :see_other, notice: "List was successfully destroyed." }
      format.json { head :no_content }
      format.turbo_stream
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_list
      @list = current_user.lists.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def list_params
    params.require(:list).permit(:name, :description, :folder_id)
  end
end
