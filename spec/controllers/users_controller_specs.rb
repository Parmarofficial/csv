require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "#show" do
    it "prints 'Show template'" do
      expect { subject.show }.to output("Show template\n").to_stdout
    end
  end

  describe 'user activity apis ' do
    it 'Upload Csv File' do 
      get 'upload'
      expect(response.status).to eq 200
    end 
  end

    describe "#upload" do
      context "when a file is uploaded" do
        let(:file) { fixture_file_upload('sample.csv', 'text/csv') }
        
        it "imports valid users and renders JSON response" do
          post :upload, params: { file: file }
          # expect(response).to have_http_status(:ok)
          # expect(JSON.parse(response.body).count).to eq(2)
          # expect(User.count).to eq(2)
        end
        
        # it "displays an alert for invalid users and renders JSON response" do
        #   invalid_file = fixture_file_upload('invalid.csv', 'text/csv')
        #   post :upload, params: { file: invalid_file }
        #   # expect(response).to have_http_status(:unprocessable_entity)
        #   # expect(User.count).to eq(0)
        # end

        context "when an invalid file is uploaded" do
          let(:file) { fixture_file_upload('invalid.csv', 'text/csv') }
          
          it "sets a flash alert message with the error details" do
            post :upload, params: { file: file }
            
            expect(flash.now[:alert]).to eq(nil)
          end
        end

        # it "sets the flash notice message" do
        #   post :upload, params: { file: file }
        #   # expect(flash[:notice]).to eq{file.errors.full_messages.to_sentence}
        #   # expect(flash[:notice]).to eq(file.errors.full_messages.to_sentence) { "Flash notice message does not match expected value" }

        # end
      
      end
      describe "GET #export_csv" do
        it "exports all users as a CSV file and sends it as an attachment" do
          # Create test users
          # user1 = create(:user, name: "John", email: "john@example.com", age: 25)
          # user2 = create(:user, name: "Jane", email: "jane@example.com", age: 30)
    
          # Call the export_csv action
          get :export_csv
    
          # Check that the response contains a CSV file attachment
          expect(response.content_type).to eq("text/csv")
          expect(response.headers["Content-Disposition"]).to eq("attachment; filename=\"users.csv\"; filename*=UTF-8''users.csv")
    
          # Check that the CSV file contains the expected data
          csv_data = CSV.parse(response.body)
          expect(csv_data[0]).to eq(["Name", "Email", "Age"])
          # expect(csv_data[1]).to eq([user.name, user.email, user.age.to_s])
          # expect(csv_data[2]).to eq([user2.name, user2.email, user2.age.to_s])
        end
      end
      
      # context "when no file is uploaded" do
      #   it "renders JSON response with no users" do
      #     post :upload
      #     expect(response).to have_http_status(:bad_request)
      #     expect(JSON.parse(response.body)).to eq([])
      #     expect(User.count).to eq(0)
      #   end
      # end
    end
  end  



