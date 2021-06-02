require 'rails_helper'

RSpec.describe Project, type: :model do
  describe "validation checks" do
    it "is invalid without a name" do
      project = Project.new(name: nil)
      project.valid?
      expect(project.errors[:name]).to include("can't be blank")
    end  
  end

  describe "late status" do
    it "is late when the due date is past today" do
      project = FactoryBot.build(:project, :due_yesterday)
      expect(project).to be_late
    end

    it "is on time when the due date is today" do
      project = FactoryBot.build(:project, :due_today)
      expect(project).to_not be_late
    end

    it "is on time when the due date is in the future" do
      project = FactoryBot.build(:project, :due_tomorrow)
      expect(project).to_not be_late
    end
  end

  it "can have many notes" do
    project = FactoryBot.create(:project, :with_notes)
    expect(project.notes.length).to eq(5)
  end

  it "does not allow duplicate project names per user" do
    user = FactoryBot.create(:user, :with_project)

    new_project = user.projects.create(
      name: "Test Project"
    )

    new_project.valid?
    expect(new_project.errors[:name]).to include("has already been taken")
  end

  it "allows two users to share a project name" do
    user = FactoryBot.create(:user, :with_project)
    user2 = FactoryBot.create(:user, :with_project)

    expect(user2.projects.last).to be_valid
  end
end
