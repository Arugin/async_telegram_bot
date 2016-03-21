require 'oj'
require 'active_support/all'

module AsyncTelegram
  class Bot
    attr_reader :handlers, :command_handlers

    HANDLERS_METHODS = [:on_message, :on_text_message]

    def define_methods
      HANDLERS_METHODS.each do |name|
        @handlers[name] ||= []
        class_eval do
          define_method name do |&block|
            @handlers[name] << block
          end
        end
      end
    end

    def on_command_exec(command, &block)
      @command_handlers[command] = Proc.new do |message, api|
        if message.text.start_with?("/#{command}")
          block.call message, api
        end
      end
    end

    def initialize(token)
      @api = AsyncTelegram::Api.new(token)
      @command_handlers = {}
      @handlers = {}
      define_methods
    end

    def process(request)
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
      command_handlers.each do |_, handler|
        handler.call(message, @api)
      end
    end

    def extract_message(update)
      update.inline_query || update.chosen_inline_result || update.message
    end

  end
end
