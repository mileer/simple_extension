# module Spree
  class Calculator::Juridical < Spree::Calculator
    def self.description
      I18n.t("juridical_invoice")
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