# frozen_string_literal: true

RSpec.describe Gemstory::Cli do
  describe '#initialize' do
    it 'initializes a vertical printer' do
    end

    context 'with arguments' do
      let(:cli) { Gemstory::Cli.new([1]) }

      it 'initializes a vertical printer' do
        expect(cli.printer).to eq Gemstory::Printer::Vertical
      end
    end

    context 'without arguments' do
      let(:cli) { Gemstory::Cli.new([]) }

      it 'initializes a horizontal printer' do
        expect(cli.printer).to eq Gemstory::Printer::Horizontal
      end
    end
  end
end
