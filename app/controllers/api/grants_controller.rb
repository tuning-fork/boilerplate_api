class Api::GrantsController < ApplicationController

  def index
    @grants = Grant.all

    @grants = @grants.order(id: :asc)
    
    render 'index.json.jb'
    
  end 

  
end
