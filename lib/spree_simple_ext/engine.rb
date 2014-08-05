module SpreeSimpleExt
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_simple_ext'

    config.autoload_paths += %W(#{config.root}/lib)

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

      # Calculator::SelfDelivery.register
      # Calculator::CashOnDelivery.register
      # Calculator::Juridical.register
      # PaymentMethod::SberBankInvoice.register
      # PaymentMethod::JuridicalInvoice.register

      String.class_eval do
        def to_url
          self.parameterize
        end
      end

      # добавить событие для перехода от шага доставки к шагу подтверждения, минуя шаг оплаты
      confirm_event = StateMachine::Event.new(Spree::Order.state_machine, :confirm_without_payment)
      confirm_event.transition :to => 'confirm'
      Spree::Order.state_machine.events << confirm_event

      # переопределение события :next для отображения шага подтверждения в любом случае
      next_event = StateMachine::Event.new(Spree::Order.state_machine, :next)
      next_event.transition :from => 'cart',     :to => 'address'
      next_event.transition :from => 'address',  :to => 'delivery'
      next_event.transition :from => 'delivery', :to => 'payment'
      next_event.transition :from => 'payment',  :to => 'confirm'
      next_event.transition :from => 'confirm',  :to => 'complete'
      Spree::Order.state_machine.events << next_event
    end



    config.to_prepare &method(:activate).to_proc

    initializer "spree.register.calculators" do |app|
      if app.config.spree.calculators.shipping_methods
        classes = Dir.chdir File.join(File.dirname(__FILE__), "../../app/models") do
          Dir["calculator/*.rb"].map do |path|
            path.gsub('.rb', '').camelize.constantize
          end
        end

        app.config.spree.calculators.shipping_methods.concat classes
      end
    end

    # initializer 'spree.register.calculators' do |app|
    #   app.config.spree.calculators.shipping_methods << Spree::Calculator::SelfDelivery
    # end

    initializer "spree.register.payment_methods" do |app|
      app.config.spree.payment_methods.push( PaymentMethod::SberBankInvoice, PaymentMethod::JuridicalInvoice )
    end
  end
end
