class Search
  include ActiveModel::Validations

  INDICES = [['Answer', 'answer'], ['Question', 'question'], ['User', 'user'], ['Comment', 'comment']].freeze

  attr_accessor :query, :indices

  validates :query, length: { minimum: 4 }
  validate :validate_indices

  def initialize(attr = {})
    @query = attr[:query]
    @indices = attr[:indices] || []
  end

  def self.find(params)
    search = new(params)
    search.validate
    search
  end

  def results
    return [] if invalid?

    escaped_query = ThinkingSphinx::Query.escape(query)
    ThinkingSphinx.search(escaped_query, indices: indices)
  end

  private

  def validate_indices
    errors.add(:indices) unless (indices - INDICES.map { |index| index[1] }).empty?
  end
end
