require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
    describe "#index" do
        context "as an authenticated user" do
            before do
                @user = FactoryBot.create(:user)
                sign_in @user
            end

            it "responds successfully" do
                get :index
                expect(response).to be_success
            end
        
            it "returns a 200 response" do
                get :index
                expect(response).to have_http_status "200"
            end
        end

        context "as a guest" do
            it "returns a 302 response" do
                get :index
                expect(response).to have_http_status "302"
            end
        
            it "redirects to the sign-in page" do
                get :index
                expect(response).to redirect_to "/users/sign_in"
            end            
        end
    end

    describe "#show" do
        context "as an authorized user" do
            before do
                @user = FactoryBot.create(:user)
                @project = FactoryBot.create(:project, owner: @user)
                sign_in @user
            end

            it "responds successfully" do
                get :show, params: { id: @project.id }
                expect(response).to be_success
            end
        end

        context "as an unauthorized user" do
            before do
                @user = FactoryBot.create(:user)
                other_user = FactoryBot.create(:user)
                @project = FactoryBot.create(:project, owner: other_user)
                sign_in @user
            end

            it "redirects to the dashboard" do
                get :show, params: { id: @project.id }
                expect(response).to redirect_to root_path
            end
        end
    end

    describe "#create" do
        context "as an authenticated user" do
            before do
                @user = FactoryBot.create(:user)
                sign_in @user
            end

            it "adds a project" do
                project_params = FactoryBot.attributes_for(:project)
                expect {
                    post :create, params: { project: project_params }
                }.to change(@user.projects, :count).by(1)
            end

            context "with valid attributes" do
                it "adds a project" do
                    project_params = FactoryBot.attributes_for(:project)
                sign_in @user
                expect {
                    post :create, params: { project: project_params }
                }.to change(@user.projects, :count).by(1)
                end
            end
            
            context "with invalid attributes" do
                it "does not add a project" do
                    project_params = FactoryBot.attributes_for(:project, :invalid)
                    sign_in @user
                    expect {
                        post :create, params: { project: project_params }
                    }.to_not change(@user.projects, :count)
                end
            end
        end

        context "as a guest" do
            it "returns a 302 response" do
                project_params = FactoryBot.attributes_for(:project)
                post :create, params: { project: project_params }
                expect(response).to have_http_status "302"
            end
        
            it "redirects to the sign-in page" do
                project_params = FactoryBot.attributes_for(:project)
                post :create, params: { project: project_params }
                expect(response).to redirect_to "/users/sign_in"
            end            
        end
    end

    describe "#update" do
        context "as an authorized user" do
            before do
                @user = FactoryBot.create(:user)
                @project = FactoryBot.create(:project, owner: @user)
                sign_in @user
            end

            it "updates a project" do
                project_params = FactoryBot.attributes_for(:project, name: "Updated name")
                patch :update, params: { id: @project.id, project: project_params }
                expect(@project.reload.name).to eq("Updated name")
            end
        end

        context "as an unauthorized user" do
            before do
                @user = FactoryBot.create(:user)
                other_user = FactoryBot.create(:user)
                @project = FactoryBot.create(:project, name: "Test project", owner: other_user)
                sign_in @user
            end

            it "does not update the name" do
                project_params = FactoryBot.attributes_for(:project, name: "Updated name")
                patch :update, params: { id: @project.id, project: project_params }
                expect(@project.reload.name).to eq("Test project")
            end

            it "redirects to the dashboard" do
                project_params = FactoryBot.attributes_for(:project, name: "Updated name")
                patch :update, params: { id: @project.id, project: project_params }
                expect(response).to redirect_to root_path
            end
        end

        context "as a guest" do
            before do
                @project = FactoryBot.create(:project, name: "Test project")
            end

            it "returns a 302 response" do
                project_params = FactoryBot.attributes_for(:project, name: "Updated name")
                patch :update, params: { id: @project.id, project: project_params }
                expect(response).to have_http_status("302")
            end

            it "redirects to the sign-in page" do
                project_params = FactoryBot.attributes_for(:project, name: "Updated name")
                patch :update, params: { id: @project.id, project: project_params }
                expect(response).to redirect_to("/users/sign_in")
            end
        end
    end

    describe "destroy" do
        context "as an authorized user" do
            before do
                @user = FactoryBot.create(:user)
                @project = FactoryBot.create(:project, owner: @user)
                sign_in @user
            end

            it "deletes the project" do
                expect {
                    delete :destroy, params: { id: @project.id }
                }.to change(@user.projects, :count).by(-1)
            end
        end

        context "as an unauthorized user" do
            before do
                @user = FactoryBot.create(:user)
                other_user = FactoryBot.create(:user)
                @project = FactoryBot.create(:project, owner: other_user)
                sign_in @user
            end

            it "does not delete the project" do
                expect {
                    delete :destroy, params: { id: @project.id }
                }.to_not change(@user.projects, :count)                
            end

            it "redirects to the dashboard" do
                delete :destroy, params: { id: @project.id }
                expect(response).to redirect_to root_path
            end
        end

        context "as a guest" do
            before do
                @project = FactoryBot.create(:project)    
            end
            
            it "returns a 302 response" do
                delete :destroy, params: { id: @project.id }
                expect(response).to have_http_status("302")
            end

            it "redirects to the sign-in page" do
                delete :destroy, params: { id: @project.id }
                expect(response).to redirect_to "/users/sign_in"    
            end

            it "does not delete the project" do
                expect {
                    delete :destroy, params: { id: @project.id }
                }.to_not change(Project, :count)
            end

        end
    end


end
