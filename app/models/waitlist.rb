class Waitlist < ApplicationRecord
  validates :email, 
    presence: { message: "Почта не может быть пустой" },
    uniqueness: { message: "Эта почта уже в списке ожидания" },
    format: { with: /\A[^@\s]+@[^@\s]+\z/, message: "Некорректный формат почты" }
end