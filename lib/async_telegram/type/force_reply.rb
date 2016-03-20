module AsyncTelegram
  class ForceReply < Base
    attribute :force_reply, Boolean
    attribute :selective, Boolean, default: false
  end
end
