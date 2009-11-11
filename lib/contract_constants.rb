# To avoid cluttering Contract (more than it is already...) This is a repository for the hard-coded data in contracts.
module ContractConstants
  def hw_support_description
    case hw_support_level_id
    when "SDC 24x7"
      "Hardware Problem Diagnosis
Onsite Hardware Support
Parts and Material Provided
4 Hour On-site Response
7 Days/Week
24 Hours per Day
Predictive System Monitoring
Assigned Hardware Engineer"
    when "SDC CS"
      "Hardware Problem Diagnosis
Onsite Hardware Support
Parts and Material Provided
6 Hour Call-to-Repair
7 Days/Week
24 Hours per Day
Predictive System Monitoring"
    when "SDC ND"
      "Hardware Problem Diagnosis
Onsite Hardware Support
Parts and Material Provided
Next Business Day On-site
Monday - Friday
8AM - 5PM
Predictive System Monitoring
Assigned Hardware Engineer"
    when "SDC SD"
      "Hardware Problem Diagnosis
Onsite Hardware Support
Parts and Material Provided
4 Hour On-site Response
Monday - Friday
8AM - 9PM
Predictive System Monitoring"
    else "No HW Support"
    end
  end

  def sw_support_description
    @sw_support_description = case sw_support_level_id
    when "SDC SW 24x7"
      "2 Hour Remote Response
7 Days/Week
24 Hours per Day
Patch Assistance
Assigned Software Engineer"
    when "SDC SW 13x5"
      "2 Hour Remote Response
Monday - Friday
8AM - 9PM 
Patch Assistance"
    else "No SW Support"
    end
    if updates == "false"
      @sw_support_description += "\nSoftware Updates Not Provided" if @sw_support_description != "No SW Support"
    end
    @sw_support_description
  end
end
