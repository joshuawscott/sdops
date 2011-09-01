# Work in progress?
# Schema:
#   id          integer
#   invoice_id  integer
#   payment_id  integer
class Payment < ActiveRecord::Base #:nodoc:
  has_many  :invoice_payments
  has_many  :invoices, :through => :invoice_payments
end
