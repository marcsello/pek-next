class EvaluationsController < ApplicationController
  before_action :require_login
  before_action :require_leader
  before_action :validate_correct_group, only: [:show, :edit, :update, :table]

  def current
    evaluation = Evaluation.find_by({ group_id: current_group.id, semester: SystemAttribute.semester.to_s })
    unless evaluation
      evaluation = Evaluation.create({
        group_id: current_group.id,
        creator_user_id: current_user.id,
        semester: SystemAttribute.semester.to_s
        })
    end
    redirect_to group_evaluation_path(evaluation.group, evaluation)
  end

  def show
    @evaluation = Evaluation.find(params[:id])
  end

  def edit
    @evaluation = Evaluation.find_by({ group_id: current_group.id, semester: SystemAttribute.semester.to_s })
  end

  def update
    evaluation = Evaluation.find(params[:id])
    evaluation.update(params.require(:evaluation).permit(:explanation))
    redirect_to group_evaluation_path(evaluation.group, evaluation), notice: t(:edit_successful)
  end

  def table
    @evaluation = Evaluation.find(params[:evaluation_id])
    @evaluation.started_creation!
    @point_details = PointDetail.includes(:point_request).select { |pd| pd.point_request.evaluation == @evaluation }
  end

  private

  def validate_correct_group
    evaluation = Evaluation.find(params[:evaluation_id] || params[:id])
    unauthorized_page unless evaluation.group == current_group
  end

end
