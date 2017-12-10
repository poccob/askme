class UsersController < ApplicationController
  def index
    @users = [
      User.new(
        id: 1,
        name: 'Vadim',
        username: 'installero',
        avatar_url: 'https://secure.gravatar.com/avatar/71269686e0f757ddb4f73614f43ae445?s=100'
      ),
      User.new(id: 2, name: 'Misha', username: 'aristofun')
    ]
  end

  def new
  end

  def adit
  end

  def show
    @user = User.new(
        name: 'Vadim',
        username: '@installero',
        avatar_url: 'http://www.npl.co.uk/upload/img/question_mark_lean.jpg'
    )

    @questions = [
        Question.new(text: 'Как дела?', created_at: Date.parse('10.12.2017')),
        Question.new(text: 'В чем смысл жизни?', created_at: Date.parse('10.12.2017')),
    ]

    @new_question = Question.new
  end
end
