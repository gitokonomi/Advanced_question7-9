class Book < ApplicationRecord
  belongs_to :user
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :view_counts, dependent: :destroy
  # デフォルトのソートをいいね順
  has_many :favorited_users, through: :favorites, source: :user
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
	
  def self.search_for(content, method)
    if method == 'perfect'
      Book.where(title: content)
    elsif method == 'forward'
      Book.where('title LIKE ?', content+'%')
    elsif method == 'backward'
      Book.where('title LIKE ?', '%'+content)
    else
      Book.where('title LIKE ?', '%'+content+'%')
    end
  end

  def self.search_tag_for(content)
    # if method == 'perfect'
      Book.where(tag: content)
    # elsif method == 'forward'
    #   Book.where('title LIKE ?', content+'%')
    # elsif method == 'backward'
    #   Book.where('title LIKE ?', '%'+content)
    # else
    #   Book.where('title LIKE ?', '%'+content+'%')
    # end
  end

end
