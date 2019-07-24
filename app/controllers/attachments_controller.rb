class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  expose :attachment, model: -> { ActiveStorage::Attachment }

  def destroy
    authorize! :destroy, attachment
    attachment.purge
  end
end
