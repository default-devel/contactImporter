class UploadController < ApplicationController
  def list
    @uploads = current_user.uploads
  end
  def new
    # silence is golden
  end
  def import
    file = import_params[:csv_file]
    headers = import_params[:headers].to_h
    # Init to reduce noise
    upload = Upload.init(file.tempfile, file.original_filename, current_user, headers)
    # Send job to queue
    ProcessCsvJob.perform_later(upload.uupid)
    # Go back to the list
    redirect_to upload_list_path
  end
  def pending
    @pendings = current_user.pending_contacts
  end

  private

  def import_params
    params.permit(:csv_file, headers: [:name, :email, :phone, :date_of_birth, :address, :credit_card])
  end
  
end
