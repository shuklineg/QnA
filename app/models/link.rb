class Link < ApplicationRecord
  GIST_FORMAT = /^(https|http):\/\/gist\.github\.com\/([^\/]+)\/([a-f0-9]+)$/i

  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, url: true

  def gist?
    url =~ GIST_FORMAT
  end

  def gist
    Octokit::Client.new.gist(url.split('/').last).files.map { |file| { name: file[0].to_s, content: file[1]['content'] } }
  end
end
