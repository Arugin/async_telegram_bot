require 'eventmachine'

module AsyncTelegram
  class Api
    ENDPOINTS = %w(
        getMe sendMessage forwardMessage sendPhoto sendAudio sendDocument
        sendSticker sendVideo sendVoice sendLocation sendChatAction
        getUserProfilePhotos setWebhook getFile answerInlineQuery
      ).freeze
    REPLY_MARKUP_TYPES = [
        AsyncTelegram::ReplyKeyboardMarkup,
        AsyncTelegram::ReplyKeyboardHide,
        AsyncTelegram::ForceReply
    ].freeze
    INLINE_QUERY_RESULT_TYPES = [
        AsyncTelegram::InlineQueryResultArticle,
        AsyncTelegram::InlineQueryResultGif,
        AsyncTelegram::InlineQueryResultMpeg4Gif,
        AsyncTelegram::InlineQueryResultPhoto,
        AsyncTelegram::InlineQueryResultVideo
    ].freeze

    def initialize(token)
      @conn = EventMachine::HttpRequest.new(ENV['TELEGRAM_API_ENDPOINT'])
      @token = token
    end

    def method_missing(method_name, *args, &block)
      endpoint = method_name.to_s
      endpoint = camelize(endpoint) if endpoint.include?('_')

      ENDPOINTS.include?(endpoint) ? call(endpoint, *args, &block) : super
    end

    def call(endpoint, raw_params = {})
      params = build_params(raw_params)
      pipe = @conn.post path: "/bot#{@token}/#{endpoint}", keepalive: true, query: params
      pipe.callback do
        status = pipe.response_header.status.to_i
        if status == 200 && block_given?
          yield pipe.response
        end
      end
    end

    def download(file)
      pipe = @conn.get path: "/file/bot#{@token}/#{file.file_path}"
      pipe.callback do
        status = pipe.response_header.status.to_i
        if status == 200 && block_given?
          yield pipe.response
        end
      end
    end

    private

    def build_params(h)
      h.each_with_object({}) do |(key, value), params|
        params[key] = sanitize_value(value)
      end
    end

    def sanitize_value(value)
      jsonify_inline_query_results(jsonify_reply_markup(value))
    end

    def jsonify_reply_markup(value)
      return value unless REPLY_MARKUP_TYPES.include?(value.class)
      value.to_h.to_json
    end

    def jsonify_inline_query_results(value)
      return value unless value.is_a?(Array) && value.all? { |i| INLINE_QUERY_RESULT_TYPES.include?(i.class) }
      value.map { |i| i.to_h.select { |_, v| v } }.to_json
    end

    def camelize(method_name)
      words = method_name.split('_')
      words.drop(1).map(&:capitalize!)
      words.join
    end

  end
end
