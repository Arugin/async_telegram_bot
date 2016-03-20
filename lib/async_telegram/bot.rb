require 'oj'
require 'active_support/all'

module AsyncTelegram
  class Bot
    HANDLERS = {}
    COMMANDS_HANDLERS = {}
    HANDLERS_METHODS = [:on_message, :on_text_message]

    class << self
      HANDLERS_METHODS.each do |name|
        define_method name do |&block|
          HANDLERS[name] ||= []
          HANDLERS[name] << block
        end
      end

      def on_command_exec(command, &block)
        COMMANDS_HANDLERS[command] = Proc.new do |message, api|
          if message.text.start_with?("/#{command}")
            block.call command, api
          end
        end
      end

      def handlers
        HANDLERS
      end
    end

    def initialize(token)
      @api = AsyncTelegram::Api.new(token)
    end

    def perform(request)
      data = Oj.load(request.body)
      update = AsyncTelegram::Update.new(data)
      message = extract_message(update)
      process_handlers(message)
    end

    private

    def process_handlers(message)
      if message.present?
        handlers[:on_message].each do |handler|
          handler.call(message, @api)
        end
        process_text(message)
      end
    end

    def process_text(message)
      if message.text.present?
        handlers[:on_text_message].each do |handler|
          handler.call(message, @api)
        end
        process_commands(message)
      end
    end

    def process_commands(message)

    end

    def extract_message(update)
      update.inline_query || update.chosen_inline_result || update.message
    end

  end
end
