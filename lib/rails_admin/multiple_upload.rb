require "rails_admin_multiple_upload/engine"

module RailsAdminMultipleUpload
  # Your code goes here...
end

require 'rails_admin/config/actions'

module RailsAdmin
  module Config
    module Actions
      class MultipleUpload < Base
        RailsAdmin::Config::Actions.register(self)
        register_instance_option :member do
          true
        end

        register_instance_option :link_icon do
          'icon-upload'
        end

        register_instance_option :http_methods do
          [:get, :post, :delete]
        end

        register_instance_option :controller do
          Proc.new do
            @response = {}
            if request.get?
              @game = Game.find(params[:id])
              render :action => @action.template_name
            end
            if request.delete?
              @game = Game.find(params[:id])
              Photo.find(params[:pid]).destroy
              redirect_to(:back)
            end
            if request.post?
              @game = Game.find_by_id(params[:game_id])
              params[:game][:photos_attributes].each do |image|
                photo = Photo.create(image: image[:image])
                @game.photos << photo
              end
              render :action => @action.template_name
            end




          end
        end
      end
    end
  end
end

