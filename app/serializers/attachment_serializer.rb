class AttachmentSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :file_name, :path

  def path
    rails_blob_path(object, disposition: 'attachment', only_path: true)
  end

  def file_name
    object.filename.to_s
  end
end
