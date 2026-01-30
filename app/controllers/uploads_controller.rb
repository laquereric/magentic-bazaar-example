class UploadsController < ApplicationController
  def new
  end

  def create
    uploaded_files = Array(params[:files])

    if uploaded_files.empty?
      redirect_to new_upload_path, alert: "Please select at least one file."
      return
    end

    ingest_dir = MagenticBazaar.configuration.ingest_dir
    FileUtils.mkdir_p(ingest_dir)

    saved = 0
    uploaded_files.each do |file|
      filename = file.original_filename
      dest = File.join(ingest_dir, filename)
      File.open(dest, "wb") { |f| f.write(file.read) }
      saved += 1
    end

    redirect_to new_upload_path, notice: "#{saved} file(s) uploaded to ingest directory."
  end
end
