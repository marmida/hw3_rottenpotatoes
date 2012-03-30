# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.new({
      :title => movie['title'],
      :rating => movie['rating'],
      :release_date => movie['release_date'],
    }).save
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  # make sure both elements occur, so we get sensible assertion messages if they don't
  step 'Then I should see "%s"' % e1
  step 'Then I should see "%s"' % e2
  
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  assert Regexp.new('%s.*%s' % [e1, e2], Regexp::MULTILINE).match(page.body), "Did not find %s before %s in content: %s" % [e1, e2, page.body]
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb

  rating_list.scan(/[\w-]+/).each do |rating|
    step "I %scheck \"ratings[%s]\"" % [uncheck, rating]
  end
end

Then /^Then I should see "([^"]*)"$/ do |search|
  assert page.body.include?(search), "Did not find %s in content: %s" % [search, page.body]
end

Then /I should see all of the movies/ do 
  # there's one extra TR for the header row
  assert_equal Movie.count + 1, page.all('#movies tr').length
end