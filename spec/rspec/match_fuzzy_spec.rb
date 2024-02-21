describe 'match_fuzzy' do
  let(:expected) do
    <<-EOS
      London Bridge
      Is Broken down,
      Dance over my Lady Lee.
      London Bridge
      Is Broken down
      With a gay Lady.
    EOS
  end

  context 'when match' do
    specify do
      expect(<<-EOS).to match_fuzzy expected
        London  Bridge
        Is  Broken  down,

        Dance over my Lady Lee.


        London\tBridge
        Is\tBroken\tdown
        With a gay Lady.
      EOS
    end
  end

  context 'when not match (extra char)' do
    specify do
      expect(<<-EOS).to_not match_fuzzy expected
        London Bridge
        Is Broken down,
        xDance over my Lady Lee.
        London Bridge
        Is Broken down
        With a gay Lady.
      EOS
    end
  end

  context 'when not match (extra line break)' do
    specify do
      expect(<<-EOS).to_not match_fuzzy expected
        London Bridge
        Is Broken down,
        Dance over my Lady Lee.
        London Bridge
        Is Broken down
        With\na gay Lady.
      EOS
    end
  end

  context 'when ignore tail line brake' do
    specify do
      expect(expected.strip).to match_fuzzy expected
    end
  end

  context "when expectation fails (due to extra char)" do
    it "shows diff" do
      expect {
        expect(<<-EOS).to match_fuzzy expected
          London Bridge
          Is Broken down,
          xDance over my Lady Lee.
          London Bridge
          Is Broken down
          With a gay Lady.
        EOS
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError, /-Dance.*\+xDance/m)
    end
  end
end
