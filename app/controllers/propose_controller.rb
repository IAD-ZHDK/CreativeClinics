class ProposeController < ApplicationController
  before_action :authenticate_user!

  def new
    @clinic = prepare
  end

  def create
    @clinic = prepare
    @clinic.assign_attributes(permitted_params[:clinic])
    if @clinic.save
      current_user.vote!(@clinic)
      redirect_to clinic_path(@clinic)
    else
      render 'new'
    end
  end

  protected

  def prepare
    @clinic = Clinic.new
    @clinic.proposer = current_user
    @clinic.proposed_at = Time.now
    @clinic
  end

  def permitted_params
    params.permit(clinic: [:title, :description, :required_votes])
  end
end
