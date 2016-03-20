module AsyncTelegram
  class ChosenInlineResult < Base
    attribute :result_id, String
    attribute :from, User
    attribute :query, String

    alias_method :to_s, :query
  end
end
