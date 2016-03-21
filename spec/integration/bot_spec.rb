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
        expect(proc).to receive(:call).with(message, instance_of(AsyncTelegram::Api))
        subject.process(request)
      end

    end
  end

end
