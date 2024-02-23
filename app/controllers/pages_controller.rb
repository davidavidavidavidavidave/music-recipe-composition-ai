class PagesController < ApplicationController
  def home
  end

  def index
    @composition = Composition.all
end
