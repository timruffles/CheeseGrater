class EventVo
  def initialize title, description, date, location, link, source, organiser
    @title = title
    @description = description
    @date = date
    @location = location
    @organiser = organiser
    @link = link
    @source = source
    
    instance_variables.each do |v|
      if instance_variable_get(v).equal? nil
        puts self.to_yaml
        raise "EventVo invalid, #{v} is nil"
      end
    end
  end
  
  attr_reader :title, :description, :date, :location, :organiser, :link, :source
end