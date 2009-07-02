module ContractTestHelper

  def fill_in_contract_form
    fill_in "Name", :with => "Company"
    select "22squared", :from => "Account"
    fill_in "SAID", :with => "foo"
    fill_in "SDC Reference", :with => "foo"
    fill_in "Description", :with => "stuff"
    select "bob smith", :from => "Sales Rep"
    select "Dallas", :from => "Sales Office"
    select "Dallas", :from => "Support Office"
    fill_in "Customer PO", :with => "PO1234"
    select "Annual", :from => "Payment Terms"
    select "HP9000/Integrity", :from => "Platform"
    fill_in "Amount Paid", :with => "150.00"
    fill_in "contract_annual_hw_rev", :with => "50.00"
    fill_in "contract_annual_sw_rev", :with => "40.00"
    fill_in "contract_annual_ce_rev", :with => "30.00"
    fill_in "contract_annual_sa_rev", :with => "20.00"
    fill_in "contract_annual_dr_rev", :with => "10.00"
    fill_in "contract_start_date", :with => "2009-01-01"
    fill_in "contract_end_date", :with => "2009-12-31"
    fill_in "contract_multiyr_end", :with => "2010-12-31"
    uncheck "contract_expired"
    select "SDC 24x7", :from => "contract_hw_support_level_id"
    select "SDC SW 24x7", :from => "contract_sw_support_level_id"
    select "true", :from => "SW Updates"
    fill_in "contract_ce_days", :with => "1"
    fill_in "contract_sa_days", :with => "1"
    fill_in "contract_discount_pref_hw", :with => "0.3"
    fill_in "contract_discount_pref_sw", :with => ".3"
    fill_in "contract_discount_pref_srv", :with => "0.30"
    fill_in "contract_discount_prepay", :with => "0.05"
    fill_in "contract_discount_multiyear", :with => ".05"
    fill_in "contract_discount_ce_day", :with => ".2"
    fill_in "contract_discount_sa_day", :with => "0.2"
    fill_in "contract_po_received", :with => "2008-12-15"
    fill_in "contract_address1", :with => "1234 Main St."
    fill_in "contract_address2", :with => "Suite 100"
    fill_in "contract_address3", :with => "Dallas, TX  75201"
    fill_in "contract_contact_name", :with => "Joe Customer"
    fill_in "contract_contact_phone", :with => "972-555-1212"
    fill_in "contract_contact_email", :with => "jcustomer@22squared.com"
  end

  def create_contract
    visit contracts_path
    response.should contain("SD Ops - Contract List")
    click_link "New Contract"
    fill_in_contract_form
    click_button "Create"
  end

  def populate_dropdowns
    Dropdown.create(:dd_name => 'payment_terms', :label => "Annual")
    Dropdown.create(:dd_name => 'platform', :label => 'HP9000/Integrity')
    Dropdown.create(:dd_name => 'support_type', :filter => 'hardware', :label => 'SDC 24x7')
    Dropdown.create(:dd_name => 'support_type', :filter => 'software', :label => 'SDC SW 24x7')
    Dropdown.create(:dd_name => 'support_providers', :label => 'Sourcedirect')
    Dropdown.create(:dd_name => 'support_providers', :label => 'DecisionOne')
  end

end
World(ContractTestHelper)
