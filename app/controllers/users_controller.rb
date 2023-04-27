class UsersController < ApplicationController
  def new
  end

  def show
    puts "Show template"
  end

  def upload
    if params[:file].present?
      rows = []
      CSV.foreach(params[:file].path, headers: true) do |row|
        user = User.new(row.to_hash)
        if user.valid?
          rows << user
        else
          flash.now[:alert] = "Invalid data in row #{row.index + 1}: #{user.errors.full_messages.to_sentence}"


          # redirect_to users_upload_path and return
          render json: @users
        end
      end
      User.import(rows)
      @users = User.all
      # redirect_to users_upload_path, notice: "File uploaded successfully"
      render json: @users
    else
      # redirect_to users_upload_path, alert: "Please choose a file to upload"
      render json: @users
    end
  end

  def export_csv
    @users = User.all
    require 'csv'

    csv_string = CSV.generate do |csv|
      # add header row
      csv << ['Name', 'Email', 'Age']

      # add data rows
      @users.each do |user|
        csv << [user.name, user.email, user.age]
      end
    end

    File.open(Rails.root.join('app/assets', 'users.csv'), 'w') do |file|
      file.write(csv_string)
    end

    send_file Rails.root.join('app/assets', 'users.csv'), type: 'text/csv', disposition: 'attachment'
  end

end
