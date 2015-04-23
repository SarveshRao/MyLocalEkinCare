class MedicalRecordUploader < CarrierWave::Uploader::Base
  # include CarrierWave::MiniMagick

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
     %w(zip rar ppt pptx wps wpd txt rtf pdf htm docx doc swf  mp3 psd png jpg gif jpeg bmp xls xlsx)
  end
end
