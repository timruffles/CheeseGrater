Loader loads config(s), 
  - prepares all scrapers by
    - mixing in shared setup with specific setup
  - also there is enough data here to pass each Scraper all dependent scrapers within its fields, fully setup and waiting for additional fields
  
root scrapers are run:
  Request sends fields, passes raw response to Response
  Response pulls out all fields, and all new Scrapers that are contained within the fields
  Vo and Scraper objects are yielded to the Runner, which passes them off to Handlers
  Scraper that are adding content to an existing VO are either:
    - passed up with a relates_to: field, with the original Vo
    - the challenge is that they need setup data - is this filtered down to the Scraper, or handelled by the runner?
    - these should have all data required to run and be related by a Handler in a separate process, for instance
Logging:
  Scrapers log the Scrapers and Vos that they yield
    - Requests log the result of their request
    - Response logs any problems interpreting the response


Questions:
  Dependent Scrapers - should they be fully setup by the loader, and then yielded ready to go by Scrapers?
    - Scraper has to know how to pass this data to another scraper
    + State seems to belong together - once the Scraper knows it's done, it passes up a fully formed Scraper
    OR
  Should the Scrapers yield up partially setup Scrapers, to be fully setup by the loader?
    + keeps the code to 
  
Dependent Scrapers implementation:
  * Scraper is passed a list of dependent scrapers
    - it then runs all fields inside on the result?