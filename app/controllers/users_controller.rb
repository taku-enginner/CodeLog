# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :authenticate_user!

  def mypage
    @user = current_user
  
    @total_likes = @user.annotations.joins(:annotation_likes).count
    @recent_comments = @user.annotations.where("created_at >= ?", 7.days.ago).count
    @top_tags = @user.annotations.joins(:tags)
                             .group("tags.name")
                             .order(Arel.sql("count(*) desc"))
                             .limit(3)
                             .pluck(Arel.sql("tags.name, count(*)"))
  
    @most_liked_comment = @user.annotations
                              .joins(:annotation_likes)
                              .group('annotations.id')
                              .order(Arel.sql('count(*) DESC'))
                              .select('annotations.*, COUNT(annotation_likes.id) as likes_count')
                              .first
    @most_liked_comment_likes = @most_liked_comment&.likes_count || 0
  
    @first_commented_at = @user.annotations.minimum(:created_at)
    @commented_files_count = @user.annotations.select(:file_path).distinct.count
    @average_comment_length = @user.annotations.average(Arel.sql("LENGTH(content)"))&.round(1)
  
    @most_active_day = @user.annotations
                            .group("DATE(created_at)")
                            .order(Arel.sql("count(*) DESC"))
                            .limit(1)
                            .pluck(Arel.sql("DATE(created_at), count(*)"))
                            .first
  
    @daily_comments = @user.annotations
                          .group("DATE(created_at)")
                          .order("DATE(created_at)")
                          .pluck(Arel.sql("DATE(created_at), count(*)"))
  
    @most_used_tag = @user.annotations.joins(:tags)
                                  .group("tags.name")
                                  .order(Arel.sql("count(*) desc"))
                                  .limit(1)
                                  .pluck("tags.name")
                                  .first
  
    @comment_time_distribution = @user.annotations
                                     .group(Arel.sql("EXTRACT(HOUR FROM created_at)"))
                                     .order(Arel.sql("EXTRACT(HOUR FROM created_at)"))
                                     .pluck(Arel.sql("EXTRACT(HOUR FROM created_at), count(*)"))


    @weekly_activity_data = current_user.annotations.where(created_at: 1.week.ago..Time.now)
      .group_by_day(:created_at, format: "%A") # 1週間のデータを曜日ごとに集計
      .count
    @weekly_activity_data = %w[日曜日 月曜日 火曜日 水曜日 木曜日 金曜日 土曜日].map do |day|
      @weekly_activity_data[day] || 0 # 曜日ごとにデータが無ければ0を表示
    end
    # タグ割合（tag_pie_data）
    @tag_pie_data = current_user.annotations.joins(:tags)
    .group("tags.name")
    .order("count_all desc")
    .limit(6)
    .count

  end
  
end
