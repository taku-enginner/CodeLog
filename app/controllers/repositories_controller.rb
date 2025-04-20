require 'net/http'
require 'uri'
require 'json'

class RepositoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @repositories = current_user.repositories.order(created_at: :desc)
  end

  def show
    @repository = current_user.repositories.find(params[:id])
    @file_tree = fetch_github_tree(@repository.full_name)
  
    @selected_file_path = params[:path]
    file_sha = params[:file_sha]
  
    if file_sha.present?
      begin
        @selected_file_content = fetch_github_blob(@repository.full_name, file_sha)
        Rails.logger.debug "[FILE DEBUG] SHA: #{file_sha}"
        Rails.logger.debug "[FILE DEBUG] Content length: #{@selected_file_content&.length}"
      rescue Octokit::NotFound => e
        Rails.logger.warn "[FILE WARN] ファイルが存在しません: #{file_sha}"
        @selected_file_content = nil
        flash.now[:alert] = "このファイルは GitHub 上から削除された可能性があります。コメントのみ表示されます。"
      end
    end
  
    @annotations = Annotation.where(
      repository: @repository,
      file_path: @selected_file_path
    ).order(created_at: :desc)

    # 閲覧数をインクリメント
    @annotations.each do |annotation|
      annotation.increment!(:view_count)
    end
  end
  

  def new
    @repository = Repository.new
  end

  def create
    @repository = current_user.repositories.build(repository_params)
  
    if fetch_github_tree(@repository.full_name)
      @repository.name = @repository.full_name.split("/").last
      @repository.github_token = ENV["GITHUB_TOKEN"]
  
      if @repository.save
        redirect_to @repository, notice: "リポジトリを登録しました"
      else
        flash.now[:alert] = "リポジトリの保存に失敗しました：" + @repository.errors.full_messages.join(", ")
        render :new, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "GitHub APIの取得に失敗しました。リポジトリ名やトークンを確認してください。"
      render :new, status: :unprocessable_entity
    end
  end
  
  # app/controllers/repositories_controller.rb
  def file_search_suggestions
    repo = current_user.repositories.find(params[:id])
    keyword = params[:q].to_s.downcase

    suggestions = fetch_github_tree(repo.full_name).map { |item| item["path"] }
                    .select { |path| path.downcase.include?(keyword) }
                    .first(10)

    render json: suggestions
  end


  private

  def repository_params
    params.require(:repository).permit(:full_name)
  end

  def fetch_github_tree(full_name)
    repo_uri = URI("https://api.github.com/repos/#{full_name}")
    repo_req = Net::HTTP::Get.new(repo_uri)
    repo_req["Authorization"] = "token #{ENV['GITHUB_TOKEN']}"
    repo_req["Accept"] = "application/vnd.github+json"
  
    repo_res = Net::HTTP.start(repo_uri.hostname, repo_uri.port, use_ssl: true) { |http| http.request(repo_req) }
    return nil unless repo_res.is_a?(Net::HTTPSuccess)
    default_branch = JSON.parse(repo_res.body)["default_branch"]
  
    tree_uri = URI("https://api.github.com/repos/#{full_name}/git/trees/#{default_branch}?recursive=1")
    tree_req = Net::HTTP::Get.new(tree_uri)
    tree_req["Authorization"] = "token #{ENV['GITHUB_TOKEN']}"
    tree_req["Accept"] = "application/vnd.github+json"
  
    tree_res = Net::HTTP.start(tree_uri.hostname, tree_uri.port, use_ssl: true) { |http| http.request(tree_req) }
  
    return JSON.parse(tree_res.body)["tree"] if tree_res.is_a?(Net::HTTPSuccess)
    nil
  rescue => e
    Rails.logger.error "[GitHub Tree Fetch Error] #{e.class}: #{e.message}"
    nil
  end
  
  def fetch_github_blob(full_name, sha)
    uri = URI("https://api.github.com/repos/#{full_name}/git/blobs/#{sha}")
    req = Net::HTTP::Get.new(uri)
    req["Authorization"] = "token #{ENV['GITHUB_TOKEN']}"
    req["Accept"] = "application/vnd.github.v3.raw"
  
    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
  
    if res.is_a?(Net::HTTPSuccess)
      # エンコーディングをUTF-8に変換（強制）
      body = res.body.force_encoding("UTF-8")
  
      # 文字化け回避のため valid? チェックも追加しておくと安全
      body.valid_encoding? ? body : body.scrub
    else
      nil
    end
  rescue => e
    Rails.logger.error "[GitHub Blob Fetch Error] #{e.class}: #{e.message}"
    nil
  end
  
  
end
