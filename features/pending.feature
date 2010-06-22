Feature: Output progress
  In order to view the cheese piling up on my plate
  As a cothinker
  I want to see the yielded content as it is found by the scrapers
	
  Scenario: Output progress
    When I run "grater config.yml"
    Then I should see "Loaded config.yml"
	And I should see "Running GroupOne::ScraperOne"
	And I should see "Yielded Event" 2 times
	And I should see "Running GroupOne::ScraperTwo"
	And I should see "Yielded Event" 1 times
	
Feature: Inform me of errors
  In order to avoid stale or gone-off cheese/data
  As a cothinker
  I want to be told of any errors or warning smells in the grating process

  Scenario Outline: Http errors
    When I run "grater <file>"
	Then I should see "<errorcode>" 1 times
	
  Scenarios: Http errors
	 | file             | errorcode |
	 | unavailable.yml  | 404       |
	 | server_error.yml | 500       |
	 | invalid.yml      |           |
	 | runtime.yml      |           |
	
  Scenario: Nothing found
    Given I run "grater nothingfound.yml"
	Then I should see "Warning: nothing found by Broken scraper"
	
  Scenario: Low yield
    Given I run "grater less-than-normal.yml -l Log4r scraper.log"
	And file "scraper.log" contains "LessThanNormal: 14 Events"
	Then I should see "Notice: LessThanNormal finds 14 Events on average, found 1"