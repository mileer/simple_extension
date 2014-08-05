Spree::Admin::OrdersController.class_eval do
  def courier_instruction
    @order = Order.find_by(params[:id])
    render :layout => false
  end
  
  def juridical_info
    @user = Order.find_by(number: params[:id]).user
  end
end
