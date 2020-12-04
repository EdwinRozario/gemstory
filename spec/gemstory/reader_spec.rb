# typed: false
RSpec.describe Gemstory::Reader do
  before do
    git_log = "commit fakecommithash1\n
               Author: Aerials <aerials@gemstory.gem>\n
               Date:   Tue September 3 12:30:00 2001 +1200\n
               -    haml (4.0.7)\n
               +    haml (5.0.1)\n
               commit fakecommithash2\n
               Author: Toxicity <toxicity@gemstory.gem>\n
               Date:   Tue September 3 12:31:00 2001 +1200\n
               -    ruby_parser (3.8.4)\n
               +    ruby_parser (3.9.0)\n
               commit fakecommithash3\n
               Author: Aerials <aerials@gemstory.gem>\n
               Date:   Tue September 3 12:32:00 2001 +1200\n
               -    haml (5.0.1)\n
               +    haml (5.1.1)\n"

    allow_any_instance_of(Gemstory::Reader).to receive(:follow_log).and_return(git_log)
  end

  describe '#call' do
    let(:history) { Gemstory::Reader.new.call }

    it 'has keys for the gems in log' do
      expect(history.keys).to include :haml
      expect(history.keys).to include :ruby_parser
    end

    it 'has one commit' do
      expect(history[:haml].count).to eq 2
    end

    it 'has haml current version' do
      expect(history[:haml].first[:version]).to eq '5.0.1'
    end

    it 'has author for commit' do
      expect(history[:haml].first[:author]).to eq 'Aerials <aerials@gemstory.gem>'
    end

    it 'has commit hash for the commit' do
      expect(history[:haml].first[:commit]).to eq 'fakecommithash1'
      expect(history[:haml].last[:commit]).to eq 'fakecommithash3'
    end
  end
end


