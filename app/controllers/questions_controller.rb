class QuestionsController < ApplicationController
  before_action :authenticate_user, {only:[:new, :create, :edit, :update, :destroy]}
  #ログインしているのかを確かめる
  before_action :ensure_correct_user, {only:[:edit, :update, :destroy]}
  # 質問の編集ができるのは、質問投稿した人のみ
  before_action :set_question, {only:[:show, :edit, :update, :destroy]}
  # 共通部分
  def index
    @q = Question.ransack(params[:q])
    @questions = @q.result(distinct: true).page(params[:page]).per(10)
  end

  def new
    @question = Question.new
  end
  
  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      User.all.each do |user|
        next if user == current_user
        QuestionMailer.with(user: user, question: @question).creation_question.deliver_later
        # 新規質問が投稿されたら全ユーザーにメールを送信する
      end
      redirect_to questions_url, notice: "質問を「#{@question.title}」投稿しました。"
    else
      render :new
    end
  end

  def show
    @answer = Answer.new
  end

  def edit
  end
  
  def update
    @question.update!(question_params)
    redirect_to questions_url, notice: "質問を「#{@question.title}」更新しました。"
  end
  
  def destroy
    @question.destroy!
    redirect_to questions_url, notice: "質問を「#{@question.title}」削除しました。"
  end
  
  def solved
    @q = Question.where(status: 0).ransack(params[:q])
    @questions = @q.result(distinct: true).page(params[:page]).per(10)
    render :action => 'index'
  end
  
  def unsolved
    @q = Question.where(status: 1).ransack(params[:q])
    @questions = @q.result(distinct: true).page(params[:page]).per(10)
    render :action => 'index'
  end
  
  private
  
  def question_params
    params.require(:question).permit(:title, :body, :status)
  end
  
  def ensure_correct_user
    @question = Question.find_by(id: params[:id])
    if @question.user_id != current_user.id
      redirect_to root_url, notice: "権限がありません"
    end
  end
  
  def set_question
    @question = Question.find(params[:id])
  end
end
