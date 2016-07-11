class LeaguesController < ApplicationController
  # GET /leagues
  def index
    @leagues = League.all
  end
end
