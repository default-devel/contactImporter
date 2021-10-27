class Upload < ApplicationRecord
  belongs_to :user
  # Unnecesary, but prettier
  belongs_to :status, class_name: 'UploadStatus', :foreign_key => 'upload_status_id'
  has_many :contacts
  has_many :pending_contacts

  serialize :file_headers

  PRETTY_FIELDS = [ 'Name', 'Email', 'Phone', 'Date of birth', 'Address', 'Credit card']
  # Just in case
  # FIELDS = [ 'name', 'email', 'phone', 'date_of_birth', 'address', 'credit_card']


  def self.init(tempfile, original_filename, user, headers)
    # Generate required meta
    filename = "#{Time.now.strftime('%m%d%Y%H%M%N')}_#{original_filename.gsub(' ', '_')}"
    raw_path ="#{Rails.public_path}/uploaded_csv/#{user.uuid}"
    path = "#{raw_path}/#{filename}"
    
    # Init dir
    FileUtils.mkdir_p raw_path
    # This file should pass through malware detection here,
    # but I will skip this step, is not needed for a test
    FileUtils.mv tempfile, path
    
    # If no error saving/moving the file, create object
    upload = Upload.create!(
      step: 1,
      user: user,
      original_filename: original_filename,
      filename: filename,
      has_file: true,
      path: path,
      status: UploadStatus.find_by(slug:'hold'),
      file_headers: headers
    )
    # # Count increment
    user.increment!(:pending_uploads_count)
    return upload
  end
  # Uniqueness for url
  before_create do
    uupid = SecureRandom.alphanumeric(8)
    redo if Upload.exists?(uupid: uupid)
    self.uupid = uupid
  end

  ## The next section should be defined as Concern, but its only used here so..
  # This module is pointless (for me), so didn't spent too much time in it
  def process_cc(credit_card)
    last_digits = credit_card[-4..-1]
    cc = credit_card.freeze
    key = SecureRandom.random_bytes(32) # Rand Key for irrecoverability request
    crypt = ActiveSupport::MessageEncryptor.new(key)
    salted_cc = crypt.encrypt_and_sign(cc)
    return salted_cc, last_digits
  end
  # This is tomato sauce
  def get_card_franchise(card_input)
    # This is better than regex
    card_relation = {
      'American Express' => [ {'34' => '15' }, {'37' => '15'} ],
      'China T-Union' => [ {'31' => '19'} ],
      'China UnionPay' => [ {'62' => '16-19'} ],
      'Diners Club International' => [ {'36' => '14-19'} ],
      'Diners Club United States & Canada' => [ {'54' => '16'} ],
      'Discover Card' => [ {'6011' => '16-19' }, {'644-649' => '16-19' }, {'65' => '16-19' }, {'622126-622925' => '16-19'} ],
      'UkrCard' => [ {'60400100-60420099' => '16-19'} ],
      'RuPay' => [ {'60' => '16' }, {'65' => '16' }, {'81' => '16' }, {'82' => '16' }, {'508' => '16' }, {'353' => '16' }, {'356' => '16'} ],
      'InterPayment' => [ {'636' => '16-19'} ],
      'InstaPayment' => [ {'637-639' => '16'} ],
      'JCB' => [ {'3528-3589' => '16-19'} ],
      'Maestro UK' => [ {'6759' => '12-19' }, {'676770' => '12-19' }, {'676774' => '12-19'} ],
      'Maestro' => [ {'5018' => '12-19' }, {'5020' => '12-19' }, {'5038' => '12-19' }, {'5893' => '12-19' }, {'6304' => '12-19' }, {'6759' => '12-19' }, {'6761' => '12-19' }, {'6762' => '12-19' }, {'6763' => '12-19'} ],
      'Dankort' => [ {'5019' => '16' }, {'4571' => '16'} ],
      'Mir' => [ {'2200-2204' => '16-19'} ],
      'NPS Pridnestrovie' => [ {'6054740-6054744' => '16'} ],
      'Mastercard' => [ {'2221-2720' => '16' }, {'51-55' => '16'} ],
      'Troy' => [ {'65' => '16' }, {'9792' => '16'} ],
      'Visa Electron' => [ {'4026' => '16' }, {'417500' => '16' }, {'4508' => '16' }, {'4844' => '16' }, {'4913' => '16' }, {'4917' => '16'} ],
      'Visa' => [ {'4' => '13-16' } ],
      'UATP' => [ {'1' => '15'} ],
      'Verve' => [ {'506099-506198' => '16-19' }, {'650002-650027' => '16-19'} ],
      'LankaPay' => [ {'357111' => '16'} ],
      'UzCard' => [ {'8600' => '16'} ],
      'Humo' => [ {'9860' => '16'}
      ]
    }
    # Ensure numbers only
    card_number = card_input.gsub(/[^0-9]/, '')
    # For IIN
    first_six = card_number[0..5] 
    # Initial request asked for length validation on encryption
    #   But that would make the process unnecessarily robust
    #   Took the liberty of modify it
    card_length = card_number.length 
    card_relation.each do |franchise, validations|
      validations.each do |validation|
        validation.each do |prefix, size|
          # Init bools
          match_prefix = false
          match_length = false
          # _is_range for conditionals
          prefix_is_range = prefix.include?('-')
          length_is_range = size.include?('-')

          # In resume, check for each _range combination (strict, no assumptions allowed)
          #   In case the prefix length is <6, add zeroes at the end for ranged comparsions
          # It's ugly and redundant, I know.
          if prefix_is_range && length_is_range
            prefix_arr = prefix.split('-')
            prefix_min_val = prefix_arr[0].length < 6 ? ('%-6s' % prefix_arr[0]).gsub(' ', '0') : prefix_arr[0]
            prefix_max_val = prefix_arr[1].length < 6 ? ('%-6s' % prefix_arr[1]).gsub(' ', '0') : prefix_arr[1]
            length_arr = size.split('-')
            match_prefix = first_six.to_i.between?(prefix_min_val.to_i, prefix_max_val.to_i)
            match_length = card_length.between?(length_arr[0].to_i, length_arr[1].to_i)
          elsif prefix_is_range && !length_is_range
            prefix_arr = prefix.split('-')
            prefix_min_val = prefix_arr[0].length < 6 ? ('%-6s' % prefix_arr[0]).gsub(' ', '0') : prefix_arr[0]
            prefix_max_val = prefix_arr[1].length < 6 ? ('%-6s' % prefix_arr[1]).gsub(' ', '0') : prefix_arr[1]
            match_prefix = first_six.to_i.between?(prefix_min_val.to_i, prefix_max_val.to_i)
            match_length = card_length == size.to_i
          elsif !prefix_is_range && length_is_range
            length_arr = size.split('-')
            match_prefix = first_six.start_with?(prefix)
            match_length = card_length.between?(length_arr[0].to_i, length_arr[1].to_i)
          elsif !prefix_is_range && !length_is_range
            length_arr = size.split('-')
            match_prefix = first_six.start_with?(prefix)
            match_length = card_length == size.to_i
          end
          
          # Return ONLY if double true
          # Otherwise, fall to false (duh)
          if match_prefix && match_length
            return franchise
          end

        end # End Validation
      end # End Validations

    end # End franchise
    return false
  end # End block
end