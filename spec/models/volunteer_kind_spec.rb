require 'spec_helper'

describe VolunteerKind do
  let(:volunteer_kind){Factory.create(:volunteer_kind)}
  let(:volunteer){Factory.create(:volunteer, :volunteer_kind_id => volunteer_kind.id)}

  describe :validations do
    it "should validate name presence" do
      lambda {
        Factory.create(:volunteer_kind, :name => nil)
      }.should raise_error ActiveRecord::RecordInvalid
    end

    it "should validate name uniqueness" do
      lambda {
        Factory.create(:volunteer_kind, :name => volunteer_kind.name)
      }.should raise_error ActiveRecord::RecordInvalid
    end

    it "should not delete record if there are associated volunteers and add an error" do
      kind = volunteer.kind
      kind.destroy
      kind.errors.should_not be_blank
    end
  end
end
