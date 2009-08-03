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

end
