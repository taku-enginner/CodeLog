## ✅ CodeLog アプリ MVP 設計

# Gemfile 主要追加予定
- devise
- tailwindcss-rails
- view_component (optional)

# Models

## User
- email
- password

## Repository
- name: string
- url: string
- user_id: references

## FileEntry
- path: string
- repository_id: references

## Annotation
- user_id: references
- file_entry_id: references
- line_number: integer
- body: text
- public: boolean (default: true)
- created_at, updated_at

# 機能一覧

## MVP範囲
- [ ] GitHubのリポジトリURL入力で登録（MVPではリポジトリ構造はローカル仮データ）
- [ ] リポジトリ一覧表示（ログインユーザーのもの）
- [ ] リポジトリ内ファイル一覧
- [ ] ファイル詳細：コード表示 + 行番号付き + コメント追加UI
- [ ] コメント保存（Annotation）
- [ ] 公開／非公開切り替え（コメント単位）
- [ ] 公開URLでの表示（ゲスト閲覧）
- [ ] マイページでの履歴表示（タグ／日付ソート）

## 優先実装技術
- Tailwind CSS でミニマルUI
- Turbo + Stimulus（任意）でコメント即反映
- Markdownプレビュー対応（optional）

## ストレッチゴール（後日）
- GitHub API連携で構造自動取得
- コメントへの画像添付・図解
- OGP画像出力（HTML to PNG）
- 公開プロフィールページ＋いいね機能
- AIサジェスト（Gemや技術用語解説）
