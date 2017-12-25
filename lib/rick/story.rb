module Rick
  class Story
    attr_reader :data

    def initialize(pivotal, config)
      @pivotal = pivotal
      @data = []
      @config = config
    end

    def retrieve
      project = @pivotal.project(@config["project"]["id"])
      @data = []
      project.stories.each do |s|
        @data << s
      end
      self
    end

    def with_state(state = @config["story"]["state"])
      @data.delete_if do |s|
        true unless s.current_state == state
      end
      self
    end

    def count
      @data.size
    end
  end
end
