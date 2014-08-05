module Spree
  class Admin::SimpleSettingsController < Admin::BaseController
    before_filter :load_configuration, :only => [:edit, :update]
    
    def show
      @simple_configuration = Spree::SpreeSimpleExt::Config.get
    end
    
    def update
      contacts_preferences = params[:preferences][:contacts]    
      Spree::Config.set(contacts_preferences)

      if @simple_configuration.update_attributes(params[:simple_configuration])
        Spree::SpreeSimpleExt::Config.set
        redirect_to admin_simple_settings_url
      else
        render 'edit'
      end
    end
    
    private
    
    def load_configuration
      @simple_configuration = Spree::SpreeSimpleExt::Config.instance
    end
  end
end