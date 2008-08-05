require File.dirname(__FILE__) + "/helper"

with_steps_for(:contract) do
  run "stories/contract_story", :type => RailsStory
end
