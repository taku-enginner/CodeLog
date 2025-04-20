class AnnotationLikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_annotation

  def create
    @annotation.annotation_likes.find_or_create_by(user: current_user)
    
    respond_to do |format|
      format.html { redirect_to repository_path(@annotation.repository, file_sha: @annotation.file_sha, path: @annotation.file_path) }
      format.turbo_stream
    end
  end

  def destroy
    like = @annotation.annotation_likes.find_by(user: current_user)
    like&.destroy

    respond_to do |format|
      format.html { redirect_to repository_path(@annotation.repository, file_sha: @annotation.file_sha, path: @annotation.file_path) }
      format.turbo_stream
    end
  end

  private

  def set_annotation
    @annotation = Annotation.find(params[:annotation_id])
  end
end
