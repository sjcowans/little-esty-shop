class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  enum status: { in_progress: 0, completed: 1, cancelled: 2 }
  
  def custom_date
    self.created_at.strftime("%A, %B %d, %Y")
  end
end
