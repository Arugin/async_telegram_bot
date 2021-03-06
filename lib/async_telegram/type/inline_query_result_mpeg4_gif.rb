module AsyncTelegram
  class InlineQueryResultMpeg4Gif < Base
    attribute :type, String, default: 'mpeg4_gif'
    attribute :id, String
    attribute :mpeg4_url, String
    attribute :mpeg4_width, Integer
    attribute :mpeg4_height, Integer
    attribute :thumb_url, String
    attribute :title, String
    attribute :caption, String
    attribute :message_text, String
    attribute :parse_mode, String
    attribute :disable_web_page_preview, Boolean
  end
end
