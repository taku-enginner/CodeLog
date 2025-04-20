class TagsController < ApplicationController

  def show
    @tag = Tag.find_by!(name: params[:name])
    @annotations = @tag.annotations.includes(:user)
  end

end
