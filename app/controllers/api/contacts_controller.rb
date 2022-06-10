class Api::ContactsController < ApplicationController
  
    def index
      @contacts = Contact
        .order(:name)
  
      render "index.json.jb"
    end
  
    def create
      @contact = Contact.create!(
        name: params[:name],
        users: [current_user],
      )
      logger.info("New organization #{@contact} created by #{current_user}")
      render "show.json.jb", status: 201
    end
  
    def show
      @contact = Contact.find_by!(id: params[:id])
      render "show.json.jb"
    end
  
    def destroy
      @contact = Contact.find_by!(id: params[:id])
      @contact.destroy!
  
      render "show.json.jb"
    end
  end
  