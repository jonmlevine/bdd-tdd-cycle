Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create(:title => movie[:title], :director => movie[:director], :release_date => movie[:release_date], :rating => movie[:rating])
  end
end

Then /^the director of "(.*?)" should be "(.*?)"$/ do |arg1, arg2|
  puts(arg1)
  puts(arg2)
  Movie.find_by_title(arg1).director.should == arg2
end   