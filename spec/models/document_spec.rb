# require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
# 
# describe Document do
#   describe "validations" do
#     before(:each) do
#       Document.stub!(:has_attached_file).and_return(true)
#       @document = Document.new
#       @document.should_not be_valid
#     end
#     [:user_id, :task_id, :file].each do |a|
#       it "should validate #{a}" do
#         @document.errors.on(a).should_not be_valid
#       end
#     end
#   end
# end
