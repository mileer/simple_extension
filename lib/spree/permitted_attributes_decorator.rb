Spree::PermittedAttributes.class_eval do
  @@user_attributes.push(:juridical, :recipient, :juridical_address,:kpp,
                         :recipient_bank, :settlement_acc, :corr, :bik, :nds)
end