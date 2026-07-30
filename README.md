

# 📷 Image Processing & Digital Watermarking Engine


[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Open Source](https://img.shields.io/badge/Open%20Source-%E2%9D%A4-red.svg)](#)

A robust, python-based digital image processing and watermarking tool designed for copyright protection, content authentication, and digital rights management (DRM). This repository provides algorithms to embed and extract invisible or visible watermarks into digital imagery while maintaining perceptual quality and resilience against common image processing attacks.

---

## 📌 Why Digital Watermarking?

In the modern digital ecosystem, high-value images, medical scans, and media assets are effortlessly duplicated, tampered with, or redistributed without authorization. 

Standard metadata (such as EXIF) can be easily stripped or overwritten. **Digital Watermarking** solves this by embedding ownership indicators or authentication payloads directly into the image pixel matrix or frequency domain, ensuring that proof of ownership or integrity remains permanently linked to the media.

### Key Applications:
* **Copyright Protection:** Prove ownership of proprietary digital artwork, photography, and assets.
* **Medical Image Security:** Safeguard Patient Data (PHI) and diagnostic integrity within DICOM/medical images.
* **Content Authentication:** Detect tampering or unauthorized alterations in sensitive media.
* **Document Verification:** Embed verification metadata inside scanned certificates and official records.

---

## ✨ Key Features & Advantages

* 🎯 **High Imperceptibility:** Preserves high Peak Signal-to-Noise Ratio (PSNR), ensuring the watermarked image remains visually identical to the original.
* 🛡️ **Robust Integrity:** Designed to resist perceptual distortions, compression, scaling, and spatial manipulations.
* ⚡ **Performance Optimized:** Efficient matrix manipulation and image transformation pipelines suitable for real-time or batch processing.
* 🔍 **Flexible Extraction:** Reliable payload extraction and detection algorithms for authentication workflows.
* 🛠️ **Extensible Architecture:** Modular Python design allowing easy integration of new algorithms (e.g., Spatial Domain LSB, Frequency Domain DCT/DWT).

---

## 🏗️ Repository Architecture

```text
ImageProcessing_watermarking/
│
├── core/                  # Core algorithms (Embedding, Extraction, Metrics)
├── examples/              # Sample scripts and testing images
├── tests/                 # Unit tests for algorithm validation
├── requirements.txt       # Project dependencies
└── README.md              # Project documentation

```

---

## 🚀 Getting Started

### Prerequisites

Ensure you have **Python 3.8+** installed on your system along with standard image processing libraries.

### 1. Clone the Repository

```bash
git clone [https://github.com/VaZarei/ImageProcessing_watermarking.git](https://github.com/VaZarei/ImageProcessing_watermarking.git)
cd ImageProcessing_watermarking

```

### 2. Set Up Virtual Environment & Dependencies

```bash
# Create virtual environment
python -m venv venv

# Activate environment (Linux/macOS)
source venv/bin/dev/activate

# Activate environment (Windows)
# .\venv\Scripts\activate

# Install required dependencies
pip install -r requirements.txt

```

---

## 💻 Quick Usage Example

Below is a standard workflow for embedding and extracting a watermark payload:

```python
from watermarking import WatermarkEngine

# Initialize engine
engine = WatermarkEngine()

# 1. Embed Watermark
engine.embed(
    cover_image="path/to/original.png",
    watermark="path/to/watermark.png",
    output_path="path/to/watermarked_result.png"
)

# 2. Extract Watermark
engine.extract(
    watermarked_image="path/to/watermarked_result.png",
    output_path="path/to/extracted_watermark.png"
)

```

---

## 📊 Evaluation Metrics

To rigorously assess performance, the framework evaluates watermarked images using standardized metrics:

1. **PSNR (Peak Signal-to-Noise Ratio):** Measures visual fidelity between cover and watermarked images. High values (>40 dB) signify minimal visible distortion.
2. **SSIM (Structural Similarity Index):** Evaluates perceptual quality changes based on structural, contrast, and luminance parameters.
3. **NC (Normalized Correlation):** Measures the accuracy of the extracted watermark payload compared to the original watermark.

---

## 🤝 Contributing

Contributions are welcome! If you want to add new algorithms (e.g., DWT-SVD, DCT-based embedding, attack simulation suites), feel free to open a pull request.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/NewAlgorithm`)
3. Commit your Changes (`git commit -m 'Add New Watermarking Algorithm'`)
4. Push to the Branch (`git push origin feature/NewAlgorithm`)
5. Open a Pull Request

---

## 📜 License

Distributed under the MIT License. See `LICENSE` for more information.

---

## 👤 Author

**Vahid Zarei**


