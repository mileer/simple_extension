Deface::Override.new(
  :virtual_path => "spree/users/show",
  :name => "address_book_account_my_orders",
  :insert_after => "[data-hook='account_my_orders'], #account_my_orders[data-hook]",
  :partial => "spree/users/addresses",
  :disabled => false
)

Deface::Override.new(
  :virtual_path => "admin/orders/show",
  :name => "simple_admin_order_show_buttons",
  :insert_before => "[data-hook='admin_order_show_buttons'], #admin_order_show_buttons[data-hook]",
  :text => "
  <%= button_link_to t(\"courier_instructions\"), orders_courier_instruction_path(@order), :target => \"_blank\" if @order.completed_at %>
  ",
  :disabled => false)

Deface::Override.new(
  :virtual_path => "admin/configurations/index",
  :name => "simple_admin_configurations_menu",
  :insert_bottom => "[data-hook='admin_configurations_menu'], #admin_configurations_menu[data-hook]",
  :text => "<tr>
  <td><%= link_to t(\"simple_settings\"), admin_simple_settings_path %></td>
  <td><%= t(\"simple_settings_desc\") %></td>
  </tr>",
  :disabled => false)

Deface::Override.new(
  :virtual_path => "admin/shared/_configuration_menu",
  :name => "simple_admin_configurations_sidebar_menu",
  :insert_bottom => "[data-hook='admin_configurations_sidebar_menu'], #admin_configurations_sidebar_menu[data-hook]",
  :text => "<li<%== ' class=\"active\"' if controller.controller_name == 'simple_settings' %>><%= link_to t(\"simple_settings\"), admin_simple_settings_path %></li>",
  :disabled => false)

Deface::Override.new(
  :virtual_path => "admin/shared/_order_tabs",
  :name => "simple_admin_order_tabs",
  :insert_bottom => "[data-hook='admin_order_tabs'], #admin_order_tabs[data-hook]",
  :partial => "admin/orders/juridical_tabs",
  :disabled => false)

Deface::Override.new(
  :virtual_path => "users/show",
  :name => "simple_account_summary",
  :insert_bottom => "[data-hook='account_summary'], #account_summary[data-hook]",
  :partial => "users/status",
  :disabled => false)


