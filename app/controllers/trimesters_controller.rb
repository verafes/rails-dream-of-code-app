class TrimestersController < ApplicationController
  def index
    @trimesters = Trimester.all
  end

  def show
    @trimester = Trimester.find(params[:id])
  end

  def new
  end

  def edit
  end
end
