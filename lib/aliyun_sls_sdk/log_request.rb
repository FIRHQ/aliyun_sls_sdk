module AliyunSlsSdk
  class LogRequest
    attr_accessor :project
    def initialize(projectName)
      @project = projectName
    end
  end
end