module AsyncTelegram
  class Update < Base
    attribute :update_id, Integer
    attribute :message, Message
    attribute :inline_query, InlineQuery
    attribute :chosen_inline_result, ChosenInlineResult
  end
end