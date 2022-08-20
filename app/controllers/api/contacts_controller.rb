# frozen_string_literal: true

module Api
  class ContactsController < ApplicationController
    def index
      @contacts = Contact
                  .order(:name)

      render 'index.json.jb'
    end

    def create
      @contact = Contact.create!(
        name: params[:name],
        title: params[:title],
        email: params[:email],
        organization_name: params[:organization_name],
        message: params[:message]
      )
      logger.info("New contact #{@contact} created")
      @contact.send_contact_email(@contact)
      render 'show.json.jb', status: :created
    end

    def show
      @contact = Contact.find_by!(id: params[:id])
      render 'show.json.jb'
    end

    def destroy
      @contact = Contact.find_by!(id: params[:id])
      @contact.destroy!

      render 'show.json.jb'
    end
  end
end
