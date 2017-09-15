require "email_backup_token"
require_relative "/jobs/regular/send_download_drive_link.rb"

class DownloadersController < Admin::AdminController
  requires_plugin 'discourse-sync-to-googledrive'

  def index
    google_list = DiscourseDownloadFromDrive::DriveDownloader.new(nil).json_list
    render json: google_list
  end

  def create
    file_id = params.fetch(:file_id)
    download_url = "#{url_for(controller: 'downloaders', action: 'create')}"
    Jobs.enqueue(:download_drive_email, to_address: 'example@email.com', drive_url: download_url)
    render nothing: true
  end

end
