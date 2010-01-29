require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe Contract do
  describe "self.short_list" do

    before(:all) do
      @contract1 = Factory(:contract, :sales_office => 1, :support_office => 11)
      @contract2 = Factory(:contract, :sales_office => 2, :support_office => 12)
      @contract3 = Factory(:contract, :sales_office => 3, :support_office => 13)
    end

    it "returns an array of contracts" do
      Contract.count.should == 3
      Contract.short_list([1,2,3]).class.should == Array
      Contract.short_list([1,2,3])[0].class.should == Contract
    end

    it "finds contracts when passed an integer" do
      Contract.short_list(1).size.should == 1
    end

    it "finds contracts with matching sales_office" do
      Contract.short_list([1,2]).size.should == 2
    end

    it "finds contracts with matching support_office" do
      Contract.short_list([11,12]).size.should == 2
    end

    it "finds both support and sales office" do
      Contract.short_list([1,13]).size.should == 2
    end

    it "should not find contracts which do not match either the sales or support office" do
      Contract.short_list([4,5]).size.should == 0
      Contract.short_list([13,5]).size.should == 1
    end

    after(:all) do
      Contract.delete_all
    end
  end

  describe "Contract.serial_search" do

    context "exact matches" do
      before(:all) do
        @contract1 = Factory :contract
        @contract2 = Factory :contract
        @contract1.line_items << Factory(:line_item, :serial_num => "sn11")
        @contract1.line_items << Factory(:line_item, :serial_num => "sn12")
        @contract1.line_items << Factory(:line_item, :serial_num => "sn12")
        @contract1.line_items << Factory(:line_item, :serial_num => "sn21")
        @contract2.line_items << Factory(:line_item, :serial_num => "sn21")
      end
      it "should find contracts having a line item matching the serial number" do
        Contract.serial_search("sn11").size.should == 1
      end

      it "should only find one contract when more than one line item on that contract matches" do
        Contract.serial_search("sn12").size.should == 1
      end
      it "should find two contracts when two match" do
        Contract.serial_search("sn21").size.should == 2
      end

      after(:all) do
        Contract.delete_all
        LineItem.delete_all
      end
      # For the purposes of this spec, we won't check all the possible transforms, just the 5/S transform.
      context "approximate matches" do
        def mk_line(sn)
          @contract.line_items << Factory(:line_item, :serial_num => sn)
        end
        before(:all) do
          @contract = Factory :contract
        end
        context "character transforms" do
          it "should match when a similar char is substituted at the beginning" do
            mk_line("5AAAA")
            results = Contract.serial_search("SAAAA")
            results.size.should == 1
          end
          it "should match when a similar char is substituted in the middle" do
            mk_line("AA5AA")
            results = Contract.serial_search("AASAA")
            results.size.should == 1
          end
          it "should match when a similar char is substituted at the end" do
            mk_line("AAAA5")
            results = Contract.serial_search("AAAAS")
            results.size.should == 1
          end
          it "should not match when 2 chars are substituted" do
            mk_line("5A5AA")
            results = Contract.serial_search("SASAA")
            results.size.should_not == 1
          end
        end
        context "character drops" do
          it "should match when a character is dropped from the beginning" do
            mk_line("ACEG")
            results = Contract.serial_search("CEG")
            results.size.should == 1
          end
          it "should match when a character is dropped from the middle" do
            mk_line("ACEG")
            results = Contract.serial_search("AEG")
            results.size.should == 1
          end
          it "should match when a character is dropped from the end" do
            mk_line("ACEG")
            results = Contract.serial_search("ACE")
            results.size.should == 1
          end
          it "should not match when 2 chars are dropped" do
            mk_line("AAAA5")
            results = Contract.serial_search("AG")
            results.size.should_not == 1
          end
        end
        after(:all) do
          Contract.delete_all
          LineItem.delete_all
        end
      end
    end
  end

  describe "Contract.all_revenue" do
    before(:all) do
      #Today is Jan 1, 2009, to make the date checks easier
      Date.stub!(:today).and_return(Date.parse('2009-01-01'))
      revenues = {:annual_hw_rev => 1.0, :annual_sw_rev => 1.0, :annual_sa_rev => 1.0, :annual_ce_rev => 1.0, :annual_dr_rev => 1.0}
      @current_contract         = Factory(:contract, revenues.merge(:expired => false, :start_date => Date.parse('2008-06-01'), :end_date => Date.parse('2009-05-31')))
      @expired_current_contract = Factory(:contract, revenues.merge(:expired => true,  :start_date => Date.parse('2008-06-01'), :end_date => Date.parse('2009-05-31')))
      @expired_ended_contract   = Factory(:contract, revenues.merge(:expired => true,  :start_date => Date.parse('2008-01-01'), :end_date => Date.parse('2008-12-31')))
      @ended_unexpired_contract = Factory(:contract, revenues.merge(:expired => false, :start_date => Date.parse('2008-01-01'), :end_date => Date.parse('2008-12-31')))
      @future_contract          = Factory(:contract, revenues.merge(:expired => false, :start_date => Date.parse('2009-01-02'), :end_date => Date.parse('2010-01-01')))
    end
    context "with no date" do
      before(:all) do
        @contract = Contract.all_revenue
      end
      it "totals annual_hw_rev when unexpired" do
        @contract.annual_hw_rev.should == BigDecimal("3.0")
      end
      it "totals annual_sw_rev when unexpired" do
        @contract.annual_sw_rev.should == BigDecimal("3.0")
      end
      it "totals annual_sa_rev when unexpired" do
        @contract.annual_sa_rev.should == BigDecimal("3.0")
      end
      it "totals annual_ce_rev when unexpired" do
        @contract.annual_ce_rev.should == BigDecimal("3.0")
      end
      it "totals annual_dr_rev when unexpired" do
        @contract.annual_dr_rev.should == BigDecimal("3.0")
      end
      it "finds the total_revenue of unexpired contracts" do
        @contract.total_revenue.should == @contract.annual_hw_rev + @contract.annual_sw_rev + @contract.annual_sa_rev + @contract.annual_ce_rev + @contract.annual_dr_rev
      end
    end
    context "with a date parameter passed" do
      it "finds $2.00 when date is 2009-01-01" do
        @contract = Contract.all_revenue(Date.parse('2009-01-01'))
        @contract.annual_hw_rev.should == BigDecimal("2.0")
        @contract.annual_sw_rev.should == BigDecimal("2.0")
        @contract.annual_sa_rev.should == BigDecimal("2.0")
        @contract.annual_ce_rev.should == BigDecimal("2.0")
        @contract.annual_dr_rev.should == BigDecimal("2.0")
        @contract.total_revenue.should == @contract.annual_hw_rev + @contract.annual_sw_rev + @contract.annual_sa_rev + @contract.annual_ce_rev + @contract.annual_dr_rev
      end
      it "finds $1.00 whe date is 2010-01-01" do
        @contract = Contract.all_revenue(Date.parse('2010-01-01'))
        @contract.annual_hw_rev.should == BigDecimal("1.0")
        @contract.annual_sw_rev.should == BigDecimal("1.0")
        @contract.annual_sa_rev.should == BigDecimal("1.0")
        @contract.annual_ce_rev.should == BigDecimal("1.0")
        @contract.annual_dr_rev.should == BigDecimal("1.0")
        @contract.total_revenue.should == @contract.annual_hw_rev + @contract.annual_sw_rev + @contract.annual_sa_rev + @contract.annual_ce_rev + @contract.annual_dr_rev
      end
      it "finds $4.00 whe date is 2008-06-01" do
        @contract = Contract.all_revenue(Date.parse('2008-06-01'))
        @contract.annual_hw_rev.should == BigDecimal("4.0")
        @contract.annual_sw_rev.should == BigDecimal("4.0")
        @contract.annual_sa_rev.should == BigDecimal("4.0")
        @contract.annual_ce_rev.should == BigDecimal("4.0")
        @contract.annual_dr_rev.should == BigDecimal("4.0")
        @contract.total_revenue.should == @contract.annual_hw_rev + @contract.annual_sw_rev + @contract.annual_sa_rev + @contract.annual_ce_rev + @contract.annual_dr_rev
      end
    end
    after(:all) do
      Contract.delete_all
    end
  end

  describe "Contract.revenue_by_office_by_type" do
    before(:all) do
      revenues = {:annual_hw_rev => 1.0, :annual_sw_rev => 1.0, :annual_sa_rev => 1.0, :annual_ce_rev => 1.0, :annual_dr_rev => 1.0}
      @dallas_current_contract          = Factory(:contract, revenues.merge(:expired => false, :start_date => Date.parse('2008-06-01'), :end_date => Date.parse('2009-05-31')))
      @dallas_expired_current_contract  = Factory(:contract, revenues.merge(:expired => true,  :start_date => Date.parse('2008-06-01'), :end_date => Date.parse('2009-05-31')))
      @dallas_expired_ended_contract    = Factory(:contract, revenues.merge(:expired => true,  :start_date => Date.parse('2008-01-01'), :end_date => Date.parse('2008-12-31')))
      @dallas_ended_unexpired_contract  = Factory(:contract, revenues.merge(:expired => false, :start_date => Date.parse('2008-01-01'), :end_date => Date.parse('2008-12-31')))
      @dallas_future_contract           = Factory(:contract, revenues.merge(:expired => false, :start_date => Date.parse('2009-01-02'), :end_date => Date.parse('2010-01-01')))
      @phoenix_current_contract         = Factory(:phoenix_contract, revenues.merge(:expired => false, :start_date => Date.parse('2008-06-01'), :end_date => Date.parse('2009-05-31')))
      @phoenix_expired_current_contract = Factory(:phoenix_contract, revenues.merge(:expired => true,  :start_date => Date.parse('2008-06-01'), :end_date => Date.parse('2009-05-31')))
      @phoenix_expired_ended_contract   = Factory(:phoenix_contract, revenues.merge(:expired => true,  :start_date => Date.parse('2008-01-01'), :end_date => Date.parse('2008-12-31')))
      @phoenix_ended_unexpired_contract = Factory(:phoenix_contract, revenues.merge(:expired => false, :start_date => Date.parse('2008-01-01'), :end_date => Date.parse('2008-12-31')))
      @phoenix_future_contract          = Factory(:phoenix_contract, revenues.merge(:expired => false, :start_date => Date.parse('2009-01-02'), :end_date => Date.parse('2010-01-01')))
    end
    context "with no date" do
      before(:all) do
        @contracts = Contract.revenue_by_office_by_type
      end
      it "is an array of Contracts" do
        @contracts.class.should == Array
        @contracts[0].class.should == Contract
        @contracts[1].class.should == Contract
      end

      it "finds the sales_office_name" do
        @contracts[0].sales_office_name.should == 'Dallas'
        @contracts[1].sales_office_name.should == 'Phoenix'
      end
      it "finds the unexpired totals for each of the offices" do
        [0,1].each do |n|
          BigDecimal(@contracts[n].hw).should == BigDecimal("3.0")
          BigDecimal(@contracts[n].sw).should == BigDecimal("3.0")
          BigDecimal(@contracts[n].sa).should == BigDecimal("3.0")
          BigDecimal(@contracts[n].ce).should == BigDecimal("3.0")
          BigDecimal(@contracts[n].dr).should == BigDecimal("3.0")
          BigDecimal(@contracts[n].total).should == BigDecimal("15.0")
        end
      end
    end
    context "with a date passed" do
      it "is an array of Contracts" do
        @contracts = Contract.revenue_by_office_by_type(Date.parse('2009-01-01'))
        @contracts.class.should == Array
        @contracts[0].class.should == Contract
        @contracts[1].class.should == Contract
      end

      it "finds the sales_office_name" do
        @contracts = Contract.revenue_by_office_by_type(Date.parse('2009-01-01'))
        @contracts[0].sales_office_name.should == 'Dallas'
        @contracts[1].sales_office_name.should == 'Phoenix'
      end
      it "finds $2.00 when date is 2009-01-01" do
        @contracts = Contract.revenue_by_office_by_type(Date.parse('2009-01-01'))
        [0,1].each do |n|
          BigDecimal(@contracts[n].hw).should == BigDecimal("2.0")
          BigDecimal(@contracts[n].sw).should == BigDecimal("2.0")
          BigDecimal(@contracts[n].sa).should == BigDecimal("2.0")
          BigDecimal(@contracts[n].ce).should == BigDecimal("2.0")
          BigDecimal(@contracts[n].dr).should == BigDecimal("2.0")
          BigDecimal(@contracts[n].total).should == BigDecimal("10.0")
        end
      end
      it "finds $1.00 when date is 2010-01-01" do
        @contracts = Contract.revenue_by_office_by_type(Date.parse('2010-01-01'))
        [0,1].each do |n|
          BigDecimal(@contracts[n].hw).should == BigDecimal("1.0")
          BigDecimal(@contracts[n].sw).should == BigDecimal("1.0")
          BigDecimal(@contracts[n].sa).should == BigDecimal("1.0")
          BigDecimal(@contracts[n].ce).should == BigDecimal("1.0")
          BigDecimal(@contracts[n].dr).should == BigDecimal("1.0")
          BigDecimal(@contracts[n].total).should == BigDecimal("5.0")
        end
      end
      it "finds $2.00 when date is 2008-06-01" do
        @contracts = Contract.revenue_by_office_by_type(Date.parse('2008-06-01'))
        [0,1].each do |n|
          BigDecimal(@contracts[n].hw).should == BigDecimal("4.0")
          BigDecimal(@contracts[n].sw).should == BigDecimal("4.0")
          BigDecimal(@contracts[n].sa).should == BigDecimal("4.0")
          BigDecimal(@contracts[n].ce).should == BigDecimal("4.0")
          BigDecimal(@contracts[n].dr).should == BigDecimal("4.0")
          BigDecimal(@contracts[n].total).should == BigDecimal("20.0")
        end
      end
    end
    after(:all) do
      Contract.delete_all
    end
  end

  describe "Contract.missing_subcontracts" do
    before(:all) do
      @found1    = Factory :contract, :start_date => Date.parse('2010-01-01'), :end_date => Date.parse('2010-12-31')
      @found2    = Factory :contract, :start_date => Date.parse('2010-01-01'), :end_date => Date.parse('2010-12-31')
      @notfound1 = Factory :contract
      @notfound2 = Factory :contract
      @notfound3 = Factory :contract
      @notfound4 = Factory :contract, :start_date => Date.parse('2007-01-01'), :end_date => Date.parse('2007-12-31')

      Date.stub!(:today).and_return(Date.parse('2009-01-01'))

      @found1.line_items    << Factory(:line_item, :support_provider => 'subkspecial', :subcontract_id => 1)
      @found1.line_items    << Factory(:line_item, :support_provider => 'subkspecial')
      @found2.line_items    << Factory(:line_item, :support_provider => 'Sourcedirect')
      @found2.line_items    << Factory(:line_item, :support_provider => 'subkspecial')
      @notfound1.line_items << Factory(:line_item, :support_provider => 'Sourcedirect')
      @notfound1.line_items << Factory(:line_item, :support_provider => 'Sourcedirect')
      @notfound2.line_items << Factory(:line_item, :support_provider => 'subkspecial', :subcontract_id => 1)
      @notfound2.line_items << Factory(:line_item, :support_provider => 'subkspecial', :subcontract_id => 1)
      @notfound3.line_items << Factory(:line_item, :support_provider => 'Sourcedirect')
      @notfound3.line_items << Factory(:line_item, :support_provider => 'subkspecial', :subcontract_id => 1)
      @notfound4.line_items << Factory(:line_item, :support_provider => 'subkspecial')
      @contracts = Contract.missing_subcontracts
    end

    it "finds contracts that are incomplete" do
      @contracts.include?(@found1).should be_true
    end

    it "finds contracts that are mixed and incomplete" do
      @contracts.include?(@found2).should be_true
    end

    it "finds current contracts" do
      @contracts.each do |c|
        c.end_date.should >= Date.today
      end
    end

    it "doesn't find contracts that only have Sourcedirect line items" do
      @contracts.include?(@notfound1).should be_false
    end

    it "doesn't find contracts that are completely subcontracted and completed" do
      @contracts.include?(@notfound2).should be_false
    end

    it "doesn't find contracts that have all the applicable lines subcontracted already" do
      @contracts.include?(@notfound3).should be_false
    end

    it "doesn't find contracts that are old" do
      @contracts.include?(@notfound4).should be_false
    end

    after(:all) do
      Contract.delete_all
      LineItem.delete_all
    end
  end

  describe "Contract.expected_revenue" do
    before(:each) do
      # renewal amount set
      @contract1 = Factory(:contract, :renewal_amount => 500.0)

      # Bundled Contract, should be $1,200/yr.
      @contract2 = Factory(:contract, :payment_terms => "Bundled", :revenue => 1200.0)
      @contract2.line_items << Factory(:line_item, :current_list_price => 100.0, :support_type => "HW", :qty => 1)

      # annual, non-renewal-set contract
      @contract3 = Factory(:contract, :payment_terms => "Annual", :discount_pref_hw => 0.3, :discount_pref_sw => 0.3, :discount_pref_srv => 0.0, :discount_prepay => 0.05)
      @contract3.line_items << Factory(:line_item, :current_list_price => 100.0, :support_type => "HW", :qty => 1)

      @contract4 = Factory(:contract, :payment_terms => "Monthly", :discount_pref_hw => 0.3, :discount_pref_sw => 0.3, :discount_pref_srv => 0.0, :discount_prepay => 0.05)
      @contract4.line_items << Factory(:line_item, :current_list_price => 100.0, :support_type => "HW", :qty => 1)
    end

    it "returns renewal_amount when it is set" do
      @contract1.expected_revenue.should == 500.0
    end

    it "returns 50% off the current list price when bundled" do
      @contract2.expected_revenue.should == 600.0
    end

    it "returns the current price, factoring in the appropriate discounts on an annual renewal" do
      @contract3.expected_revenue.should == 1200 * 0.65
    end

    it "returns the current price, factoring in the appropriate discounts on an monthly renewal" do
      @contract4.expected_revenue.should == 1200 * 0.70
    end

    after(:all) do
      Contract.delete_all
      LineItem.delete_all
    end
  end

  describe "Contract.effective_months" do
    def d date
      Date.parse date
    end
    before(:all) do
      @contract12a = Factory(:contract, :start_date => d('2009-01-01'), :end_date => d('2009-12-31'))
      @contract12b = Factory(:contract, :start_date => d('2008-02-01'), :end_date => d('2009-01-31'))
      @contract5a = Factory(:contract, :start_date => d('2009-01-01'), :end_date => d('2009-05-31'))
      @contract5b = Factory(:contract, :start_date => d('2009-02-15'), :end_date => d('2009-07-14'))
      @contract17 = Factory(:contract, :start_date => d('2008-01-15'), :end_date => d('2009-06-14'))
      @contract4o32 = Factory(:contract, :start_date => d('2008-01-01'), :end_date => d('2008-05-10'))
    end
    it "returns 12 for a jan 1 - dec 31 contract" do
      @contract12a.effective_months.should == 12
    end
    it "returns 12 for a feb 1 - jan 31 contract" do
      @contract12b.effective_months.should == 12
    end
    it "returns 5 for a jan 1 to may 31 contract" do
      @contract5a.effective_months.should == 5
    end
    it "returns 5 for a feb 15 to july 14 contract" do
      @contract5b.effective_months.should == 5
    end
    it "returns 17 fora jan 15 08 to june 14 09 contract" do
      @contract17.effective_months.should == 17
    end
    it "returns 4.322580645161290... for a Jan 1 to May 10 contract" do
      @contract4o32.effective_months.should == (4.0 + (10.0 / 31.0))
    end
    after(:all) do
      Contract.delete_all
    end
  end
  describe "Contract.*_line_items" do
    #hw_line_items
    #sw_line_items
    #srv_line_items
    before(:all) do
      @contract = Factory(:contract)
      @contract.line_items << Factory(:line_item, :support_type => "HW")
      @contract.line_items << Factory(:line_item, :support_type => "SW")
      @contract.line_items << Factory(:line_item, :support_type => "SRV")
    end
    ["hw", "sw", "srv"].each do |type|
      it "finds the #{type} Line Item" do
        @contract.send("#{type}_line_items").length.should == 1
      end
    end
    after(:all) do
      Contract.delete_all
      LineItem.delete_all
    end
  end
  describe "Contract.*_list_price" do
    #hw_list_price
    #sw_list_price
    #srv_list_price
    before(:all) do
      sd = Date.parse('2009-01-01')
      ed = Date.parse('2009-12-31')
      @contract = Factory(:contract, :start_date => sd, :end_date => ed)
      @line_item1 = Factory(:line_item, :begins => sd, :ends => ed, :list_price => 100.0, :qty => 1, :support_type => "HW")
      @line_item2 = Factory(:line_item, :begins => sd, :ends => ed, :list_price => 100.0, :qty => 1, :support_type => "SW")
      @line_item3 = Factory(:line_item, :begins => sd, :ends => ed, :list_price => 100.0, :qty => 1, :support_type => "SRV")
      @contract.line_items = [@line_item1, @line_item2, @line_item3]
    end
    @types = ["hw", "sw", "srv"]
    @types.each do |type|
      it "totals the #{type}line_items in a contract" do
        @contract.send("#{type}_list_price").should == 1200.0
      end
      
      it "correctly totals the #{type} line_items when the line items begin after the contract" do
        [@line_item1, @line_item2, @line_item3].each {|l| l.begins= Date.parse("2009-07-01")}
        @contract.send("#{type}_list_price").should == 600.0
      end

      it "correctly totals the #{type} line_items when the line items begin before the contract" do
        [@line_item1, @line_item2, @line_item3].each {|l| l.begins= Date.parse("2008-07-01")}
        @contract.send("#{type}_list_price").should == 1200.0
      end

      it "correctly totals the #{type} line_items when the line items end before the contract" do
        [@line_item1, @line_item2, @line_item3].each {|l| l.ends= Date.parse("2009-06-30")}
        @contract.send("#{type}_list_price").should == 600.0
      end

      it "correctly totals the #{type} line_items when the line items end after the contract" do
        [@line_item1, @line_item2, @line_item3].each {|l| l.ends= Date.parse("2010-06-30")}
        @contract.send("#{type}_list_price").should == 1200.0
      end
    end

    after(:all) do
      Contract.delete_all
      LineItem.delete_all
    end
  end

  describe "Contract.calendar_months" do
    it "returns 12 for a 1 year contract" do
      contract = Factory(:contract, :start_date => Date.parse('2009-01-01'), :end_date => Date.parse('2009-12-31'))
      contract.calendar_months.should == 12
    end
    it "returns 14 for this contract" do
      contract = Factory(:contract, :start_date => Date.parse('2008-12-15'), :end_date => Date.parse('2010-01-15'))
      contract.calendar_months.should == 14
    end
    it "returns 7 for this contract" do
      contract = Factory(:contract, :start_date => Date.parse('2008-12-15'), :end_date => Date.parse('2009-06-30'))
      contract.calendar_months.should == 7
    end

  end

  describe "Contract.new_business" do
    before(:all) do
      @contract_new = Factory(:contract, :annual_hw_rev => 500.0, :annual_sw_rev => 0.0, :annual_sa_rev => 0.0, :annual_ce_rev => 0.0, :annual_dr_rev => 0.0)
      @contract_old = Factory(:contract, :annual_hw_rev => 250.0, :annual_sw_rev => 0.0, :annual_sa_rev => 0.0, :annual_ce_rev => 0.0, :annual_dr_rev => 0.0)
      @contract_old2 = Factory(:contract, :annual_hw_rev => 150.0, :annual_sw_rev => 0.0, :annual_sa_rev => 0.0, :annual_ce_rev => 0.0, :annual_dr_rev => 0.0)
      @contract_old3 = Factory(:contract, :annual_hw_rev => 600.0)
    end

    it "returns the difference between current contract total revenue and the sum of the predecessors revenue when current > previous" do
      @contract_new.predecessors << @contract_old
      @contract_new.predecessors << @contract_old2
      @contract_new.new_business.should == 100.0
    end

    it "returns 0.0 when current <= previous" do
      @contract_old2.predecessors << @contract_old3
      @contract_old2.new_business.should == 0.0
    end

    it "returns total_revenue when there are no predecessors" do
      @contract_old3.new_business.should == @contract_old3.total_revenue
    end

    after(:all) do
      Contract.delete_all
    end

  end

  describe "Contract.non_renewing_contracts" do
    before(:all) do
      @contract_1 = Factory(:contract, :expired => 1, :start_date => "2008-02-01", :end_date => "2009-01-31" )
      @contract_2 = Factory(:contract, :expired => 1, :start_date => "2008-02-01", :end_date => "2009-01-31" )
      @contract_3 = Factory(:contract, :start_date => "2009-02-01", :end_date => "2010-01-31" )
      @contract_4 = Factory(:contract, :start_date => "2008-06-01", :end_date => "2009-05-31" )
    end

    it "returns the the sum of all contracts that are expired and do not have a successor, between 2 dates" do
      @contract_2.successors << @contract_3
      Contract.non_renewing_contracts("2009-01-01","2009-12-31").should == -150.0
    end

    after(:all) do
      Contract.delete_all
    end
  end

  describe "Contract.renewal_attrition" do
    before(:all) do
      @contract_new = Factory(:contract, :annual_hw_rev => 500.0, :annual_sw_rev => 0.0, :annual_sa_rev => 0.0, :annual_ce_rev => 0.0, :annual_dr_rev => 0.0)
      @contract_old = Factory(:contract, :annual_hw_rev => 250.0, :annual_sw_rev => 0.0, :annual_sa_rev => 0.0, :annual_ce_rev => 0.0, :annual_dr_rev => 0.0)
      @contract_old2 = Factory(:contract, :expired => 1, :annual_hw_rev => 150.0, :annual_sw_rev => 0.0, :annual_sa_rev => 0.0, :annual_ce_rev => 0.0, :annual_dr_rev => 0.0)
    end

    it "returns the difference between current contract total revenue and the sum of the predecessors revenue - positive increase" do
      @contract_new.predecessors << @contract_old
      @contract_new.predecessors << @contract_old2
      @contract_new.renewal_attrition.should == 100.0
    end

    it "returns the difference between current contract total revenue and the sum of the predecessors revenue - negative decrease" do
      @contract_old.predecessors << @contract_new
      @contract_old.renewal_attrition.should == -250.0
    end

    after(:all) do
      Contract.delete_all
    end
  end
end


