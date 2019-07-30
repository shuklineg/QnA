class LinkSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :name, :url, :created_at, :updated_at
end
