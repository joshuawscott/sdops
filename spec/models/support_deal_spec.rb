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
      disc_multiplier = BigDecimal('0.66')
      @contract.payment_schedule(:multiyear => false).should == [
        BigDecimal('2.0')*disc_multiplier,
        BigDecimal('2.0')*disc_multiplier,
        BigDecimal('2.0')*disc_multiplier,
        BigDecimal('2.0')*disc_multiplier,
        BigDecimal('2.0') * disc_multiplier + (BigDecimal('17.0')/BigDecimal('31.0'))*BigDecimal('2')*disc_multiplier,
        BigDecimal('4.0')*disc_multiplier,
        BigDecimal('4.0')*disc_multiplier,
        BigDecimal('4.0')*disc_multiplier,
        BigDecimal('3.0')*disc_multiplier,
        BigDecimal('2.0')*disc_multiplier,
        BigDecimal('2.0')*disc_multiplier,
        BigDecimal('2.0')*disc_multiplier]
    end
    it "finds the correct payment schedule for multiyear" do
      disc_multiplier = BigDecimal('0.61')
      @contract.payment_schedule(:multiyear => true).should == [
        BigDecimal('2.0')*disc_multiplier,
        BigDecimal('2.0')*disc_multiplier,
        BigDecimal('2.0')*disc_multiplier,
        BigDecimal('2.0')*disc_multiplier,
        BigDecimal('2.0')*disc_multiplier + (BigDecimal('17.0')/BigDecimal('31.0'))*BigDecimal('2')*disc_multiplier,
        BigDecimal('4.0')*disc_multiplier,
        BigDecimal('4.0')*disc_multiplier,
        BigDecimal('4.0')*disc_multiplier,
        BigDecimal('3.0')*disc_multiplier,
        BigDecimal('2.0')*disc_multiplier,
        BigDecimal('2.0')*disc_multiplier,
        BigDecimal('2.0')*disc_multiplier]
    end
    after(:all) do
      Contract.delete_all
      LineItem.delete_all
    end
  end
  describe "#last_comment" do
    before(:each) do
      @empty_support_deal = Factory(:support_deal)
      @support_deal = Factory(:support_deal)
      comment1 = Factory(:comment)
      comment2 = Factory(:comment)
      @support_deal.comments << comment1
      @support_deal.comments << comment2
    end
    it "should return nil when no comments exist" do
      @empty_support_deal.last_comment.should == nil
    end
    it "should return a comment when passed no options" do
      @support_deal.last_comment.class.should == Comment
    end
    it "should return a comment array when passed 2" do
      @support_deal.last_comment(2).class.should == Array
    end
    it "should return a comment when passed 1" do
      @support_deal.last_comment(1).class.should == Comment
    end

  end

  describe "#unearned_revenue_schedule_array" do
    def b new_bd_string
      BigDecimal.new(new_bd_string)
    end
    before :all do
      # List price on each is $2,400 per year.  $200/mo:
      # 30% = 140
      # 35% = 130
      # 40% = 120
      # 45% = 110

      # Annual - 40% discount with prepay
      @support_deal_annual = Factory(:contract_zero, :start_date => d('2012-01-01'), :end_date => d('2012-12-31'), :annual_hw_rev => BigDecimal.new('1440.0'), :discount_pref_hw => BigDecimal.new('.3'), :discount_prepay => BigDecimal.new('.1'), :discount_multiyear => BigDecimal.new('.05'), :payment_terms => 'Annual')
      # Monthly - 30% discount without prepay
      @support_deal_monthly = Factory(:contract_zero, :start_date => d('2012-01-01'), :end_date => d('2012-12-31'), :annual_hw_rev => BigDecimal.new('1680.0'), :discount_pref_hw => BigDecimal.new('.3'), :discount_prepay => BigDecimal.new('.1'), :discount_multiyear => BigDecimal.new('.05'), :payment_terms => 'Monthly')
      # Annual + MY - 45% discount with prepay & multiyear
      @support_deal_annual_my = Factory(:contract_zero, :start_date => d('2012-01-01'), :end_date => d('2012-12-31'), :annual_hw_rev => BigDecimal.new('1320.0'), :discount_pref_hw => BigDecimal.new('.3'), :discount_prepay => BigDecimal.new('.1'), :discount_multiyear => BigDecimal.new('.05'), :payment_terms => 'Annual+MY')
      # Monthly + MY - 35% discount with prepay & multiyear
      @support_deal_monthly_my = Factory(:contract_zero, :start_date => d('2012-01-01'), :end_date => d('2012-12-31'), :annual_hw_rev => BigDecimal.new('1560.0'), :discount_pref_hw => BigDecimal.new('.3'), :discount_prepay => BigDecimal.new('.1'), :discount_multiyear => BigDecimal.new('.05'), :payment_terms => 'Monthly+MY')
      #Bundled Deal with 0% discounts - should be figured based on annual revenue
      @support_deal_bundled = Factory(:contract_zero, :start_date => d('2012-01-01'), :end_date => d('2014-12-31'), :annual_sw_rev => 0, :annual_dr_rev => 0, :annual_ce_rev => 0, :annual_sa_rev => 0, :annual_hw_rev => BigDecimal.new('600.0'), :discount_pref_hw => BigDecimal.new('.3'), :discount_prepay => BigDecimal.new('.1'), :discount_multiyear => BigDecimal.new('.05'), :payment_terms => 'Bundled')
      #Annual with 2 months free
      @support_deal_annual_2free = Factory(:contract_zero, :start_date => d('2012-01-01'), :end_date => d('2013-02-28'), :annual_hw_rev => BigDecimal.new('1440.0'), :discount_pref_hw => BigDecimal.new('.3'), :discount_prepay => BigDecimal.new('.1'), :discount_multiyear => BigDecimal.new('.05'), :payment_terms => 'Annual')
      #Monthly with 2 months free
      @support_deal_monthly_2free = Factory(:contract_zero, :start_date => d('2012-01-01'), :end_date => d('2013-02-28'), :annual_hw_rev => BigDecimal.new('1680.0'), :discount_pref_hw => BigDecimal.new('.3'), :discount_prepay => BigDecimal.new('.1'), :discount_multiyear => BigDecimal.new('.05'), :payment_terms => 'Monthly')

      # Annual - 40% discount with prepay
      @support_deal_annual_offset = Factory(:contract_zero, :start_date => d('2012-01-15'), :end_date => d('2013-01-14'), :annual_hw_rev => BigDecimal.new('1440.0'), :discount_pref_hw => BigDecimal.new('.3'), :discount_prepay => BigDecimal.new('.1'), :discount_multiyear => BigDecimal.new('.05'), :payment_terms => 'Annual')
      # Monthly - 30% discount without prepay
      @support_deal_monthly_offset = Factory(:contract_zero, :start_date => d('2012-01-15'), :end_date => d('2013-01-14'), :annual_hw_rev => BigDecimal.new('1680.0'), :discount_pref_hw => BigDecimal.new('.3'), :discount_prepay => BigDecimal.new('.1'), :discount_multiyear => BigDecimal.new('.05'), :payment_terms => 'Monthly')
      # Annual + MY - 45% discount with prepay & multiyear
      @support_deal_annual_my_offset = Factory(:contract_zero, :start_date => d('2012-01-15'), :end_date => d('2013-01-14'), :annual_hw_rev => BigDecimal.new('1320.0'), :discount_pref_hw => BigDecimal.new('.3'), :discount_prepay => BigDecimal.new('.1'), :discount_multiyear => BigDecimal.new('.05'), :payment_terms => 'Annual+MY')
      # Monthly + MY - 35% discount with prepay & multiyear
      @support_deal_monthly_my_offset = Factory(:contract_zero, :start_date => d('2012-01-15'), :end_date => d('2013-01-14'), :annual_hw_rev => BigDecimal.new('1560.0'), :discount_pref_hw => BigDecimal.new('.3'), :discount_prepay => BigDecimal.new('.1'), :discount_multiyear => BigDecimal.new('.05'), :payment_terms => 'Monthly+MY')
      #Bundled Deal with 0% discounts - should be figured based on annual revenue
      @support_deal_bundled_offset = Factory(:contract_zero, :start_date => d('2012-01-15'), :end_date => d('2015-01-14'), :annual_sw_rev => 0, :annual_dr_rev => 0, :annual_ce_rev => 0, :annual_sa_rev => 0, :annual_hw_rev => BigDecimal.new('600.0'), :discount_pref_hw => BigDecimal.new('.3'), :discount_prepay => BigDecimal.new('.1'), :discount_multiyear => BigDecimal.new('.05'), :payment_terms => 'Bundled')
      #Annual with 2 months free 40%
      @support_deal_annual_2free_offset = Factory(:contract_zero, :start_date => d('2012-01-15'), :end_date => d('2013-03-14'), :annual_hw_rev => BigDecimal.new('1440.0'), :discount_pref_hw => BigDecimal.new('.3'), :discount_prepay => BigDecimal.new('.1'), :discount_multiyear => BigDecimal.new('.05'), :payment_terms => 'Annual')
      #Monthly with 2 months free 30%
      @support_deal_monthly_2free_offset = Factory(:contract_zero, :start_date => d('2012-01-15'), :end_date => d('2013-03-14'), :annual_hw_rev => BigDecimal.new('1680.0'), :discount_pref_hw => BigDecimal.new('.3'), :discount_prepay => BigDecimal.new('.1'), :discount_multiyear => BigDecimal.new('.05'), :payment_terms => 'Monthly')

      line1 = Factory(:line_item, :list_price => BigDecimal.new('100.0'), :support_type => 'HW', :begins => d('2012-01-01'), :ends => d('2012-12-31'), :qty => 1)
      line2 = Factory(:line_item, :list_price => BigDecimal.new('100.0'), :support_type => 'HW', :begins => d('2012-01-01'), :ends => d('2012-12-31'), :qty => 1)
      line3 = Factory(:line_item, :list_price => BigDecimal.new('100.0'), :support_type => 'HW', :begins => d('2012-01-01'), :ends => d('2012-12-31'), :qty => 1)
      line4 = Factory(:line_item, :list_price => BigDecimal.new('100.0'), :support_type => 'HW', :begins => d('2012-01-01'), :ends => d('2012-12-31'), :qty => 1)
      line5 = Factory(:line_item, :list_price => BigDecimal.new('100.0'), :support_type => 'HW', :begins => d('2012-01-01'), :ends => d('2012-12-31'), :qty => 1)
      line6 = Factory(:line_item, :list_price => BigDecimal.new('100.0'), :support_type => 'HW', :begins => d('2012-01-01'), :ends => d('2012-12-31'), :qty => 1)
      line7 = Factory(:line_item, :list_price => BigDecimal.new('100.0'), :support_type => 'HW', :begins => d('2012-01-01'), :ends => d('2012-12-31'), :qty => 1)
      line8 = Factory(:line_item, :list_price => BigDecimal.new('100.0'), :support_type => 'HW', :begins => d('2012-01-01'), :ends => d('2012-12-31'), :qty => 1)
      line9 = Factory(:line_item, :list_price => BigDecimal.new('100.0'), :support_type => 'HW', :begins => d('2012-01-01'), :ends => d('2014-12-31'), :qty => 1)
      line10 = Factory(:line_item, :list_price => BigDecimal.new('100.0'), :support_type => 'HW', :begins => d('2012-01-01'), :ends => d('2014-12-31'), :qty => 1)
      line11 = Factory(:line_item, :list_price => BigDecimal.new('100.0'), :support_type => 'HW', :begins => d('2012-01-01'), :ends => d('2013-02-28'), :qty => 1)
      line12 = Factory(:line_item, :list_price => BigDecimal.new('100.0'), :support_type => 'HW', :begins => d('2012-01-01'), :ends => d('2013-02-28'), :qty => 1)
      line13 = Factory(:line_item, :list_price => BigDecimal.new('100.0'), :support_type => 'HW', :begins => d('2012-01-01'), :ends => d('2013-02-28'), :qty => 1)
      line14 = Factory(:line_item, :list_price => BigDecimal.new('100.0'), :support_type => 'HW', :begins => d('2012-01-01'), :ends => d('2013-02-28'), :qty => 1)

      line1_offset = Factory(:line_item, :list_price => BigDecimal.new('100.0'), :support_type => 'HW', :begins => d('2012-01-15'), :ends => d('2013-01-14'), :qty => 1)
      line2_offset = Factory(:line_item, :list_price => BigDecimal.new('100.0'), :support_type => 'HW', :begins => d('2012-01-15'), :ends => d('2013-01-14'), :qty => 1)
      line3_offset = Factory(:line_item, :list_price => BigDecimal.new('100.0'), :support_type => 'HW', :begins => d('2012-01-15'), :ends => d('2013-01-14'), :qty => 1)
      line4_offset = Factory(:line_item, :list_price => BigDecimal.new('100.0'), :support_type => 'HW', :begins => d('2012-01-15'), :ends => d('2013-01-14'), :qty => 1)
      line5_offset = Factory(:line_item, :list_price => BigDecimal.new('100.0'), :support_type => 'HW', :begins => d('2012-01-15'), :ends => d('2013-01-14'), :qty => 1)
      line6_offset = Factory(:line_item, :list_price => BigDecimal.new('100.0'), :support_type => 'HW', :begins => d('2012-01-15'), :ends => d('2013-01-14'), :qty => 1)
      line7_offset = Factory(:line_item, :list_price => BigDecimal.new('100.0'), :support_type => 'HW', :begins => d('2012-01-15'), :ends => d('2013-01-14'), :qty => 1)
      line8_offset = Factory(:line_item, :list_price => BigDecimal.new('100.0'), :support_type => 'HW', :begins => d('2012-01-15'), :ends => d('2013-01-14'), :qty => 1)
      line9_offset = Factory(:line_item, :list_price => BigDecimal.new('100.0'), :support_type => 'HW', :begins => d('2012-01-15'), :ends => d('2015-01-14'), :qty => 1)
      line10_offset = Factory(:line_item, :list_price => BigDecimal.new('100.0'), :support_type => 'HW', :begins => d('2012-01-15'), :ends => d('2015-01-14'), :qty => 1)
      line11_offset = Factory(:line_item, :list_price => BigDecimal.new('100.0'), :support_type => 'HW', :begins => d('2012-01-15'), :ends => d('2013-03-14'), :qty => 1)
      line12_offset = Factory(:line_item, :list_price => BigDecimal.new('100.0'), :support_type => 'HW', :begins => d('2012-01-15'), :ends => d('2013-03-14'), :qty => 1)
      line13_offset = Factory(:line_item, :list_price => BigDecimal.new('100.0'), :support_type => 'HW', :begins => d('2012-01-15'), :ends => d('2013-03-14'), :qty => 1)
      line14_offset = Factory(:line_item, :list_price => BigDecimal.new('100.0'), :support_type => 'HW', :begins => d('2012-01-15'), :ends => d('2013-03-14'), :qty => 1)

      @support_deal_annual.line_items = [line1, line2]
      @support_deal_monthly.line_items = [line3, line4]
      @support_deal_annual_my.line_items = [line5, line6]
      @support_deal_monthly_my.line_items = [line7, line8]
      @support_deal_bundled.line_items = [line9, line10]
      @support_deal_annual_2free.line_items = [line11, line12]
      @support_deal_monthly_2free.line_items = [line13, line14]

      @support_deal_annual_offset.line_items = [line1_offset, line2_offset]
      @support_deal_monthly_offset.line_items = [line3_offset, line4_offset]
      @support_deal_annual_my_offset.line_items = [line5_offset, line6_offset]
      @support_deal_monthly_my_offset.line_items = [line7_offset, line8_offset]
      @support_deal_bundled_offset.line_items = [line9_offset, line10_offset]
      @support_deal_annual_2free_offset.line_items = [line11_offset, line12_offset]
      @support_deal_monthly_2free_offset.line_items = [line13_offset, line14_offset]

      @support_deal_annual.save
      @support_deal_monthly.save
      @support_deal_annual_my.save
      @support_deal_monthly_my.save
      @support_deal_bundled.save
      @support_deal_annual_2free.save
      @support_deal_monthly_2free.save

      @support_deal_annual_offset.save
      @support_deal_monthly_offset.save
      @support_deal_annual_my_offset.save
      @support_deal_monthly_my_offset.save
      @support_deal_bundled_offset.save
      @support_deal_annual_2free_offset.save
      @support_deal_monthly_2free_offset.save

      @start_end = {:start_date => d('2012-01-01'), :end_date => d('2015-01-14')}
    end

    it "should calculate correctly for Annual" do
      #@support_deal_annual.line_items.length.should == 2
      result = Array.new(12, b('120'))
      result += Array.new(25, b('0'))
      @support_deal_annual.unearned_revenue_schedule_array(@start_end).should == result
    end
    it "should calculate correctly for Monthly" do
      result = Array.new(12, b('140'))
      result += Array.new(25, b('0'))
      @support_deal_monthly.unearned_revenue_schedule_array(@start_end).should == result
    end
    it "should calculate correctly for Annual+MY" do
      result = Array.new(12, b('110'))
      result += Array.new(25, b('0'))
      @support_deal_annual_my.unearned_revenue_schedule_array(@start_end).should == result
    end
    it "should calculate correctly for Monthly+MY" do
      result = Array.new(12, b('130'))
      result += Array.new(25, b('0'))
      @support_deal_monthly_my.unearned_revenue_schedule_array(@start_end).should == result
    end
    it "should calculate correctly for Bundled" do
      result = Array.new(36, b('50')) << b('0')
      @support_deal_bundled.unearned_revenue_schedule_array(@start_end).should == result
    end
    it "should calculate correctly for Annual + 2 free months" do
      amount = b('120')
      result = Array.new(14, amount*b('12')/b('14'))
      result += Array.new(23, b('0'))
      #puts result.map {|x| x.to_f}
      #puts @support_deal_annual_2free.unearned_revenue_schedule_array(@start_end).map {|x| x.to_f}
      actual = @support_deal_annual_2free.unearned_revenue_schedule_array(@start_end)
      result.each_with_index do |r,i|
        actual[i].should be_close(r,0.001)
      end
    end
    it "should calculate correctly for Monthly + 2 free months" do
      result = Array.new(14, b('140')*b('12')/b('14'))
      result += Array.new(23, b('0'))
      actual = @support_deal_monthly_2free.unearned_revenue_schedule_array(@start_end)
      result.each_with_index do |r,i|
        actual[i].should be_close(r,0.001)
      end
    end

    it "should calculate correctly for Annual Offset" do
      amount = b('120')
      result = [b('17')/b('31')*amount]
      result += Array.new(11, amount)
      result += [b('14')/b('31')*amount]
      result += Array.new(24, b('0'))
      @support_deal_annual_offset.unearned_revenue_schedule_array(@start_end).should == result
    end
    it "should calculate correctly for Monthly Offset" do
      amount = b('140')
      result = [b('17')/b('31')*amount]
      result += Array.new(11, amount)
      result += [b('14')/b('31')*amount]
      result += Array.new(24, b('0'))
      @support_deal_monthly_offset.unearned_revenue_schedule_array(@start_end).should == result
    end
    it "should calculate correctly for Annual+MY Offset" do
      amount = b('110')
      result = [b('17')/b('31')*amount]
      result += Array.new(11, amount)
      result += [b('14')/b('31')*amount]
      result += Array.new(24, b('0'))
      @support_deal_annual_my_offset.unearned_revenue_schedule_array(@start_end).should == result
    end
    it "should calculate correctly for Monthly+MY Offset" do
      amount = b('130')
      result = [b('17')/b('31')*amount]
      result += Array.new(11, amount)
      result += [b('14')/b('31')*amount]
      result += Array.new(24, b('0'))
      @support_deal_monthly_my_offset.unearned_revenue_schedule_array(@start_end).should == result
    end
    it "should calculate correctly for Bundled Offset" do
      amount = b('50')
      result = [b('17')/b('31')*amount]
      result += Array.new(35, amount)
      result += [b('14')/b('31')*amount]
      @support_deal_bundled_offset.unearned_revenue_schedule_array(@start_end).should == result
    end
    it "should calculate correctly for Annual + 2 free months Offset" do
      amount = b('120')*b('12')/b('14')
      result = [b('17')/b('31')*amount]
      result += Array.new(13, amount)
      result += [b('14')/b('31')*amount]
      result += Array.new(21, b('0'))
      actual = @support_deal_annual_2free_offset.unearned_revenue_schedule_array(@start_end)
      result.each_with_index do |r,i|
        actual[i].should be_close(r,0.001)
      end
    end
    it "should calculate correctly for Monthly + 2 free months Offset" do
      amount = b('140')*b('12')/b('14')
      result = [b('17')/b('31')*amount]
      result += Array.new(13, amount)
      result += [b('14')/b('31')*amount]
      result += Array.new(21, b('0'))
      actual = @support_deal_monthly_2free_offset.unearned_revenue_schedule_array(@start_end)
      result.each_with_index do |r,i|
        actual[i].should be_close(r,0.001)
      end

    end
    after :all do
      SupportDeal.delete_all
      LineItem.delete_all
    end
  end
end
