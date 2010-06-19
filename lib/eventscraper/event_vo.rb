class EventVo
  def initialize title, description, date, location, link, source, organiser
    @title = title if title
    @description = description if description
    @date = date if date
    @location = location if location
    @organiser = organiser if organiser
    @link = link if link
    @source = source if source
    
    instance_variables.each do |v|
      if instance_variable_get(v).equal? nil
        puts self.to_yaml
        raise "EventVo invalid, #{v} is nil"
      end
    end
  end
  
  attr_reader :title, :description, :date, :location, :organiser, :link, :source
end