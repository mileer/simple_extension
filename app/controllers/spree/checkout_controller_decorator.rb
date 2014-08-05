Spree::CheckoutController.class_eval do
  helper Spree::AddressesHelper

  after_filter :normalize_addresses, :only => :update
  before_filter :set_addresses, :only => :update

  private

  def after_payment
    if @order.shipping_method.calculator.is_a?(Calculator::CashOnDelivery)
      @order.payments.build(:payment_method => PaymentMethod.internal, :amount => @order.total)
      @order.confirm_without_payment!
    end
  end
  
  def before_delivery
    if current_user && current_user.juridical?
      @order.rate_hash.delete_if { |rh| rh[:shipping_method].calculator.class.name == "Calculator::CashOnDelivery" }
    end
  end
  
  def before_payment
    if current_user && current_user.juridical?
      if Spree::Synergy::Config[:juridical_enabled]
        # keep only juridical pm
        @order.available_payment_methods.delete_if { |pm| pm.class.name != "PaymentMethod::JuridicalInvoice" }
      else
        redirect_to account_url, :notice => t('juridical_disabled')
      end
    else
      # delete juridical pm for normal users
      @order.available_payment_methods.delete_if { |pm| pm.class.name == "PaymentMethod::JuridicalInvoice" }
    end
  end

  protected

    def set_addresses
      return unless params[:order] && params[:state] == "address"

      if params[:order][:ship_address_id].to_i > 0
        params[:order].delete(:ship_address_attributes)
        Spree::Address.find(params[:order][:ship_address_id]).user_id != spree_current_user.id && raise("Frontend address forging")
      else
        params[:order].delete(:ship_address_id)
      end

      if params[:order][:bill_address_id].to_i > 0
        params[:order].delete(:bill_address_attributes)
        bill = Spree::Address.find(params[:order][:bill_address_id])
        bill.user_id != spree_current_user.id && raise("Frontend address forging")
        @order.bill_address = bill;
        @order.bill_address.save;
      else
        params[:order].delete(:bill_address_id)
      end

    end

    def normalize_addresses
      return unless params[:state] == "address" && @order.bill_address_id && @order.ship_address_id
      return if (@order.bill_address.id.nil? || @order.ship_address.nil?)

      @order.bill_address.reload
      @order.ship_address.reload

      # ensure that there is no validation errors and addresses was saved
      return unless @order.bill_address && @order.ship_address
      if @order.bill_address_id != @order.ship_address_id && @order.bill_address.same_as?(@order.ship_address)
        @order.bill_address.destroy
        @order.update_attribute(:bill_address_id, @order.ship_address.id)
      else
        @order.bill_address.update_attribute(:user_id, try_spree_current_user.try(:id))
      end
      @order.ship_address.update_attribute(:user_id, try_spree_current_user.try(:id))
    end
end