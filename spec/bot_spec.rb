describe AsyncTelegram::Bot do
  AsyncTelegram::Bot::HANDLERS_METHODS.each do |name|
    context ".#{AsyncTelegram::Bot}" do

      before { described_class.send(name) {} }

      it 'pushes something' do
        expect(described_class::HANDLERS[name]).to_not be_empty
      end

      it 'something is block' do
        expect(described_class::HANDLERS[name].first).to be_a Proc
      end

    end
  end

  describe '.on_command_exec' do
    before { AsyncTelegram::Bot.on_command_exec(:start) }

    it 'something is block' do
      expect(described_class::COMMANDS_HANDLERS[:start]).to be_a Proc
    end
  end

end
