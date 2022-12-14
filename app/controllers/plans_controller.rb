class PlansController < ApplicationController
  before_action :set_plan, only: %i[show edit update destroy]
  before_action :set_teams, only: %i[new create edit update]
  before_action :set_issues, only: %i[new create edit update]

  # GET /plans or /plans.json
  def index
    @issues = Issue.all
    @plans = Plan.all
  end

  # GET /plans/1 or /plans/1.json
  def show
    @team = Team.find(@plan.team.id)
    @issue = Issue.find(@plan.issue.id)
    @comments = @plan.comments
    # @comment = @plan.comments.build
    @plan_pic = User.find(@plan.pic).name
  end

  # GET /plans/new
  def new
    @issue = Issue.find(params[:issue_id])
    @team = @issue.team
    @plan = @issue.plans.build
  end

  # GET /plans/1/edit
  def edit
    # @plan = @issue.plans.build
  end

  # POST /plans or /plans.json
  def create
    @issue = Issue.find(params[:issue_id])
    @plan = issue.plans.build(plan_params)
    @plan.user = current_user
    @plan.team_id = issue.team_id
      if @plan.save
        redirect_to team_issue_plan_path(@team, @issue, plan), notice: 'action planを作成しました'
      else
        flash[:alert] = '保存出来ませんでした。'
        render new
      end
  end

  # PATCH/PUT /plans/1 or /plans/1.json
  def update
    if @plan.update(plan_params)
      redirect_to @plan, notice: 'action planを更新しました'
    else
      flash[:alert] = '更新出来ませんでした。'
      render :edit
    end
  end

  # DELETE /plans/1 or /plans/1.json
  def destroy
    @plan.destroy
    redirect_to plan_path(plan)
  end

  def expired_action?
    now = Date.current
    @target = now.since(2.days)
    @plans = Plan.all
      if @plans.status == ( '未完了' || '進行中') && (@plans.due_date_at - now).to_i < 2
        true
      else
        false
      end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_plan
    @plan = Plan.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def plan_params
    params.require(:plan).permit(:action, :pic, :due_date_at, :status, :feedback, :_destroy)
  end

  def set_teams
    @team = Team.find(params[:team_id])
  end

  def set_issues
    @issue = Issue.find(params[:issue_id])
  end
end
