# ==Not Used.
# ===Schema:
#   id          integer
#   invoice_id  integer
#   payment_id  integer
class InvoicePayment < ActiveRecord::Base #:nodoc:
  belongs_to :invoices
  belongs_to :payments
end
