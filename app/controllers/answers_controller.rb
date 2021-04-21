class AnswersController < ApplicationController
  before_action :authenticate_user
  # ログインしているのか確認
  
  def create
    @answer = current_user.answers.new(answer_params)
    if @answer.save
      AnswerMailer.with(answer: @answer).creation_answer.deliver_later
      #回答があった場合質問者にメールで通知
      answers = Answer.where(question_id: @answer.question_id)
      user_ids = answers.pluck(:user_id)
      users = User.where(id: user_ids)
      users.each do |user|
        next if user == current_user
        AnswerMailer.with(user: user, answer: @answer).creation_other_answers.deliver_later
      end
      #質問に回答があった場合、当該の質問に回答した他のユーザーにメールで通知
      redirect_to "/questions/#{params[:question_id]}",  notice: "回答しました"
    else
      @question = Question.find(params[:question_id])
      render "questions/show"
    end
  end
  
  private
    def answer_params
      params.require(:answer).permit(:body).merge(question_id: params[:question_id])
    end
end
