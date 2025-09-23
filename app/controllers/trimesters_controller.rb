class TrimestersController < ApplicationController
  before_action :set_trimester, only: [:show, :edit, :update]
  before_action only: [:new, :create, :edit, :update, :destroy] do
    require_role(["admin"])
  end

  def index
    @trimesters = Trimester.all
  end

  def show
  end

  def new
    @trimester = Trimester.new
  end

  def edit
  end

  def create
    @trimester = Trimester.new(trimester_params)

    respond_to do |format|
      if @trimester.save
        format.html { redirect_to @trimester, notice: 'Trimester was successfully created.' }
        format.json { render :show, status: :created, location: @trimester }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @trimester.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @trimester.nil?
      render plain: "Trimester not found", status: :not_found
    elsif params[:trimester][:application_deadline].blank?
      render plain: "Application deadline required", status: :bad_request
    elsif !valid_date?(params[:trimester][:application_deadline])
      render plain: "Invalid date format", status: :bad_request
    elsif @trimester.update(trimester_params)
      redirect_to @trimester, notice: "Trimester was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_trimester
    @trimester = Trimester.find_by(id: params[:id])
  end

  def trimester_params
    params.require(:trimester).permit(:year, :term, :application_deadline, :start_date, :end_date)
  end

  def valid_date?(date_string)
    Date.parse(date_string)
    true
  rescue ArgumentError
    false
  end
end
