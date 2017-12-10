class UsersController < ApplicationController
  def index
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
  end
end
