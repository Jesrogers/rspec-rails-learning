require 'rails_helper'

RSpec.describe Note, type: :model do
  describe "search messages for a term" do
    context "when a match is found" do
      it "returns notes that match the search term" do
        user = User.create(
          first_name: "Joe",
          last_name:  "Tester",
          email:      "joetester@example.com",
          password:   "dottle-nouveau-pavilion-tights-furze",
        )
    
        project = user.projects.create(
          name: "Test Project",
        )
    
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
        user = User.create(
          first_name: "Joe",
          last_name:  "Tester",
          email:      "joetester@example.com",
          password:   "dottle-nouveau-pavilion-tights-furze",
        )
    
        project = user.projects.create(
          name: "Test Project",
        )
    
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
