class CompositionsController < ApplicationController
  before_action :set_composition, only: %i[ show edit update destroy ]

  # GET /compositions
  def index
    @compositions = Composition.all
  end

  # GET /compositions/1
  def show
    client = OpenAI::Client.new
    response = client.chat(parameters: {
      model: "gpt-3.5-turbo",
      messages: [{
        role: "user",
        content: "Give me a music composition with instruments #{@composition.instruments}. It has musical elements #{@composition.description}. identify the chords and melody notes and the rhythm values (like crotchets and quavers etc.). Give it a title"
        }]
    })
    @content = response["choices"][0]["message"]["content"]
  end

  # GET /compositions/new
  def new
    @composition = Composition.new
  end

  # GET /compositions/1/edit
  def edit
  end

  # POST /compositions
  def create
    @composition = Composition.new(composition_params)

    if @composition.save
      redirect_to @composition, notice: "Composition was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /compositions/1
  def update
    if @composition.update(composition_params)
      redirect_to @composition, notice: "Composition was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /compositions/1
  def destroy
    @composition.destroy
    redirect_to compositions_url, notice: "Composition was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_composition
      @composition = Composition.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def composition_params
      params.require(:composition).permit(:name, :instruments, :description)
    end
end
