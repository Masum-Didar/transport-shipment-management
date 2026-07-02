class RoutesController < ApplicationController
  before_action :set_route, only: %i[edit update destroy]

  def index
    @routes = policy_scope(Route).kept.includes(:from_location, :to_location).order(:created_at)
  end

  def new
    @route = Route.new
    authorize @route
  end

  def create
    @route = Route.new(route_params)
    authorize @route
    if @route.save
      redirect_to routes_path, notice: "Route added successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @route.update(route_params)
      redirect_to routes_path, notice: "Route updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @route.discard!
    redirect_to routes_path, notice: "Route removed successfully."
  end

  private

  def set_route
    @route = Route.kept.find(params[:id])
    authorize @route
  end

  def route_params
    params.require(:route).permit(:from_location_id, :to_location_id, :distance_km, :estimated_hours, :notes)
  end
end
