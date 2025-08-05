# 💵 Fake Currency Detection using MATLAB Image Processing

This project aims to distinguish between **real** and **scanned (fake)** banknotes by analyzing various visual and statistical features using **MATLAB**. The workflow includes HSV analysis, segmentation, morphological processing, line detection, projection analysis, and black strip comparison.

---

## 📌 Project Overview

- Compares a **real** and a **scanned** currency image
- Uses:
  - HSV color space analysis
  - Morphological segmentation and filtering
  - Vertical projection and line count analysis
  - Black strip (security feature) isolation and comparison
- Outputs the number of segmented features or "black lines" to help detect forgery

---

## 🧪 Techniques Used

| Step | Methodology |
|------|-------------|
| 1️⃣   | **HSV Analysis** to evaluate color channel differences |
| 2️⃣   | **Segmentation** using thresholding on Saturation & Value channels |
| 3️⃣   | **Morphological Closing** to clean binary masks |
| 4️⃣   | **Area Opening** to remove noise |
| 5️⃣   | **bwlabel** to count dark lines or printed patterns |
| 6️⃣   | **Grayscale Difference & Projection** to detect hidden lines |
| 7️⃣   | **Black Strip Extraction** from edge columns for security mark validation |

---

## 🖼️ Sample Output

✅ Console output includes:
- Number of dark lines in real note
- Number of dark lines in scanned note
- Size comparison
- Strip visualization

📊 Graphs:
- Projection profile of differences
- Smoothed vs. thresholded vertical projection
- Visual confirmation of black security strip

Output Sample : https://github.com/Aartee05/fakecurrency/blob/main/fakecurrency%20op.docx

---

## 🛠️ Requirements

- MATLAB R2020 or above (recommended)
- Image Processing Toolbox

---

## 🚀 How to Run

1. Clone or download this repository:
    ```bash
    https://github.com/Aartee05/fakecurrency/blob/main/fakecurrecy.m
    ```

2. Open MATLAB and run:
    ```matlab
    fakecurrency.m
    ```

3. Make sure to replace the file paths (`500_image.jpg`, `fake_image.jpg`) with your actual real/fake note images if necessary.

---

## 🧩 Customization

- You can adjust the `satThresh` and `valThresh` in segmentation for better results on different note types.
- Change morphological kernel size `k` for thicker or thinner line emphasis.
- Add more statistical comparisons (entropy, histogram, correlation, etc.) for enhanced accuracy.

---

## 🛑 Limitations

- Assumes consistent image size and orientation
- Designed for fixed image regions (e.g., columns 90–95, 200–end)
- Performance may vary with image quality, lighting, or scaling

---

