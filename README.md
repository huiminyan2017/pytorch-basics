# PyTorch D2L - Dive into Deep Learning

This repo contains my implementations and notes following the **[Dive into Deep Learning](https://d2l.ai/)** book using **PyTorch**. The Goal is to solidify my core concepts before moving to larger NLP/LLM projects.

## Contents

The notebooks cover:
- **Preliminaries** - Linear algebra, calculus, probability
- **Linear Regression & Classification** - Fundamentals of supervised learning
- **Multilayer Perceptrons (MLPs)** - Deep neural networks basics
- **Builder's Guide** - PyTorch model construction patterns
- **Recurrent Neural Networks (RNNs)** - Sequence modeling
- **Modern RNNs** - LSTMs, GRUs, and advanced architectures
- **Attention Mechanisms & Transformers** - Self-attention and transformer models
- **Optimization Algorithms** - SGD, Adam, learning rate scheduling
- **Computational Performance** - GPUs, parallelism, efficiency
- **NLP Pre-training & Applications** - BERT, fine-tuning
- **Reinforcement Learning** - MDPs, Value Iteration, Q-Learning

## Project Structure

```
├── setup_env.sh           # Automated environment setup script
├── LinuxRequirement.txt   # Python 3.10 pinned dependencies
├── notebooks/             # Jupyter notebooks for each chapter
│   ├── 1_intro.ipynb
│   ├── 2_preliminaries.ipynb
│   ├── 3_linear-regression.ipynb
│   └── ...
└── README.md
```

## Quick Start (GitHub Codespaces)

The easiest way to run this project is using GitHub Codespaces:

1. **Create a Codespace** on this repo (click "Code" → "Codespaces" → "Create codespace")
2. **Run the setup script** to install Python 3.10 and all dependencies:
   ```bash
   ./setup_env.sh
   ```
   This will:
   - Install Python 3.10 via deadsnakes PPA
   - Create a virtual environment (`.venv310`)
   - Install PyTorch 2.0, d2l, and all dependencies
   - Register a Jupyter kernel "Python 3.10 (d2l)"
3. **Open a notebook** and select kernel **"Python 3.10 (d2l)"**

## Key Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| torch | 2.0.0 | Deep learning framework |
| torchvision | 0.15.1 | Vision utilities |
| d2l | 1.0.3 | D2L book utilities |
| numpy | 1.23.5 | Numerical computing |
| matplotlib | 3.7.2 | Plotting |
| gym | 0.26.2 | RL environments |
