describe Vnstat do
  describe '.config' do
    subject { described_class.config }

    it { is_expected.to be_a Vnstat::Configuration }

    it 'is only instantiated once' do
      expect(subject).to be described_class.config
    end
  end

  describe '.configure' do
    context 'when no block given' do
      it 'raises' do
        expect { described_class.configure }
          .to raise_error(LocalJumpError, 'no block given (yield)')
      end
    end

    context 'when block given' do
      it 'yields once' do
        expect { |block| described_class.configure(&block) }
          .to yield_control.exactly(1).times
      end

      it 'yields with configuration' do
        expect { |block| described_class.configure(&block) }
          .to yield_with_args(described_class.config)
      end
    end
  end

  describe '.interfaces' do
    it 'calls Vnstat::InterfaceCollection.open' do
      binding.pry
      
      expect(Vnstat::InterfaceCollection).to receive(:open)
        .and_return(Vnstat::InterfaceCollection.new(''))

      subject.interfaces
    end
  end

  describe '.[]' do
    it 'calls Vnstat::Interface.open' do
      allow(Vnstat::Interface).to receive(:open)
        .and_return(Vnstat::Interface.new(''))

      subject['eth0']
    end
  end

  describe '.version' do
    it 'calls Utils.call_executable with -v argument' do
      expect(Vnstat::Utils).to receive(:call_executable).with('-v')

      described_class.version
    end
  end
end
