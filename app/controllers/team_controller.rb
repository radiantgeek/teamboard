require 'bugzilla'

class TeamController < ApplicationController
  respond_to :html, :json


  def comments
    @title = "#"+params["bug"]+" comments"
    comms = Bugzilla::Bugzilla.instance.comments(params["bug"])
    comms[0].collect! { |c| c.when = c.time; c }
    printMini(comms[0], 'comms')
  end

  def changes
    @title = "#"+params["bug"]+" changes"
    printMini(Bugzilla::Bugzilla.instance.history(params["bug"])[0], 'changes')
  end

  def history
    @title = "#"+params["bug"]+" history"
    comms = Bugzilla::Bugzilla.instance.comments(params["bug"])
    comms[0].collect! { |c| c.comment = 1; c.when = c.time; c.who = c.author; c }
    histor = Bugzilla::Bugzilla.instance.history(params["bug"])
    printMini(comms[0]+histor[0], 'history')
  end

  private

  #
  def printMini(table, template)
    @table = table.sort_by { |a| a.when.to_time }.reverse
    render :template => 'team/'+template, :layout => 'mini'
  end


end
