ActiveAdmin.register Post do
  scope :all, :default => true

  scope :drafts do |posts|
    posts.where(["published_at IS NULL"])
  end

  scope :scheduled do |posts|
    posts.where(["posts.published_at IS NOT NULL AND posts.published_at > ?", Time.now.utc])
  end

  scope :published do |posts|
    posts.where(["posts.published_at IS NOT NULL AND posts.published_at < ?", Time.now.utc])
  end

  scope :my_posts do |posts|
    posts.where(:author_id => current_admin_user.id)
  end
  
end
