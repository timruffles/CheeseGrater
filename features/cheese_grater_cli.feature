Feature: Launch from config
  In order to scrape tasty content
  As a cothinker
  I want to control scraping based on config files and a cli

  Scenario: Launch from config file
    When I run "grater config.yml"
    Then I should see "Loading config.yml"
	And I should see "Found 2 root scrapers, running with CheeseGrater::Runner::Single"
	
  Scenario: Specify runner
    When I run "grater resque.yml -r resque"
	Then I should see "running with CheeseGrater::Runner::Resque"