require 'spec_helper'

describe AsyncTelegram::Bot do
  let(:message) { AsyncTelegram::Message.new(text: '/start') }
  let(:update) { AsyncTelegram::Update.new(message: message) }
  let(:request) do
    request = double
    allow(request).to receive(:body).and_return(update.to_json)
    request
  end
  let(:proc) { Proc.new {} }

  before { ENV['TELEGRAM_API_ENDPOINT'] = 'http://bot.com' }

  subject { described_class.new('my_token') }

  describe '#process' do

    context 'when on_message called' do
      before { subject.on_message(&proc) }

      it 'sends message to proc' do
        expect(proc).to receive(:call).with(instance_of(AsyncTelegram::Message), instance_of(AsyncTelegram::Api))
        subject.process(request)
      end

    end

    context 'when on_text_message called' do
      before { subject.on_text_message(&proc) }

      it 'sends message to proc' do
        expect(proc).to receive(:call).with(instance_of(AsyncTelegram::Message), instance_of(AsyncTelegram::Api))
        subject.process(request)
      end

    end

    context 'when on_command_exec called' do
      before { subject.on_command_exec(:start, &proc) }

      it 'sends message to proc' do
        expect(proc).to receive(:call).with(instance_of(AsyncTelegram::Message), instance_of(AsyncTelegram::Api))
        subject.process(request)
      end

      context 'when no /start in message' do
        let(:message) { AsyncTelegram::Message.new(text: 'start') }

        it 'doesn\'t send message to proc' do
          expect(proc).to_not receive(:call).with(instance_of(AsyncTelegram::Message), instance_of(AsyncTelegram::Api))
          subject.process(request)
        end
      end

    end

  end

end
