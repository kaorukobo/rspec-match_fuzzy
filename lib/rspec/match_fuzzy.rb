require 'rspec'

module RSpec
  module MatchFuzzy
    DIFF_LABEL =
      if defined? RSpec::Matchers::ExpectedsForMultipleDiffs
        RSpec::Matchers::ExpectedsForMultipleDiffs::DEFAULT_DIFF_LABEL
      else
        # as of rspec-expectations v3.13.0
        RSpec::Matchers::MultiMatcherDiff::DEFAULT_DIFF_LABEL
      end
  end
end

RSpec::Matchers.define :match_fuzzy do |expected|
  expected = expected.to_s

  match do |actual|
    actual = actual.to_s
    actual.strip.gsub(/[[:blank:]]+/, '').gsub(/\n+/, "\n") == expected.strip.gsub(/[[:blank:]]+/, '').gsub(/\n+/, "\n")
  end

  failure_message do |actual|
    actual = actual.to_s
    actual_normalized = actual.strip.gsub(/^\s+/, '').gsub(/[[:blank:]]+/, "\s").gsub(/\n+/, "\n").gsub(/\s+$/, '')
    expected_normalized = expected.strip.gsub(/^\s+/, '').gsub(/[[:blank:]]+/, "\s").gsub(/\n+/, "\n").gsub(/\s+$/, '')

    message = <<-EOS.strip
expected: #{expected_normalized.inspect}
     got: #{actual_normalized.inspect}
    EOS

    diff = RSpec::Expectations.differ.diff(actual_normalized, expected_normalized)

    unless diff.strip.empty?
      message << "\n\n" << RSpec::MatchFuzzy::DIFF_LABEL << diff
    end

    message
  end
end
