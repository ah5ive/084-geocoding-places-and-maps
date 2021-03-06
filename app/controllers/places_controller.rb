class PlacesController < ApplicationController
  before_action :set_place, only: [:show, :edit, :update, :destroy]

  def get_locations
    url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{params[:latitude]},#{params[:longitude]}&radius=500&key=#{Rails.application.secrets.google_places_key}"
    http_call = open(url).read
    response = JSON.parse(http_call, {:symbolize_names => true})
    @locations = response[:results]
  end

  def index
    @places = Place.all
  end

  def show
  end

  def new
    @place = Place.new
  end

  def edit
  end

  def create
    @place = Place.create(place_params)
    respond_to do |format|
      if @place.save
        format.html { redirect_to @place, notice: 'Place was successfully created.' }
        format.js {}
      else
        format.html { render :new }
        format.js {}
      end
    end
  end

  def update
    respond_to do |format|
      if @place.update(place_params)
        format.html { redirect_to @place, notice: 'Place was successfully updated.' }
        format.json { render :show, status: :ok, location: @place }
      else
        format.html { render :edit }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @place.destroy
    respond_to do |format|
      format.html { redirect_to places_url, notice: 'Place was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
 
    def set_place
      @place = Place.find(params[:id])
    end

 
    def place_params
      params.require(:place).permit(:name, :address)
    end
end
