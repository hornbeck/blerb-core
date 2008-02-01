require File.join(File.dirname(__FILE__), "../../../helper")

with_steps_for :article, :common, :boxy do
  run File.expand_path(__FILE__).gsub(".rb",""), :type => MerbStory
end