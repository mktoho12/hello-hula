# HuLa IM Service - Local Docker Environment

このリポジトリは、HuLa IMサービスのローカル開発環境をDockerで構築するための設定ファイルです。

## 前提条件

- Docker Desktop がインストールされていること
- Docker Compose がインストールされていること

## サービス構成

このdocker-composeは以下のサービスを起動します:

| サービス | ポート | 説明 |
|---------|--------|------|
| MySQL | 3306 | データベース |
| Redis | 6379 | キャッシュ |
| RocketMQ NameServer | 9876 | メッセージキューネームサーバー |
| RocketMQ Broker | 10909, 10911, 10912 | メッセージブローカー |
| Nacos | 8848, 9848 | サービスディスカバリ・設定管理 |
| RocketMQ Console | 8080 | RocketMQの管理コンソール |

## 起動方法

### 1. 環境の起動

```bash
docker-compose up -d
```

### 2. サービスの状態確認

```bash
docker-compose ps
```

### 3. ログの確認

```bash
# 全サービスのログ
docker-compose logs -f

# 特定のサービスのログ
docker-compose logs -f mysql
docker-compose logs -f nacos
```

## アクセス情報

### Nacos管理コンソール
- URL: http://localhost:8848/nacos
- ユーザー名: `nacos`
- パスワード: `nacos`

### RocketMQ管理コンソール
- URL: http://localhost:8080

### MySQL接続情報
- ホスト: `localhost`
- ポート: `3306`
- データベース: `hula_db`
- ユーザー名: `hula_user`
- パスワード: `hula_password`
- Root パスワード: `hula_root_password`

### Redis接続情報
- ホスト: `localhost`
- ポート: `6379`

## 初期化

初回起動時、Nacos用のデータベース設定が必要な場合があります:

```bash
# MySQLに接続
docker-compose exec mysql mysql -u root -phula_root_password

# Nacos用データベースを作成
CREATE DATABASE IF NOT EXISTS nacos_config CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

## HuLa-Serverアプリケーションの起動

インフラサービスが起動したら、HuLa-Serverアプリケーション本体をビルド・起動する必要があります:

1. HuLa-Serverリポジトリをクローン:
```bash
git clone https://github.com/HuLaSpark/HuLa-Server.git
cd HuLa-Server
```

2. 設定ファイルを編集して、各サービスの接続情報を設定
   - MySQL: `localhost:3306`
   - Redis: `localhost:6379`
   - RocketMQ: `localhost:9876`
   - Nacos: `localhost:8848`

3. Mavenでビルド・実行
```bash
mvn clean package
# 各マイクロサービスを起動
```

## 停止方法

```bash
# サービスを停止（データは保持）
docker-compose stop

# サービスを停止してコンテナを削除（データは保持）
docker-compose down

# サービスを停止してコンテナとボリュームを削除（データも削除）
docker-compose down -v
```

## トラブルシューティング

### ポートが既に使用されている場合

`docker-compose.yml`のポート設定を変更してください:

```yaml
ports:
  - "13306:3306"  # ホスト側のポートを変更
```

### メモリ不足エラー

Docker Desktopのリソース設定を確認し、メモリを増やしてください（最低4GB推奨）。

### Nacosが起動しない場合

MySQLが完全に起動する前にNacosが起動しようとする場合があります:

```bash
docker-compose restart nacos
```

## コントリビューション

このプロジェクトへの貢献を歓迎します！貢献方法の詳細については、[CONTRIBUTING.md](CONTRIBUTING.md)をご覧ください。

## 参考リンク

- [HuLa-Server GitHub](https://github.com/HuLaSpark/HuLa-Server)
- [HuLa Desktop GitHub](https://github.com/HuLaSpark/HuLa)
- [Apache RocketMQ](https://rocketmq.apache.org/)
- [Nacos](https://nacos.io/)
