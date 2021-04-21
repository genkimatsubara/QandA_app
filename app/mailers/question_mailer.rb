class QuestionMailer < ApplicationMailer
  default from: 'QandA@example.com'
  
  
  def creation_question
    @user = params[:user]
    @question = params[:question]
    mail(subject: '新規質問', to: @user.email, from: 'QandA@example.com')
  end
  
end
