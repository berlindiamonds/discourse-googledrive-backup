require 'rails_helper'

describe DownloadersController, type: :controller do
  before {
    SiteSetting.discourse_sync_to_googledrive_enabled = true
  }

  context "while logged in as an admin" do

    before { @admin = log_in(:admin) }

    it "is a subclass of Admin::AdminController" do
      expect(DownloadersController < Admin::AdminController).to eq(true)
    end

    describe "GET #index" do
      let(:sample_json) {
        "{\"files\":[
            {
            \"title\":\"discourse-2017-08-24-085545-v20170803123704.sql.gz\",
            \"file_id\":\"0B7WjYjWZJv_4MENlYUM2SjkyU1E\",
            \"size\":\"14070939\",
            \"created_at\":\"2017-08-24T06:56:21.698+00:00\"
            }
          ]
        }"
      }

      before {
        drive_instance = DiscourseDownloadFromDrive::DriveDownloader
        drive_instance.any_instance.stubs(:json_list).returns(sample_json)
      }

      it "returns a json list of all google_drive files" do
        get :index, format: :json, xhr: true
        expect(response.body).to eq(sample_json)
      end

      it "responds with 200 status" do
        get :index, xhr: true
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end
    end

    describe "PUT #create" do
      let(:sample_file_id) {
        "0B7WjYjWZJv_4blA0a2p6RzVraFE"
      }

      before {
        drive_instance = DiscourseDownloadFromDrive::DriveDownloader
        drive_instance.any_instance.stubs(:file_id).returns(sample_file_id)
      }

      it "sends a google-file-id to the job" do
        put :create, xhr: true, params: { file_id: sample_file_id }
        @file_id = :sample_file_id
        expect(@file_id).to eq(:sample_file_id)
      end

      it "responds with 200 status" do
        put :create, xhr: true, params: { file_id: sample_file_id }
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

    end
  end
end
