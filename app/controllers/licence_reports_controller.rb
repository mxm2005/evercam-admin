class LicenceReportsController < ApplicationController
  before_action :authorize_admin
  require "stripe"

  def index
    begin
      @customers = Stripe::Customer.all(limit: 200)
    rescue => error
      notify_airbrake(error)
    end
  end
end