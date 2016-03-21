require 'spec_helper'

describe AsyncTelegram::Bot do
  let(:bot) { described_class.new('tocken') }

  AsyncTelegram::Bot::HANDLERS_METHODS.each do |name|
    context ".#{AsyncTelegram::Bot}" do

      before { bot.send(name) {} }

      it 'pushes something' do
        expect(bot.handlers[name]).to_not be_empty
      end

      it 'something is block' do
        expect(bot.handlers[name].first).to be_a Proc
      end

    end
  end

  describe '.on_command_exec' do
    before { bot.on_command_exec(:start) }

    it 'something is block' do
      expect(bot.command_handlers[:start]).to be_a Proc
    end

  end

end
