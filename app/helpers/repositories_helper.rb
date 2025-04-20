module RepositoriesHelper
  # GitHub APIで取得したフラットなファイルツリーを、ネストしたツリー構造に変換
  def build_nested_tree(file_tree)
    tree = {}

    file_tree.each do |item|
      path_parts = item["path"].split("/")
      current = tree

      path_parts.each_with_index do |part, index|
        if index == path_parts.length - 1
          # 最後の要素（ファイル or フォルダ）
          current[part] = {
            type: item["type"],
            sha: item["sha"],
            path: item["path"]
          }
        else
          # 中間のフォルダ構築（type: "tree", children: {} を保証）
          current[part] ||= { type: "tree", children: {} }
          current[part][:children] ||= {} # 念のため
          current = current[part][:children]
        end
      end
    end

    tree
  end

  # 再帰的にツリー表示を描画（Stimulus対応）
  def render_tree(tree, repository, parent_path = "")
    content_tag :ul, class: "pl-4 border-l text-sm space-y-1" do
      # フォルダ → ファイル順に並び替え（任意）
      folders = tree.select { |_, v| v[:type] == "tree" }.sort_by(&:first)
      files   = tree.select { |_, v| v[:type] == "blob" }.sort_by(&:first)
      sorted_tree = folders + files

      sorted_tree.map do |name, value|
        full_path = [parent_path, name].reject(&:blank?).join("/")

        case value[:type]
        when "blob"
          # ファイルリンク
          link = link_to name,
                         repository_path(repository, file_sha: value[:sha], path: value[:path]),
                         class: "text-blue-600 hover:underline"
          content_tag(:li, "📄 #{link}".html_safe)

        when "tree"
          # フォルダ（トグル可能）
          content_tag(:li, data: { controller: "toggle" }) do
            button = content_tag(:button, "📁 #{name}",
              class: "font-semibold text-gray-700 hover:underline",
              data: { action: "click->toggle#toggle" })
          
            nested = content_tag(:div, class: "pl-4 mt-1 hidden", data: { toggle_target: "content" }) do
              render_tree(value[:children], repository, full_path)
            end
          
            button + nested
          end
          
        end
      end.join.html_safe
    end
  end
end
