class Search < ApplicationRecord
  belongs_to :user

  # Delete the previous search from the same user (identified by uuid)
  # if the new search query starts with the same text

  before_validation :to_lower, :delete_intermediate_searches

  validate :query_cannot_be_subset_of_previous_query

  private

  def to_lower
    query.downcase!
  end

  def delete_intermediate_searches
    previous_search = user.searches.last
    return unless previous_search

    previous_search.destroy if intermediate_search? previous_search
  end

  def query_cannot_be_subset_of_previous_query
    previous_search = user.searches.last
    return unless previous_search

    errors.add(:query, "can't be subset of previous query") if previous_search.intermediate_search? self
  end

  protected

  def intermediate_search?(other_search)
    query.delete(' ').start_with? other_search.query.delete(' ')
  end
end
