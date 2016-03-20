module AsyncTelegram
  class InlineQuery < Base
    attribute :id, String
    attribute :from, User
    attribute :query, String
    attribute :offset, String

    alias_method :to_s, :query
  end
end
