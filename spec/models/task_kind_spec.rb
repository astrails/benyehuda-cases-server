require 'spec_helper'

describe TaskKind do
  let(:task_kind){Factory.create(:task_kind)}
  let(:task){Factory.create(:task, :kind => task_kind)}

  it "should create TaskKind" do
    task_kind
  end

  it "should delete TaskKind" do
    task_kind.delete
  end

  describe :validations do
    it "should validate name presence" do
      lambda {
        Factory.create(:task_kind, :name => nil)
      }.should raise_error ActiveRecord::RecordInvalid
    end

    it "should validate name uniqueness" do
      lambda {
        Factory.create(:task_kind, :name => task_kind.name)
      }.should raise_error ActiveRecord::RecordInvalid
    end

    it "should not delete record if there are associated tasks and add error" do
      kind = task.kind
      kind.destroy
      kind.errors.should_not be_blank
    end
  end
end
