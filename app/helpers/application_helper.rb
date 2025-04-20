module ApplicationHelper
  def prism_language_class(file_path)
    return "none" if file_path.blank?
  
    ext = File.extname(file_path).downcase
  
    {
      ".rb" => "ruby",
      ".js" => "javascript",
      ".ts" => "typescript",
      ".json" => "json",
      ".html" => "markup",
      ".erb" => "markup",      # ← ★ 追加！
      ".css" => "css",
      ".scss" => "scss",
      ".md" => "markdown",
      ".yml" => "yaml",
      ".yaml" => "yaml",
      ".sh" => "bash",
      ".py" => "python"
    }[ext] || "none"
  end
  
end