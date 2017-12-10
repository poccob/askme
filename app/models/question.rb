class Question < ApplicationRecord

  belongs_to :user

  validates :text, :user, presence: true

  validates :text, length: { maximum: 255,
                               too_long: "Максимальная длина теста вопроса 255 символов"}

end
