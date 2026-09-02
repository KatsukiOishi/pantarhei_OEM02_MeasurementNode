# pantarhei_OEM02_MeasurementNode

小型風力発電を電源とし、温度・湿度・蓄電電圧を BLE で PC へ送信する自己給電型 IoT ノードの設計リポジトリです。

初号機は量産完成品ではなく、電源回路、BLE 通信、温湿度測定、将来の外部 MCU 拡張を評価する共通評価基板として扱います。

## 現在の前提

- 発電源: 小型 DC 風力発電機
- 電源方式: エナジーハーベスト IC で回収し、スーパーキャパシタへ蓄電
- 電源 IC 候補: Texas Instruments BQ25570（低電圧回収案として条件付き採用）
- 蓄電素子: Eaton PHV-5R4V474-R、5.4V、0.47F
- BLE モジュール: Raytac MDBT50Q-U1MV2、nRF52840 搭載
- 外部アンテナ: Yageo ANTX100ETHAB24553
- 温湿度センサ: Sensirion SHTC3
- ファームウェア: nRF Connect SDK v3.4.0 / Zephyr
- 通信方式: BLE Advertising を基本とし、距離評価では Coded PHY も検討
- 担当範囲: 回路・基板設計、センサノード側ファームウェア
- 顧客範囲: PC 側ソフトウェア、ログ取得・解析ツール

## 重要な未確定事項

- 発電機の最大開放電圧、最大過渡電圧、I-V 特性
- 設置環境の風速分布、発電時間率、要求無風継続時間
- 要求風速範囲での BQ25570 案と高耐圧 Buck 案の回収エネルギー比較
- `U（原データ）` の定義と単位
- 暫定 40V / 0.5W を保護回路の設計上限として採用してよいか
- 外部アンテナ型式と認証条件
- PC 側ソフトウェアとのインターフェース仕様
- 「形式納品」の成果物と検収条件
- 設置環境、防水、結露、動作温度、通信距離の正式条件

## ディレクトリ構成

```text
.
├── docs/                 設計・環境・運用ドキュメント
├── firmware/             センサノード側ファームウェア
├── hardware/             回路図・基板・部品表・製造データ
└── test/                 評価手順、測定ログ、受入確認
```

## はじめに読むもの

1. [環境構築](docs/environment.md)
2. [システムアーキテクチャ](docs/Architecture/ARCHITECTURE.md)
3. [BQ25570 採用妥当性評価](docs/Architecture/BQ25570_ASSESSMENT.md)
4. [計測・通信レイヤ 電力収支評価](docs/Architecture/POWER_BUDGET_ASSESSMENT.md)
5. [BLE 開発環境構築](docs/Setup/NCS_SETUP.md)
6. [ファームウェア実装方針](docs/Firmware/FIRMWARE_PLAN.md)
7. [設計引継ぎ要約](docs/design-handoff-summary.md)
8. [作業ロードマップ](docs/roadmap.md)
9. [ドキュメント索引](docs/README.md)

## 開発メモ

- 添付・外部の設計資料は、ユーザーの明示依頼とは分けて参考資料として扱います。
- ファームウェアは nRF Connect SDK v3.4.0 / Zephyr を採用します。
- PC 側ソフトウェアは顧客範囲です。このリポジトリでは、BLE Advertising ペイロードや UART/受信データ形式などの受け渡し仕様までを整理します。
- 回路確定前に、発電機の開放電圧・過渡電圧・I-V 特性を追加測定してください。
- BQ25570 の入力許容値を超える可能性があるため、発電機を直接接続しません。追加 I-V 測定後に、BQ25570 + 過電圧制限案と高耐圧 Buck 案を比較します。
