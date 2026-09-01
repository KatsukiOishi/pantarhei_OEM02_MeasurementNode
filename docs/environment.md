# 環境構築

このリポジトリは、現時点ではドキュメントと構成の土台のみです。こちらで担当する回路・基板 CAD とセンサノード側ファームウェアを追加する前提で、以下を標準環境として準備します。PC 側ソフトウェア、ログ取得、解析ツールは顧客範囲です。

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
└── sensor_node/       発電・蓄電駆動の BLE 温湿度ノード
```

ファームウェア追加後の確認例:

```powershell
west build -b <board_name> firmware/sensor_node
west flash
```

実際のボード名、SDK バージョン、ビルドコマンドはプロジェクト作成時にこのファイルへ追記します。

## PC 側との受け渡し

PC 側ソフトウェアは顧客範囲です。このリポジトリでは、顧客側で受信・解析しやすいように、BLE Advertising ペイロード、機器 ID、通番、温湿度、蓄電電圧、エラーフラグなどのデータ定義を管理します。

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
