Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create(:title => movie[:title], :director => movie[:director], :release_date => movie[:release_date], :rating => movie[:rating])
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  page.body.should =~ /^(.*#{e1}.*#{e2}.*)$/m
end

Then /^the director of "(.*?)" should be "(.*?)"$/ do |arg1, arg2|
  puts(arg1)
  puts(arg2)
  Movie.find_by_title(arg1).director.should == arg2
end   

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  ratings = rating_list.split(", ")
  ratings.each do |rating|
    uncheck == "un" ? uncheck("ratings_#{rating}") : check("ratings_#{rating}")
  end
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  rows = all("table#movies tr").count
  rows.should == 11
end