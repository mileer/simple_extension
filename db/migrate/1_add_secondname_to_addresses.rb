class AddSecondnameToAddresses < ActiveRecord::Migration
    def self.up
      add_column :spree_addresses, :secondname, :string
    end

    def self.down
      remove_column :spree_addresses, :secondname
    end
end
