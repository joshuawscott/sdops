class Quickbooks < ActiveRecord::Base
  establish_connection :quickbooks
  self.table_name = 'invoice'
  SELECT = <<-EOSQL
     COUNT(*) AS Transactions
    , RIGHT(LEFT(inv.Memo, INSTR(inv.Memo,'.') - 1 ), INSTR(inv.Memo,'.') - 11 ) AS sales_order_number
    , inv.TxnDate AS TransactionDate
    , inv.CustomerRef_FullName AS JobName
    , rep.SalesRepEntityRef_FullName AS SalesRep
    , inv.ClassRef_FullName AS Territory
    , inv.RefNumber AS InvoiceNumber
    , inv.PONumber
    , SUM(inv.Subtotal) AS revenue
    , SUM(inv.Subtotal + inv.SalesTaxTotal + inv.AppliedAmount) AS remaining_balance
    , SUM(debit.amount) AS cost
    , SUM(inv.Subtotal - debit.Amount) AS _profit
    , CASE WHEN inv.isPaid = 'true' THEN 1 ELSE 0 END AS Paid
  EOSQL
  JOIN = <<-EOSQL
    inv
    INNER JOIN salesrep rep ON inv.SalesRepRef_ListID = rep.ListID
    LEFT JOIN journaldebitlinedetail debit ON inv.CustomerRef_ListID = debit.EntityRef_ListID
  EOSQL
  WHERE =
      " CAST(inv.RefNumber AS UNSIGNED) <= 29999
    AND inv.Memo LIKE 'FB: SO#%'"
  GROUP = "STR_TO_DATE(inv.TimeCreated, '%c/%e/%Y'),inv.TxnDate, inv.CustomerRef_FullName,inv.ClassRef_FullName,inv.RefNumber,inv.PONumber, RIGHT(LEFT(inv.Memo, INSTR(inv.Memo,'.') - 1 ), INSTR(inv.Memo,'.') - 11 )"
  ORDER = "sales_order_number"
  #AND debit.AccountRef_ListID IS NOT NULL

  # Transactions
  # sales_order_number
  # TransactionDate
  # JobName
  # SalesRep
  # Territory
  def self.all_profits
    self.find(:all, :select => SELECT, :joins => JOIN, :conditions => WHERE, :group => GROUP, :order => ORDER)
  end

  def self.profits_for_so(so_number)
    self.find(:first, :select => SELECT, :joins => JOIN, :group => GROUP, :order => ORDER,
              :conditions => WHERE + " AND inv.RefNumber = '#{so_number}'")
  end

  def profit
    BigDecimal.new(_profit.to_s)
  end
end
