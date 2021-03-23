class PatientsController < ApplicationController

  def index
    @patients = Patient.all
  end

  def create
    PayloadSync::Payload.sync!

    redirect_to root_url, notice: "Patient lab created."
  end
end
