# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  # validations
  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: -> { password.present? }
  validates :password_confirmation, presence: true, on: :create

  # relationships
  has_many :resumes

  def default_resume
    resumes.last
  end

  def self.login(user_data)
    account = user_data[:account]
    password = user_data[:password]

    return unless account && password

    user = find_by('email = ? OR username = ?', account, account)
    user&.authenticate(password)
  end
end
