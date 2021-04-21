class AnswerMailer < ApplicationMailer
  default from: 'QandA@example.com'
  
  def creation_answer
    @answer = params[:answer]
    mail(subject: '回答', to: @answer.question.user.email, from: 'QandA@example.com')
  end
  
  def creation_other_answers
    @user = params[:user]
    @answer = params[:answer]
    mail(subject: 'その他の回答', to: @user.email, from: 'QandA@example.com')
  end
  
end
