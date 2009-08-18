require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe Contract do
  describe "self.short_list" do

    before(:each) do
      Factory(:contract, :sales_office => 1, :support_office => 11)
      Factory(:contract, :sales_office => 2, :support_office => 12)
      Factory(:contract, :sales_office => 3, :support_office => 13)
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

  end

  describe "Contract.serial_search" do

    context "exact matches" do
      before(:each) do
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

      # For the purposes of this spec, we won't check all the possible transforms, just the 5/S transform.
      context "approximate matches" do
        def mk_line(sn)
          @contract.line_items << Factory(:line_item, :serial_num => sn)
        end
        before(:each) do
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
      @current_contract.destroy
      @expired_current_contract.destroy
      @expired_ended_contract.destroy
      @ended_unexpired_contract.destroy
      @future_contract.destroy
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
      @dallas_current_contract.destroy
      @dallas_expired_current_contract.destroy
      @dallas_expired_ended_contract.destroy
      @dallas_ended_unexpired_contract.destroy
      @dallas_future_contract.destroy
      @phoenix_current_contract.destroy
      @phoenix_expired_current_contract.destroy
      @phoenix_expired_ended_contract.destroy
      @phoenix_ended_unexpired_contract.destroy
      @phoenix_future_contract.destroy
    end
  end
end

