#coding: utf-8

require 'workers'
require 'workers_utils'

class SprintController < ApplicationController
  respond_to :html, :xml, :json

  # GET /sprint
  # GET /sprint.json
  def sprint
    _init

    @sprint = Sprint.find_by_name(params[:sprint]) if params[:sprint]
    if @sprint
	@build = @sprint.build
	@build = @sprint.previous.build if @sprint.active
    else
	@sprint = Sprint.actived.first 
	@build = @sprint.previous.build 
    end
    @release = @sprint.release

    # 1. !!! График по времени  burndown (сколько багов осталось)
    # 3. отправлять дефекты скопом на тестирование
    # 4. Графики по времени сотрудникам – сколько пофиксили?
    kanban()


    render :template => 'sprint/sprint', :layout => 'mini'
  end

  # GET /release
  # GET /release.json
  def release
    _init

    @release = Release.find_by_name(params[:release]) if params[:release]
    @release = Release.actived.first unless @release

    render :template => 'sprint/release', :layout => 'release'
  end

  private
  include Workers
  include WorkersUtils

  def _init
    ActiveRecord::Base.logger = Logger.new(STDERR)
    @worker = Workers.new # should be singleton
  end

  def bugs(wh)
    Bug.conditional(wh).all
  end

  def kanban()
    # оценка (часов)
    # цвет для критичности
    # цвета разным компонентам?

    if @sprint.active
   	@reopen = all(reopen()+fromJava()) + all(reopen+getJava())
	@needinfo = all(needinfodevtest()+fromJava()) + all(needinfodevtest()+getJava())
    else
	@reopen = []
	@needinfo = []
    end

    @planned = onlySprint(accepted())
    @progress = onlySprint(progress())
    @review = onlySprint(review())
    @resolved = onlySprint(workDone())
    @testing = onlySprint(testing())
    @verified = onlySprint(verified())
    @closed = onlySprint(closed())
  end

  def all(cond)
    bugs(cond)
  end

  def onlySprint(cond)
    r = milestone(@release.version)
    bugs(r+getJava()+releasedAt(@sprint.title)+cond) + bugs(r+getJava()+releasedAt(@build)+cond)
  end
end
