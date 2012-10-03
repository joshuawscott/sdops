class AddSiteSurveyDateToSupportDeals < ActiveRecord::Migration
  def self.up
    add_column :support_deals, :site_survey_date, :date
  end

  def self.down
    remove_column :support_deals, :site_survey_date
  end
end
