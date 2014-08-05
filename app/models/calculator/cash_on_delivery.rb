# module Spree
  class Calculator::CashOnDelivery < Spree::Calculator
    def self.description
      I18n.t("cash_on_delivery")
    end

    # def self.register
    #   super
    #   ShippingMethod.register_calculator(self)
    # end

    def compute(object)
      0
    end
  end
# end
