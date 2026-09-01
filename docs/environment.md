# 環境構築

このリポジトリは、現時点ではドキュメントと構成の土台のみです。ファームウェア、回路 CAD、PC ツールの実体を追加する前提で、以下を標準環境として準備します。

## 推奨 OS

- Windows 11
- Git for Windows
- VS Code

## 共通ツール

- Git
- Python 3.11 以降
- CMake
- Ninja
- Doxygen または MkDocs は、API ドキュメントが必要になった段階で導入する

## 回路・基板

- KiCad 8 以降
- 3D モデル、製造データ、BOM は `hardware/` 配下に置く
- KiCad の自動バックアップ、プロジェクトローカルキャッシュ、生成済み製造データは `.gitignore` の対象

## nRF52840 ファームウェア候補

第一候補は nRF Connect SDK / Zephyr です。

必要ツール:

- nRF Connect for Desktop
- nRF Connect SDK
- nRF Command Line Tools
- SEGGER J-Link
- VS Code nRF Connect 拡張

想定構成:

```text
firmware/
├── sensor_node/       発電・蓄電駆動の BLE 温湿度ノード
└── receiver_dongle/   BLE Advertising 受信と USB CDC 出力
```

ファームウェア追加後の確認例:

```powershell
west build -b <board_name> firmware/sensor_node
west flash
```

実際のボード名、SDK バージョン、ビルドコマンドはプロジェクト作成時にこのファイルへ追記します。

## PC 受信・解析ツール候補

- Python + pyserial: USB CDC のログ取得
- Python + pandas: CSV 整形、測定結果集計
- 必要に応じて matplotlib: 評価グラフ生成

想定出力:

```text
2026-09-01T12:34:56Z,ID=0001,SEQ=15,TEMP=24.38,RH=58.2,VCAP=4.11,RSSI=-72
```

## 初期セットアップ確認

```powershell
git status
python --version
cmake --version
ninja --version
```

KiCad と nRF 系ツールは GUI / インストーラ由来のため、導入後にバージョンとインストール場所をこのファイルへ記録してください。
