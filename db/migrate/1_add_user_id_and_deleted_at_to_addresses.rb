# This migration comes from spree_simple_ext (originally 1)
class AddUserIdAndDeletedAtToAddresses < ActiveRecord::Migration
  def self.up
    change_table addresses_table_name do |t|
      t.integer :user_id
      t.string :secondname
      t.datetime :deleted_at
    end
  end

  def self.down
    change_table addresses_table_name do |t|
      t.remove :deleted_at
      t.remove :secondname
      t.remove :user_id    
    end
  end
  
  private
  
  def self.addresses_table_name
    table_exists?('addresses') ? :addresses : :spree_addresses
  end
end