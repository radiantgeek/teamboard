require 'utils'

module Searches

  # base class for metrics
  class CalcMetric
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def metric=(cache)
      @metric = cache;
    end

    def metric
      return @metric unless (@metric == nil)
      @metric = Metric.find_by_name(name);
    end


    def calc
      Bug.where(where).count
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
      [bug._link, bug.assigned_to,
       bug._priority, bug.milestone, bug.summary,
       bug._historyLink, bug.status+" <i>"+bug.resolution+"</i>"]
    end

    def where
      @where
    end
  end

end