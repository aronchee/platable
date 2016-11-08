class MapsController < ApplicationController
  before_action :set_map, only: [:show, :edit, :update, :destroy]
  
  # GET /maps/new
  def new
    @map = Map.new
  end

  # POST /maps
  # POST /maps.json
  def create
    @map = Map.new(map_params)
    # byebug
    respond_to do |format|
      if @map.save
        format.html { redirect_to @map, notice: 'Map was successfully created.' }
        format.json { render :show, status: :created, location: @map }
      else
        format.html { render :new }
        format.json { render json: @map.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /maps
  # GET /maps.json
  def index

    @maps = Map.all
    @hash = Gmaps4rails.build_markers(@maps) do |map, marker|
      map_path = view_context.link_to map.title, map_path(map)
      marker.lat map.latitude
      marker.lng map.longitude
      marker.infowindow "<b>#{map_path}</b>"
    end
    # @json = Map.all.to_gmaps4rails do |map, marker|
    #   marker.json({:title => map.title, :address => map.address})
    # end
  end
  # GET /maps/1
  # GET /maps/1.json
  def show
  end

  # GET /maps/1/edit
  def edit
  end

  def update
    respond_to do |format|
      if @map.update(map_params)
        format.html { redirect_to @map, notice: 'Map was successfully updated.' }
        format.json { render :show, status: :ok, location: @map }
      else
        format.html { render :edit }
        format.json { render json: @map.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @map.destroy
    respond_to do |format|
      format.html { redirect_to maps_url, notice: 'Map was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_map
      @map = Map.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def map_params
      params.require(:map).permit(:longitude, :latitude, :address)
    end

end
