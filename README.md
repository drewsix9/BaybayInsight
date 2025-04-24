# 📝 BaybayInsight

BaybayInsight is a deep learning-powered application for recognizing **Baybayin characters** — an ancient Filipino script — using **Convolutional Neural Networks (CNNs)**. This project aims to help preserve and promote Filipino heritage by providing an automated tool that can interpret hand-drawn Baybayin characters with high accuracy.

---

## 📌 Table of Contents
- [About the Project](#about-the-project)
- [Tech Stack](#tech-stack)
- [Dataset](#dataset)
- [Model Architecture](#model-architecture)
- [Results](#results)
- [Installation](#installation)
- [Usage](#usage)
- [Contributors](#contributors)
- [License](#license)

---

## 📖 About the Project

Baybayin (also known as Alibata) is a pre-colonial Philippine writing system. With the rise of modern digital tools, this project aims to automate the recognition of Baybayin characters through a trained CNN model. This system enables users to draw characters, which are then classified and interpreted as digital text.

---

## 🛠️ Tech Stack

- **Frontend**: Flutter
- **Machine Learning**: Python, TensorFlow, Keras, NumPy
- **Training Platform**: Google Colab (with GPU)
- **Dataset**: Kaggle (by James Arnold Nogra)

---

## 📊 Dataset

- Total images: 10,000+
- Number of classes: 63 Baybayin characters
- Preprocessing:
  - Resized and normalized image data
  - Split into training, validation, and testing sets

---

## 🧠 Model Architecture

The CNN model consists of:

- 3 Convolutional Blocks:
  - Conv2D → BatchNormalization → ReLU → MaxPooling2D → Dropout
- GlobalAveragePooling2D
- Fully Connected Dense Layers
- Softmax Output Layer (63 classes)

### Optimizations
- Filter sizes: 3x3, 5x5, 7x7
- Channel sizes: 8–128
- Adam Optimizer + Cross-Entropy Loss
- Dropout Regularization
- Trained for 25 epochs

---

## 📈 Results

- **Training Accuracy**: 98.89%
- **Validation Accuracy**: 98.48%
- Visual metrics include:
  - Epoch Accuracy Graph
  - Confusion Matrix

---

## 💻 Installation

1. Clone the repository:

```bash
git clone https://github.com/drewsix9/BaybayInsight.git
cd BaybayInsight
```

2. Install Flutter dependencies:
```bash
flutter pub get
```

3. Launch the FLutter app:
```bash
flutter run
```

