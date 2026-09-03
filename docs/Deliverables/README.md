# 顧客向け成果物

## 提出正本

- [customer-proposal.pdf](customer-proposal.pdf): 株式会社越後鐵工所からパンタレイ様へ提出するA4縦2ページの企画書

## 編集・再生成

- [customer-proposal.html](customer-proposal.html): 企画書の編集正本
- [assets/system-block-diagram.png](assets/system-block-diagram.png): draw.io正本から書き出した掲載画像
- `tools/generate_customer_proposal.ps1`: HTMLからPDFを再生成するスクリプト

PDFの再生成はリポジトリ直下で次を実行する。

```powershell
powershell -ExecutionPolicy Bypass -File tools/generate_customer_proposal.ps1
```

数値や構成を変更した場合は、関連する設計文書とdraw.io正本を先に更新してから企画書へ反映する。
