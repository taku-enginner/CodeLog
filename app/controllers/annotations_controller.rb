class AnnotationsController < ApplicationController
  before_action :authenticate_user!

  def create
    @annotation = current_user.annotations.build(annotation_params)
    if @annotation.save
      redirect_back fallback_location: root_path, notice: "コメントを追加しました。"
    else
      redirect_back fallback_location: root_path, alert: "保存に失敗しました。"
    end
  end
  
  def destroy
    @annotation = current_user.annotations.find(params[:id])
    @annotation.destroy
    redirect_back fallback_location: root_path, notice: "コメントを削除しました。"
  end
  
  private

  def annotation_params
    params.require(:annotation).permit(:repository_id, :file_path, :content)
  end  
end
