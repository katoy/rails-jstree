require 'rubygems'

shots = SHOTS
name = 'sample001'
sub_no = 0

wd = Selenium::WebDriver.for :firefox

wd.get "http://localhost:3000/"
shots.action_and_screenshot wd, name, sub_no += 1

wd.find_element(:id, "ajaxTree_open").click
shots.action_and_screenshot wd, name, sub_no += 1

wd.find_element(:link_text, "style.min.css").click
shots.action_and_screenshot wd, name, sub_no += 1

wd.find_element(:link_text, "tree.js.coffee").click
shots.action_and_screenshot wd, name, sub_no += 1

wd.find_element(:link_text, "index.html.erb").click
shots.action_and_screenshot wd, name, sub_no += 1

wd.find_element(:id, "ajaxTree_close").click
shots.action_and_screenshot wd, name, sub_no += 1

wd.find_element(:link_text, "assets").click
shots.action_and_screenshot wd, name, sub_no += 1

wd.find_element(:id, "ajaxTreeCsv_open").click
shots.action_and_screenshot wd, name, sub_no += 1

wd.quit
