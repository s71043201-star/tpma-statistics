# 健康處方開立統計儀表板

一個純前端的單頁網頁應用程式（Single-Page Application），用於彙整、視覺化並匯出「健康處方」的開立與執行統計資料，協助掌握各週期、各處方類型、各行政區與各診所的成效與場次預約狀況。

> 說明：本專案以中文業務情境（情緒調適、營養、社會、運動等「健康處方」）為核心。「TPMA」為儲存庫名稱，文件中以「健康處方統計」為主要描述，避免對縮寫做未經證實的推測。

## 主要功能

整個系統由單一 `index.html` 組成，涵蓋以下功能區塊：

### 統計與圖表
- **每週/每月處方開立數與執行數**：可切換週／月週期，支援直條圖、橫條圖、折線圖、面積圖等多種圖表型態。
- **單月每日趨勢**：以日為單位呈現單月的處方開立數與執行數。
- **累積趨勢**：依週呈現處方開立數與執行數的累積走勢。
- **各處方類型分析**：各類型開立數／執行數佔比（圓餅圖、甜甜圈圖）、開立數 vs 執行數橫條對比，以及各類型執行率（%）。
- **處方類型細項週趨勢**：針對「情緒調適處方、營養處方、社會處方、運動處方」分別呈現週／月趨勢，並支援圖表下鑽（drill-down）檢視。
- **各診所分析**：依處方類型堆疊的選課／執行筆數、各診所開立數 vs 執行筆數、各診所選課／執行比率（%），以及各診所詳細統計表。

### 場次與預約管理
- **單日課表與場次明細**：可點選日期列置頂、點選課程列展開預約明細。
- **場次篩選**：依狀態（全部／即將舉辦／已取消／已完成）、處方類型（情緒調適／營養／社會／運動／其他）、行政區（北投區／士林區／中山區／其他）多重篩選。
- **剩餘可預訂統計**：各處方類型與各課程場次的剩餘可預訂人次、報名率、場次狀態分布。

### 篩選與互動
- **行政區篩選**：北投區、士林區、中山區等台北市行政區。
- **日期區間篩選**：可套用／清除自訂日期區間。
- **圖表互動**：圖表型態切換、下鑽明細、單張圖表下載為 JPG。

### 資料來源與同步
- 透過 **Supabase** 雲端資料庫讀取資料（資料表包含 `prescription_data`、`sync_requests`、`view_counts` 等）。
- 提供「**立即同步**」按鈕，可即時從健康處方管理系統抓取最新資料；平日另有每天 09:30 / 15:00 的自動同步機制。
- 內建頁面瀏覽次數計數（`view_counts`）。

### 匯入與匯出
- **Excel 匯入**：支援上傳 `.xlsx` / `.xls` 檔案（處方資料、各行政區資料、處方日資料）。
- **Excel 匯出**：以 SheetJS 產生試算表檔案。
- **PDF 匯出**：以 jsPDF 產出 PDF 報告，可依「全部／每週趨勢／單月每日／開立分析／週趨勢細項／診所分析／處方日執行數」等範圍與行政區篩選輸出。
- **週報下載**：可下載由後端排程自動產出的最新週報。

## 技術棧

- **前端**：純 HTML / CSS / JavaScript，單一 `index.html` 檔案，無建置工具、無框架。
- **圖表**：[Chart.js 4.4.1](https://www.chartjs.org/) 搭配 [chartjs-plugin-datalabels 2.2.0](https://chartjs-plugin-datalabels.netlify.app/) 資料標籤外掛。
- **雲端資料庫**：[Supabase JS SDK v2](https://supabase.com/)（`@supabase/supabase-js`）。
- **試算表處理**：[SheetJS / xlsx 0.18.5](https://sheetjs.com/)（匯入與匯出 Excel）。
- **PDF 產製**：[jsPDF 2.5.1](https://github.com/parallax/jsPDF)。

所有前端函式庫皆透過 CDN（jsDelivr、cdnjs）載入：

```html
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.1/chart.umd.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.2.0/dist/chartjs-plugin-datalabels.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2/dist/umd/supabase.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/jspdf@2.5.1/dist/jspdf.umd.min.js"></script>
```

## 如何使用

由於整個應用程式僅由單一 `index.html` 構成，使用方式相當簡單：

1. **取得檔案**：複製（clone）或下載本儲存庫。
   ```bash
   git clone https://github.com/s71043201-star/tpma-statistics.git
   ```
2. **開啟頁面**：
   - 直接以瀏覽器開啟 `index.html`；或
   - 以任意靜態伺服器託管後開啟（建議，較不受瀏覽器本機檔案限制影響），例如：
     ```bash
     # 於專案目錄執行其一
     python -m http.server 8000
     npx serve .
     ```
     接著於瀏覽器開啟 `http://localhost:8000`。
3. **載入資料**：頁面會自動連線 Supabase 載入既有資料；亦可使用「立即同步」抓取最新資料，或透過上傳 `.xlsx` / `.xls` 檔案匯入資料。
4. **檢視與操作**：切換週／月週期與圖表型態、套用行政區與日期篩選、點選圖表下鑽明細、檢視場次與預約狀況。
5. **匯出報表**：使用圖表的「下載 JPG」、Excel 匯出、PDF 匯出，或下載最新週報。

> 注意：本頁面需可連線至設定中的 Supabase 服務及上述 CDN 才能完整運作。離線或無法存取雲端資料庫時，部分功能（即時同步、雲端資料載入）將無法使用。

## 專案結構

```
tpma-statistics/
├── index.html   # 完整的單頁應用程式（含 UI、樣式與所有邏輯）
└── README.md
```
