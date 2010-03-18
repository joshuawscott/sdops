require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe SupportDeal do
  describe "#payment_schedule" do
    before(:all) do
      @contract = Factory(:contract,
        :start_date => d('2009-01-01'),
        :end_date => d('2009-12-31'),
        :discount_pref_hw => 0.30,
        :discount_pref_sw => 0.30,
        :discount_pref_srv => 0.30,
        :discount_multiyear => 0.05,
        :discount_prepay => 0.04  )
      line_item1 = Factory(:line_item, :support_type => 'HW', :product_num => "1", :begins => d('2009-01-01'), :ends => d('2009-12-31'), :list_price => 1.0 , :qty => 1)
      line_item2 = Factory(:line_item, :support_type => 'SW', :product_num => "2", :begins => d('2009-05-15'), :ends => d('2009-12-31'), :list_price => 1.0 , :qty => 1)
      line_item3 = Factory(:line_item, :support_type => 'SW', :product_num => "3", :begins => d('2009-01-01'), :ends => d('2009-09-15'), :list_price => 1.0 , :qty => 1)
      line_item4 = Factory(:line_item, :support_type => 'HW', :product_num => "4", :begins => d('2009-05-15'), :ends => d('2009-09-15'), :list_price => 1.0 , :qty => 1)
      @contract.line_items = [line_item1,line_item2,line_item3,line_item4]
    end
    it "finds the correct payment schedule for non-multiyear" do
      @contract.payment_schedule(:multiyear => false).should == [2.0*0.7,2.0*0.7,2.0*0.7,2.0*0.7,2.0 * 0.7 + (17.0/31.0)*2*0.7, 4.0*0.7,4.0*0.7,4.0*0.7,3.0*0.7,2.0*0.7,2.0*0.7,2.0*0.7]
    end
    it "finds the correct payment schedule for multiyear" do
      @contract.payment_schedule(:multiyear => true).should == [2.0*0.65,2.0*0.65,2.0*0.65,2.0*0.65,2.0*0.65 + (17.0/31.0)*2*0.65, 4.0*0.65,4.0*0.65,4.0*0.65,3.0*0.65,2.0*0.65,2.0*0.65,2.0*0.65]
    end
    after(:all) do
      Contract.delete_all
      LineItem.delete_all
    end
  end
end
