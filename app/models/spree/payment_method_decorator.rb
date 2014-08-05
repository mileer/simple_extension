Spree::PaymentMethod.class_eval do
  def self.internal
    pm = Spree::PaymentMethod.where(:environment => Rails.env, 
                             :display_on => "back_end", 
                             :type => "PaymentMethod::Check", 
                             :active => true).first
    
    pm ||= Spree::PaymentMethod::Check.create(:environment => Rails.env, 
                                :name => "Для внутренних расчётов", 
                                :display_on => "back_end", :active => true)  
    pm
  end
end
