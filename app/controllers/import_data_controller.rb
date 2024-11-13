# frozen_string_literal: true

# ImportDataController handles all the methods related to the importing student/admin data through excel file
class ImportDataController < ApplicationController
  def index; end

  def delete_data
    User.where.not(id: @user.id).destroy_all
    flash[:notice] = 'All the records have been deleted successfully.'
    redirect_to import_path and return
  end

  def upload_data
    return unless params[:fileUpload]

    begin
      file = params[:fileUpload]
      spreadsheet = get_spreadsheet(file)
      header = spreadsheet.row(1)
      redirect_to import_path and return unless validate_headers(header)

      process_data(spreadsheet, header)

      flash[:notice] = 'File uploaded and data imported successfully!'
    rescue StandardError => e
      flash[:alert] = "An error occurred while processing the file: #{e.message}"
    end
    redirect_to import_path and return
  end

  private

  def get_spreadsheet(file)
    if file.content_type == 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
      Roo::Excelx.new(file.path)
    elsif file.content_type == 'text/csv'
      Roo::CSV.new(file.path)
    end
  end

  def validate_headers(header)
    required_headers = ['First Name', 'Last Name', 'Contact', 'Email', 'Role']
    missing_headers = required_headers - header

    if missing_headers.any?
      flash[:alert] = "File has missing required columns: #{missing_headers.join(', ')}"
      return false
    end
    true
  end

  def process_data(spreadsheet, header)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]

      if row['First Name'].blank? || row['Contact'].blank? || row['Last Name'].blank? || row['Email'].blank? || row['Role'].blank?
        flash[:alert] = "Row #{i} is missing required data. Please check the file and try again."
        return nil
      end

      user = User.find_or_initialize_by(email: row['Email'])

      user.assign_attributes(
        first_name: row['First Name'],
        last_name: row['Last Name'],
        contact: row['Contact'],
        role: row['Role'],
        email: row['Email']
      )

      user.save!
    end
  end
end
