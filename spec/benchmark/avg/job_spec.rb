require_relative '../spec_helper'

module Benchmark::Avg
  RSpec.describe Job do
    let(:block) { proc {sleep 0.1}}
    let(:label) {'some label'}
    subject(:job) {described_class.new label, block}

    it { is_expected.not_to be_nil}

    describe 'reports' do
      let(:fake_io) {FakeIO.new}
      before :each do
        $stdout = fake_io
        job.run 0.5, 0.5
        $stdout = STDOUT
      end

      it "prints a note about the warm up phase being over" do
        expect(fake_io.output).to match /finish.+warm up/i
      end
      
      shared_examples_for 'static run time report' do
        it "gets the reportright" do
          expect(subject).to include label
          expect(subject).to match /(60[0123]|59[6789])\.\d* i\/min/
          expect(subject).to match /0\.1\d* s/
          expect(subject).to match /[012]\.\d*%/
        end
      end

      describe '#warmup_report' do
        subject(:warm_up_report) { job.warm_up_report}

        it_behaves_like "static run time report"
      end

      describe '#runtime_report' do
        subject(:runtime_report) { job.runtime_report}

        it_behaves_like "static run time report"
      end

    end
  end
end