# Intent-Aware Event-Centric Multimodal Video Summarization

[![Python 3.10 | 3.11 | 3.12](https://img.shields.io/badge/Python-3.10%20%7C%203.11%20%7C%203.12-blue.svg)](https://www.python.org/)
[![PyTorch 2.x](https://img.shields.io/badge/PyTorch-2.x%20%28CPU%20%2F%20CUDA%29-orange.svg)](https://pytorch.org/)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.110%2B-green.svg)](https://fastapi.tiangolo.com/)
[![License: Apache 2.0](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)

**Complete Technical Project Deliverable & Engineering Handover Package**  
*Phase 1 Local End-to-End Baseline Foundation + Multimodal Extension Models (Models A, C, D, D+Coh, E, F) + Interactive Web Application*

---

## 1. Executive Summary

This deliverable provides the complete, working, and self-contained codebase for the **Intent-Aware Event-Centric Multimodal Video Summarization** system.

### Key Capabilities Included:
1. **Interactive Web Application**: Full drag-and-drop video upload, duration slider (5% to 50%), asynchronous processing with live stage progression, interactive segment timeline with click-to-seek playback, and instant MP4 download with audio preservation.
2. **End-to-End Pipeline**: Scene boundary detection (PySceneDetect), uniform frame sampling, frozen pretrained visual feature extraction (ResNet-50), trained temporal saliency scoring (BiLSTM), budget-constrained segment selection (Greedy & Exact Knapsack), and FFmpeg-based summary compilation.
3. **Model Architectures**: Full implementation of all 6 studied architectures:
   - **Model A**: Unimodal Visual Baseline
   - **Model C**: Early-Fusion Multimodal Baseline (Visual + ASR)
   - **Model D**: Cross-Modal Attention Network (Visual + ASR + OCR)
   - **Model D+Coh**: Cross-Modal Attention + Temporal Coherence Regularizer
   - **Model E**: Full Multimodal Fusion Network with Gating
   - **Model F**: Cross-Modal Intent-Aware Multimodal Transformer
4. **Pretrained Production Checkpoint**: Bundled and verified production checkpoint (`models/checkpoints/bilstm_saliency_best.pt`, 51.2 MB) enabling immediate execution without training.
5. **Zero External Cloud Dependencies**: 100% locally executable on CPU or NVIDIA CUDA GPU.
6. **Automated Verification & Test Suite**: Includes self-verification script (`scripts/verify_product.py`) and full unit/integration test suite.
7. **Empirical Benchmarks & Formal Reports**: Includes canonical benchmark CSVs (TVSum, SumMe, OVP across 124 videos), statistical test ledgers, publication figures, and the complete 32-page formal Master Technical Report (`reports/MASTER_PROJECT_REPORT.pdf`).

---

## 2. System Architecture

```
                  ┌──────────────────────────────────────────────┐
                  │           Input Video (MP4/MOV/AVI)          │
                  └──────────────────────┬───────────────────────┘
                                         │
                                         ▼
                  ┌──────────────────────────────────────────────┐
                  │    Technical Metadata Extraction (OpenCV)    │
                  └──────────────────────┬───────────────────────┘
                                         │
                                         ▼
                  ┌──────────────────────────────────────────────┐
                  │  Scene / Shot Detection (PySceneDetect/KTS)  │
                  └──────────────────────┬───────────────────────┘
                                         │
                                         ▼
                  ┌──────────────────────────────────────────────┐
                  │ Uniform Keyframe Sampling (4 frames/segment) │
                  └──────────────────────┬───────────────────────┘
                                         │
                                         ▼
                  ┌──────────────────────────────────────────────┐
                  │  Visual Feature Extraction (Frozen ResNet-50)│
                  │   2048-dim representations + Tensor Caching  │
                  └──────────────────────┬───────────────────────┘
                                         │
                                         ▼
                  ┌──────────────────────────────────────────────┐
                  │  Importance Scoring (BiLSTM Saliency Head)   │
                  │    Visual Novelty + Temporal + Diversity     │
                  └──────────────────────┬───────────────────────┘
                                         │
                                         ▼
                  ┌──────────────────────────────────────────────┐
                  │  Budget Allocation (Exact Knapsack / Greedy) │
                  │  Respects target duration ratio (e.g. 15%)   │
                  └──────────────────────┬───────────────────────┘
                                         │
                                         ▼
                  ┌──────────────────────────────────────────────┐
                  │  Summary Video Builder (FFmpeg Engine)       │
                  │  Subclip extraction + Stitched Summary MP4   │
                  └──────────────────────┬───────────────────────┘
                                         │
                 ┌───────────────────────┴───────────────────────┐
                 ▼                                               ▼
   ┌───────────────────────────┐                   ┌───────────────────────────┐
   │ Interactive Web Dashboard │                   │ 10 JSON Run Artifacts     │
   │ Video Player + Timeline   │                   │ (Scores, Metrics, Config) │
   └───────────────────────────┘                   └───────────────────────────┘
```

---

## 3. Quick Start (Run on Any System in 3 Steps)

### Step 1: Install Dependencies
Create a virtual environment and install dependencies:

**On Windows (PowerShell / Command Prompt):**
```powershell
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
```
*(Or simply double-click `setup_and_run.bat` for fully automated setup!)*

**On Linux / macOS:**
```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```
*(Or run `chmod +x setup_and_run.sh && ./setup_and_run.sh`)*

### Step 2: Verify Installation (Takes ~10 seconds)
Run the self-verification suite to test hardware, checkpoints, FFmpeg, and run an end-to-end synthetic video summary:
```bash
python scripts/verify_product.py
```
Expected output:
```
[1/6] Testing hardware device detection... [PASS]
[2/6] Testing model checkpoint integrity... [PASS]
[3/6] Testing FFmpeg availability... [PASS]
[4/6] Testing production configuration... [PASS]
[5/6] Testing FastAPI backend import and health endpoint... [PASS]
[6/6] Testing end-to-end pipeline on test video... [PASS]
ALL PRODUCT VERIFICATION CHECKS COMPLETED SUCCESSFULLY.
```

### Step 3: Launch Web Application
```bash
python run.py
```
Open your browser and navigate to:
```
http://127.0.0.1:8000/
```

---

## 4. Web Application Features

The single-page web application provides:
- **Drag-and-Drop Uploader**: Accepts `.mp4`, `.mov`, `.mkv`, and `.avi` videos up to 500 MB.
- **Duration Ratio Slider**: Choose summary lengths from **5%** (ultra-concise highlight) to **50%** (detailed overview). Default is **15%**.
- **Asynchronous Processing**: Background thread processing with live status polling (initializing, segmenting, extracting features, scoring, rendering).
- **Interactive Segment Timeline**: Visual timeline showing the full video duration with highlighted segments that were selected. Click any segment on the timeline to jump to that moment in the video.
- **Side-by-Side Metadata**: Displays duration compression, frame counts, FPS, and timing breakdown.
- **One-Click Download**: Saves the finalized summary MP4 with audio preserved.

---

## 5. Command-Line Interface (CLI) Usage

The system can also be executed completely headlessly via CLI:

### 1. Run Summarization on Any Video:
```bash
python scripts/run_pipeline.py --video tests/fixtures/synthetic_test.mp4 --summary-ratio 0.20
```

### 2. Available CLI Arguments:
- `--video, -v`: Path to input video file (required).
- `--config, -c`: Config file (default: `configs/production.yaml` or `configs/local.yaml`).
- `--summary-ratio, -r`: Summary duration ratio (e.g. `0.15` for 15%).
- `--device, -d`: Device override (`auto`, `cuda`, `cpu`).
- `--output-dir, -o`: Custom directory for run artifacts.
- `--force-recompute`: Bypass cache and recompute all features.

### 3. Extract and Cache Features Standalone:
```bash
python scripts/extract_features.py --video tests/fixtures/synthetic_test.mp4
```

---

## 6. Directory Structure

```
Video_Summarization_Deliverable/
├── app/                            # Web application package
│   ├── backend/                    # FastAPI backend endpoints and background worker
│   │   ├── main.py                 # REST API, health, upload, job polling, video stream
│   │   └── __init__.py
│   ├── frontend/                   # Client-side UI
│   │   └── index.html              # Responsive HTML5 + CSS3 + JS dashboard
│   ├── uploads/                    # Incoming video storage (cleared)
│   └── results/                    # Completed job artifacts and videos
│
├── configs/                        # Pipeline configuration YAMLs
│   ├── production.yaml             # Production config (BiLSTM scorer, Knapsack selector)
│   └── local.yaml                  # Local development config (visual baseline scorer)
│
├── data/                           # Data directory
│   ├── cache/                      # Feature tensor cache (.pt + manifests)
│   └── splits/                     # Canonical 5-fold cross-validation split files
│       ├── tvsum_5fold_splits.json
│       ├── summe_5fold_splits.json
│       └── ovp_5fold_splits.json
│
├── docs/                           # Technical documentation & audits
│   ├── final_verification/         # Acceptance reports, test reports, changelogs
│   └── publication_deliverables/   # Scientific deliverables 1 through 5
│
├── models/                         # Model weights and checkpoints
│   ├── checkpoints/
│   │   └── bilstm_saliency_best.pt # Production trained checkpoint (51.2 MB)
│   └── pretrained/                 # Cache for downloaded torchvision backbones
│
├── reports/                        # Formal publication reports
│   ├── MASTER_PROJECT_REPORT.pdf   # Complete 32-page publication report (PDF)
│   ├── MASTER_PROJECT_REPORT.md    # Markdown source report
│   ├── DETAILED_METHODOLOGY.md     # Mathematical formulation & loss functions
│   ├── EXPERIMENTAL_RESULTS.md     # Consolidated ablation tables and discussion
│   └── STATISTICAL_VALIDATION_REPORT.md # Wilcoxon, Cohen's d, Holm-Bonferroni tests
│
├── results_and_reports/            # Canonical experimental data
│   ├── csv_results/                # Consolidated ablation tables
│   ├── figures/                    # 300 DPI publication figures
│   ├── PER_VIDEO_RESULTS.csv       # Per-video metrics across 124 benchmark videos
│   ├── STATISTICAL_TESTS.csv       # 165 pairwise statistical hypothesis tests
│   ├── MODALITY_COVERAGE.csv       # ASR / OCR / Audio sparsity analysis
│   └── RUNTIME_RESULTS.csv         # Wall-clock latency and throughput benchmarks
│
├── scripts/                        # Operational and verification CLI scripts
│   ├── run_pipeline.py             # Headless pipeline runner
│   ├── extract_features.py         # Feature extraction CLI
│   ├── verify_product.py           # Self-verification suite (6 verification gates)
│   └── inspect_environment.py      # Telemetry and GPU/CPU inspection
│
├── src/                            # Core Python source package
│   ├── config/                     # YAML loader and schema validator
│   ├── evaluation/                 # Metrics, benchmarks, and dataset loaders
│   ├── features/                   # ResNet-50 visual encoder & feature cache
│   ├── generation/                 # FFmpeg video extraction and stitching engine
│   ├── models/                     # Models A, C, D, D+Coh, E, F & saliency heads
│   ├── preprocessing/              # PySceneDetect, KTS, uniform frame sampler
│   ├── selection/                  # Knapsack & Greedy budget-constrained selectors
│   ├── utils/                      # Device sensing, hashing, and reproducibility
│   └── pipeline.py                 # Top-level VideoSummarizationPipeline orchestrator
│
├── tests/                          # Automated test suite (190 test cases)
│   ├── fixtures/
│   │   ├── synthetic_test.mp4      # 12-second deterministic test video fixture
│   │   └── create_test_video.py    # Synthetic video generator script
│   ├── integration/                # End-to-end integration tests
│   └── unit/                       # Unit tests for all components
│
├── run.py                          # Application startup entrypoint (python run.py)
├── run.bat / run.sh                # 1-click startup scripts (Windows / Linux)
├── setup_and_run.bat / .sh         # Automated install & launch scripts
├── requirements.txt                # Pip requirements specification
└── pyproject.toml                  # Python package configuration
```

---

## 7. Running the Automated Test Suite

To run all unit and integration tests:
```bash
pytest tests/ -v
```

Expected result:
```
============================= 190 passed in ~60-120s =============================
```

---

## 8. Summary of Research Results

| Model Architecture | TVSum Max-F1 (%) | SumMe Max-F1 (%) | OVP Max-F1 (%) | Modalities Used |
| :--- | :---: | :---: | :---: | :--- |
| **Random Baseline** | $32.01 \pm 13.58$ | $39.88 \pm 14.22$ | $38.45 \pm 12.10$ | None (Random selection) |
| **Model A (Visual Only)** | $58.12 \pm 6.42$ | $44.18 \pm 7.15$ | $63.84 \pm 5.92$ | Visual (ResNet-50) |
| **Model C (Early Fusion)** | $60.52 \pm 5.88$ | $43.74 \pm 6.94$ | $64.12 \pm 5.76$ | Visual + Spoken ASR |
| **Model D (Cross-Attention)** | $62.17 \pm 5.41$ | $45.22 \pm 6.80$ | $65.48 \pm 5.34$ | Visual + ASR + OCR |
| **Model D+Coh (Coherence)** | $62.48 \pm 5.30$ | $46.85 \pm 6.51$ | $65.90 \pm 5.12$ | Visual + ASR + OCR + Coherence |
| **Model E (Trimodal Gating)** | $62.55 \pm 5.25$ | $46.91 \pm 6.48$ | $66.02 \pm 5.08$ | Visual + Audio + Text + Gating |
| **Model F (Intent Transformer)** | $64.47 \pm 5.10$ | $47.23 \pm 6.35$ | $67.71 \pm 4.95$ | Trimodal + Intent Guidance |

*All results verified under 5-fold cross-validation with a strict 15% duration budget.*

---

## 9. Hardware & System Compatibility

- **Python**: Supported on `3.10`, `3.11`, and `3.12`.
- **Operating Systems**: Tested on **Windows 10/11**, **Ubuntu 20.04/22.04 LTS**, and **macOS 12+ (Apple Silicon & Intel)**.
- **Hardware Acceleration**: Automatic GPU detection via PyTorch CUDA. Gracefully falls back to CPU when CUDA is unavailable. Peak RAM usage is under 2.0 GB. Peak GPU VRAM is under 1.5 GB.
- **FFmpeg**: Bundled and resolved automatically via `imageio-ffmpeg` or system `ffmpeg` binary.

---

## 10. Senior Deliverable Verification Checklist

- [x] Clean repository without local `.venv`, machine-specific paths, or multi-gigabyte raw video dumps.
- [x] Working web interface accessible at `http://127.0.0.1:8000/`.
- [x] Instant playback and MP4 summary download with audio preserved.
- [x] Bundled production model checkpoint (`bilstm_saliency_best.pt`).
- [x] Deterministic test video fixture (`synthetic_test.mp4`) for immediate testing.
- [x] Self-verification script (`scripts/verify_product.py`) passing 100%.
- [x] Complete formal scientific report (`reports/MASTER_PROJECT_REPORT.pdf`).
- [x] All 165 pairwise statistical test tables and canonical benchmark CSVs included.
