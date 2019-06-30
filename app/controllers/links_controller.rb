class LinksController < ApplicationController
  expose :link

  def destroy
    link.destroy
  end
end
