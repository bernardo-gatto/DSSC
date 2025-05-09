# DSSC: Discriminative Singular Spectrum Classifier

This repository contains MATLAB code for:

> **Gatto, B. B., Colonna, J. G., dos Santos, E. M., Koerich, A. L., & Fukui, K.** (2022). *Discriminative Singular Spectrum Classifier with applications on bioacoustic signal recognition*. *Digital Signal Processing*. [https://doi.org/10.1016/j.dsp.2022.103858](https://doi.org/10.1016/j.dsp.2022.103858)

## Abstract

> We present a bioacoustic signal classifier that transforms input signals into subspaces via Singular Spectrum Analysis (SSA) and applies a discriminative mechanism to extract robust features. The model handles nonuniform signal lengths natively, tolerates noise without segmentation, and requires minimal training data. Evaluated on frog, bee, and mosquito datasets, our approach achieves competitive accuracy against state-of-the-art bioacoustic classifiers. Code available at [https://github.com/bernardo-gatto/DSSC](https://github.com/bernardo-gatto/DSSC)

## Highlights

* **Singular Spectrum Analysis (SSA)** for compact, segmentation-free representation
* **Discriminative subspace extraction** for noise tolerance and feature robustness
* Validated on three challenging bioacoustic datasets (anuran, bee, mosquito)

## Getting Started

1. **Clone the repository**

   ```bash
   git clone https://github.com/bernardo-gatto/DSSC.git
   cd DSSC
   ```

2. **Requirements**

   * MATLAB R2019b or later
   * Signal Processing Toolbox

3. **Usage Example**

   ```matlab
   % Load dataset (e.g., Beehive_Autocorrelation_Data_set_L_45.mat)
   load('Beehive_Autocorrelation_Data_set_L_45.mat');  % variable: Data

   % Train and test the DSSC model
   % Adjust parameters in DSSA.m and MSSA.m as needed
   model = DSSA(Data);
   accuracy = MSSA(model, Data);

   % Plot average similarity metrics
   sim_avr(accuracy);
   ```

## Key Scripts

* `DSSA.m`       – Discriminative Singular Spectrum Analysis training
* `MSSA.m`       – Multi-class SSA-based classification
* `EVD.m`        – Eigenvalue decomposition utility
* `sim_avr.m`    – Plotting average similarity/accuracy results

*(Repository also includes supporting data files and example scripts.)*

## Citation

Please cite:

```bibtex
@article{gatto2022dssc,
  title={Discriminative Singular Spectrum Classifier with applications on bioacoustic signal recognition},
  author={Gatto, Bernardo Bentes and Colonna, Juan Gabriel and dos Santos, Eulanda Miranda and Koerich, Alessandro Lameiras and Fukui, Kazuhiro},
  journal={Digital Signal Processing},
  year={2022},
  doi={10.1016/j.dsp.2022.103858}
}
```

## License

MIT License – see [LICENSE](LICENSE) for details.
