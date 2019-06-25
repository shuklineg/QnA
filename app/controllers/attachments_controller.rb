class AttachmentsController < ApplicationController
  expose :attachment, model: -> { ActiveStorage::Attachment }

  def destroy
    attachment.purge if current_user.author_of?(attachment.record)
  end
end
