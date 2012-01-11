require 'utils'

module Searches
  # base class for metrics
  class CalcMetric
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def calc
      scope.count
    end

    def scope
      Bug.conditional(where)
    end

    # abstract method: get where condition for search by type id
    def where
    end
  end

  # base class for searches
  class Search < CalcMetric
    include Utils

    def initialize(name, where)
      super(name)
      @where = where
    end

    # column names
    def columns
      ["id", "Assigned to", "Priority", "Milestone", "Summary", "Modified", "Status"]
    end

    # fields for Active Record
    def ar_fields
      [:'bugs.id', :'assigned_tos_bugs.real_name', :priority, :milestone, :summary, :modified, :status]
    end

    # data for
    def view(bug)
      [bug.html_link, bug.assigned_to,
       bug.html_priority, bug.milestone, bug.summary,
       bug.html_historyLink, bug.status+" <i>"+bug.resolution+"</i>"]
    end

    def where
      @where
    end
  end

end