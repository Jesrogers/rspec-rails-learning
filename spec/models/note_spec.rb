require 'rails_helper'

RSpec.describe Note, type: :model do
  describe "search messages for a term" do
    context "when a match is found" do
      it "returns notes that match the search term" do
        user = FactoryBot.create(:user, :with_project)
        project = user.projects.first
    
        note1 = project.notes.create(
          message: "This is the first note.",
          user: user,
        )
        note2 = project.notes.create(
          message: "This is the second note.",
          user: user,
        )
        note3 = project.notes.create(
          message: "First, preheat the oven.",
          user: user,
        )
    
        expect(Note.search("first")).to include(note1, note3)
      end    
    end
    context "when no match is found" do
      it "returns an empty collection" do
        user = FactoryBot.create(:user, :with_project)
        project = user.projects.first
    
        note1 = project.notes.create(
          message: "This is the first note.",
          user: user,
        )
        note2 = project.notes.create(
          message: "This is the second note.",
          user: user,
        )
        note3 = project.notes.create(
          message: "First, preheat the oven.",
          user: user,
        )
    
        expect(Note.search("message")).to be_empty
      end
    end
    
  end



end
