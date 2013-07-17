class ManagedDeal < ActiveRecord::Base
#      t.string :account_id
#      t.string :end_user_id
#      t.string :sales_office_id
#      t.string :sales_rep_id
#      t.string :customer_po_number
#      t.string :payment_terms
#      t.string :initial_annual_revenue
#      t.string :description
#      t.date   :start_date
#      t.date   :end_date
#      t.date   :renewal_created
#      t.timestamps

  belongs_to :sugar_acct, :foreign_key => :account_id
  belongs_to :end_user, :class_name => 'SugarAcct', :foreign_key => :end_user_id
  belongs_to :sales_rep, :class_name => 'User'
  belongs_to :sales_office, :class_name => 'SugarTeam'
  has_many :comments, :as => :commentable
end