require 'openssl'

class User < ApplicationRecord
  # параметры работы модуля шифрования паролей
  ITERATIONS = 20000
  DIGEST = OpenSSL::Digest::SHA256.new

  has_many :questions

  validates :email, :username, presence: true
  validates :email, :username, uniqueness: true

  validates :email, format: { with: /\A[\w_+-.]+@[\w]+(\.[\w]+)*\.[a-z]+\z/i,
                              message: "Не верно введен email" }
  validates :username, format: { with: /\A[a-z\d_]+\z/i,
                                 message: "Не верно введен username, нужно использовать только латинские буквы, цифры и знак _" }
  validates :username, length: { maximum: 40,
                                 too_long: "Максимальная длина username 40 символов"}

  attr_accessor :password


  validates_presence_of :password, on: :create
  validates_confirmation_of :password

  before_validation :downcase_username
  before_save :encrypt_password

  def downcase_username
    self.username = self.username.downcase
  end

  def encrypt_password
    if self.password.present?

      # создаем т.н. "соль" - рандомная строка усложняющая задачу хакерам
      self.password_salt = User.hash_to_string(OpenSSL::Random.random_bytes(16))
      # создаем хэш пароля - длинная уникальная строка, из которой невозможно восстановить
      # исходный пароль
      self.password_hash = User.hash_to_string(
        OpenSSL::PKCS5.pbkdf2_hmac(self.password, self.password_salt, ITERATIONS, DIGEST.length, DIGEST)
      )
    end
  end

  # служебный метод, преобразующий бинарную строку в 16-ричный формат, для удобства хранения
  def self.hash_to_string(password_hash)
    password_hash.unpack('H*')[0]
  end

  def self.authenticate(email, password)
    user = find_by(email: email) # сперва находим кандидата по email

    # сравнивается password_hash оригинальный пароль писать нельзя!!!
    if user.present? && user.password_hash == User.hash_to_string(OpenSSL::PKCS5.pbkdf2_hmac(password, user.password_salt, ITERATIONS, DIGEST.length, DIGEST))
      user
    else
      nil
    end
  end

end
