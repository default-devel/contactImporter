class ProcessCsvJob < ApplicationJob
  queue_as :default

  after_perform do |job|
    # Obj don't persist
    upload = Upload.find_by(uupid: job.arguments.first)

    # If status is not updated, asume fail
    upload.update(step: 3, status: UploadStatus.find_by(slug:'fail')) unless upload.status.slug == 'fini'

    # Always delete the files if wont be used anymore
    File.delete(upload.path) if File.exist?(upload.path)
  end


  def perform(uupid)
    # Init obj
    upload = Upload.find_by(uupid: uupid )
    # Update status
    upload.update(step: 2, status: UploadStatus.find_by(slug:'proc'))

    headers = upload.file_headers # headers['field'] => 'selected_header'
    # Again, asuming the file is not malicious
    file = File.open(upload.path)
    # Parse file, headers should match with the row
    # in the stored Array
    CSV.parse(file, headers: true) do |row|
      
      credit_card =  row[headers['credit_card']]
      # Get franchise before freeze
      franchise = upload.get_card_franchise(credit_card)
      # Crypt card and get last digits
      final_cc = upload.process_cc(credit_card) # return [salted_cc, last_digits]
      attr = {
        user: upload.user,
        upload: upload,
        name: row[ headers['name'] ],
        email: row[ headers['email'] ],
        phone: row[ headers['phone'] ],
        date_of_birth: row[ headers['date_of_birth'] ],
        address: row[ headers['address'] ],
        franchise: franchise,
        salted_cc: final_cc[0],
        last_digits: final_cc[1],
      }
      # Contact called separately due heritage update
      # If attr not valid, wont be able to update 
      # Upload obj further
      contact = Contact.new(attr)
      if contact.valid?
        contact.save
      else
        # If validations don't pass
        # Clone contact into volatile table, add errors and increment user
        # This table SHOULD be handled throuh another scheduled job
        pending_contact = upload.pending_contacts.new(attr)
        pending_contact.err_list = contact.errors.full_messages
        pending_contact.save if pending_contact.valid?
        upload.user.increment!(:pending_contacts_count)
      end
    end
    # Flow control if everything is fine
    upload.update!(step: 3, status: UploadStatus.find_by(slug:'fini'))
    upload.user.decrement!(:pending_uploads_count)
  end
end
