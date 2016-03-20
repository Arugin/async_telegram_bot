module AsyncTelegram
  class ReplyKeyboardHide < Base
    attribute :hide_keyboard, Boolean
    attribute :selective, Boolean, default: false
  end
end