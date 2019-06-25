class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  expose :attachment, model: -> { ActiveStorage::Attachment }

  def destroy
    attachment.purge if current_user.author_of?(attachment.record)
  end
end
