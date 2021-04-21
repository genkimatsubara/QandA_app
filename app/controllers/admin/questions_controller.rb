class Admin::QuestionsController < ApplicationController
  before_action :require_admin
  
  
  
  def index
    @q = Question.ransack(params[:q])
    @questions = @q.result(distinct: true).page(params[:page]).per(10)
  end
  
  def destroy
    @question = Question.find(params[:id])
    @question.destroy!
    redirect_to questions_url, notice: "質問を「#{@question.title}」削除しました。"
  end
  
  private
  def require_admin
    if current_user.nil? || !current_user.admin?
      redirect_to root_path, notice: '管理者ではありません'
    end
  end
end
