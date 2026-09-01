# MDBT50Q-U1MV2 開発環境構築

## 1. 採用環境

| 項目           | 固定値                                            |
| -------------- | ------------------------------------------------- |
| ホスト OS      | Windows 11                                        |
| IDE            | Visual Studio Code                                |
| IDE 拡張       | Nordic Semiconductor nRF Connect for VS Code 一式 |
| SDK            | nRF Connect SDK `v3.4.0`                          |
| ツールチェーン | SDK Manager が対応付ける `v3.4.0`                 |
| CLI 管理       | nRF Util 8 系、`device`、`sdk-manager`            |
| 評価・書込み器 | nRF52840 DK                                       |
| ターゲット     | Raytac MDBT50Q-U1MV2 / nRF52840                   |

`main` ブランチや RC 版ではなく固定した安定リリースを使う。SDK 更新は別 Issue で互換性を確認してから行う。

公式資料:

- [nRF Connect for VS Code の初回 SDK / toolchain 導入](https://docs.nordicsemi.com/r/bundle/nrf-connect-vscode/page/get_started/quick_setup.html/installing-sdk-and-toolchain-for-the-first-time)
- [nRF Connect SDK リポジトリ](https://github.com/nrfconnect/sdk-nrf)
- [nRF Util](https://www.nordicsemi.com/Products/Development-tools/nRF-Util)
- [nRF Util device command](https://docs.nordicsemi.com/r/bundle/nrfutil/page/nrfutil-device/guides/programming.html)
- [nRF52840 DK Debug out](https://docs.nordicsemi.com/r/bundle/ug_nrf52840_dk/page/ug/dk/hw_debug_out_segger53.html)
- [SEGGER J-Link Software](https://www.segger.com/downloads/jlink/)
- [Raytac MDBT50Q-U1MV2 仕様書](https://www.raytac.com/download/index.php?index_id=44)

## 2. この PC の構築状況

2026-09-01 時点:

| 項目                                               | 状態                                 |
| -------------------------------------------------- | ------------------------------------ |
| Git 2.54.0                                         | 導入済み                             |
| Python 3.14.3                                      | 導入済み。NCS では同梱 Python を優先 |
| CMake 4.3.4                                        | 導入済み。NCS では同梱版を優先       |
| VS Code                                            | 導入済み                             |
| nRF Connect / DeviceTree / Kconfig / Terminal 拡張 | 導入済み                             |
| nRF Util 8.2.1                                     | 導入済み                             |
| nRF Util `device` / `sdk-manager`                  | 導入済み                             |
| nRF Connect SDK / toolchain v3.4.0                 | SDK Manager で導入                   |
| SEGGER J-Link                                      | 未導入。実機書込み前に導入           |
| nRF52840 DK 接続試験                               | 実機未接続                           |
| KiCad 10.0.6                                       | 導入済み                             |

通常の PowerShell から見える Python、CMake、Ninja、west を混在させず、ビルドは必ず nRF Connect 拡張が開く専用ターミナルで行う。

SDK 同梱環境で `hello_world` と Bluetooth `beacon` を `nrf52840dk/nrf52840` 向けにビルドし、いずれも成功した。SDK 展開時に Windows のシンボリックリンク作成警告が出たため、Matter、Memfault、nanopb などの該当機能を使用する場合は Developer Mode を有効にして SDK を再展開する。本ノードで使用する nRF52840 / BLE のビルド経路には影響がないことを確認済みである。

## 3. 再構築手順

### 3.1 VS Code 拡張

```powershell
code --install-extension nordic-semiconductor.nrf-connect
```

この拡張を入れると nRF DeviceTree、nRF Kconfig、nRF Terminal も導入される。

### 3.2 nRF Util

Nordic の公式配布手順で `nrfutil.exe` をユーザーの実行パスへ置き、以下を実行する。

```powershell
nrfutil install device
nrfutil install sdk-manager
nrfutil list
```

### 3.3 SDK とツールチェーン

CLI では次を実行する。

```powershell
nrfutil sdk-manager search
nrfutil sdk-manager install v3.4.0
nrfutil sdk-manager list
```

GUI では VS Code の nRF Connect ビューから `Install SDK` を選び、`v3.4.0` の SDK と toolchain を同時に入れる。どちらの方法でも同じ管理領域を使用する。

### 3.4 書込み器

初期開発は nRF52840 DK を使用する。カスタム基板は 3.3 V を別電源から供給し、DK 側と電圧を合わせる。

`nrfutil device list` が J-Link DLL の未検出を報告する場合は、SEGGER の公式配布ページから J-Link Software を導入してから新しいターミナルを開く。実機を接続し、警告が消えて DK が列挙されることを確認する。

| DK              | ターゲット基板 |
| --------------- | -------------- |
| P19 / P20 VTref | 3V3            |
| SWDIO           | SWDIO          |
| SWDCLK          | SWDCLK         |
| GND             | GND            |
| RESET           | RESET、必要時  |

DK からターゲットへ同時給電しない。スーパーキャパシタ電源評価時は、書込み器や UART からの逆給電がないことを電流計で確認する。

## 4. 開発手順

### 4.1 DK 上のスモークテスト

nRF Connect 専用ターミナルで SDK のサンプルをビルドする。

```powershell
west build -b nrf52840dk/nrf52840 samples/hello_world --pristine
west flash
```

次に Bluetooth の beacon または broadcaster サンプルをビルドし、1M PHY の Advertising をスマートフォンまたはスニファで確認する。

### 4.2 プロジェクトビルド

初期段階では DK ターゲット、基板完成後はカスタム board 定義を使用する。

```powershell
west build -b nrf52840dk/nrf52840 firmware/sensor_node --pristine
west flash
```

カスタム board 名は `pantarhei_oem02/nrf52840` とし、board 定義追加後は次へ切り替える。

```powershell
west build -b pantarhei_oem02/nrf52840 firmware/sensor_node --pristine
west flash
```

### 4.3 CLI 書込み確認

```powershell
nrfutil device list
nrfutil device program --firmware build/zephyr/zephyr.hex --serial-number <DK_SERIAL>
```

`west flash` を通常経路とし、`nrfutil device` は量産前の再現可能な CLI 書込みとデバイス列挙確認に使う。

## 5. カスタム board 定義

以下をファーム実装時に追加する。

```text
firmware/
├── boards/raytac/pantarhei_oem02/
│   ├── board.yml
│   ├── pantarhei_oem02_nrf52840.dts
│   ├── pantarhei_oem02_nrf52840_defconfig
│   └── Kconfig.pantarhei_oem02
└── sensor_node/
    ├── CMakeLists.txt
    ├── prj.conf
    └── src/
```

Devicetree へ I2C/SHTC3、SAADC 入力、UART、状態 GPIO、外部 32.768 kHz の実装有無を定義する。GPIO 番号は回路図確定後に一元化し、C ソースへ直接埋め込まない。

## 6. 完了確認

```powershell
nrfutil --version
nrfutil sdk-manager list
nrfutil device list
west --version
cmake --version
ninja --version
```

完了条件:

- SDK と toolchain がともに `v3.4.0` と表示される。
- DK 向け `hello_world` と BLE Advertising サンプルがビルドできる。
- DK のオンボード nRF52840 と外部 MDBT50Q-U1MV2 の両方へ書き込める。
- nRF Connect for VS Code で Devicetree、Kconfig、ビルド、デバッグが開ける。

## 7. 注意事項

- Raytac モジュールは出荷時試験コード入りのため、初回書込みでプロジェクトファームへ置換する。
- 3.3 V 動作では Raytac 仕様書の 3.6 V 未満向け電源回路を使う。
- Coded PHY の確認には extended advertising 対応スキャナを使う。PC 内蔵 Bluetooth の対応は前提にしない。
- 外部アンテナは認証条件を維持するため、アーキテクチャ文書で選定した型式を使用する。
