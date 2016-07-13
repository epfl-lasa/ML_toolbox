Kernel Methods Toolbox
======================

A MATLAB toolbox for nonlinear signal processing and machine learning

Author: [Steven Van Vaerenbergh](http://gtas.unican.es/people/steven)

Official web: https://github.com/steven2358/kmbox


About
---

The Kernel Methods Toolbox (KMBOX) is a collection of MATLAB programs that implement kernel-based algorithms, with a focus on regression algorithms and online algorithms. It can be used for nonlinear signal processing and machine learning.

KMBOX includes implementations of algorithms such as kernel principal component analysis (KPCA), kernel canonical correlation analysis (KCCA) and kernel recursive least-squares (KRLS).

The goal of this distribution is to provide easy-to-analyze algorithm implementations, which reveal the inner mechanics of each algorithm and allow for quick modifications. The focus of these implementations is therefore on readability rather than speed or memory usage.

The basis of this toolbox was a set of programs written for the Ph.D. Thesis "Kernel Methods for Nonlinear Identification, Equalization and Separation of Signals".

Template files are provided to encourage external authors to include their own code into the toolbox.


Copyright notice
---

The code has been developed and copyrighted © 2014 by [Steven Van Vaerenbergh](http://gtas.unican.es/people/steven). It is distributed under the terms of the BSD (3-Clause) License. In short, this means that everyone is free to use it, to modify it and to redistribute it on a free basis. It is not in the public domain; it is copyrighted and there are restrictions on its distribution (see LICENSE.txt).


Installation
---

1. Run `install.m` to add the library folder to the path.
2. Type `savepath` to save the changes to the path.

Usage
---

The name of each function uses the prefix `km_` to minimize interference with other toolboxes. Usage of each function is specified in the function file itself.

Most algorithms have a corresponding demonstration file in the "demo" folder that starts with "km_demo". These are scripts that can be executed without setting any additional parameters.

The code uses the following conventions:
- For data matrices, data is stored and accessed in row format: each data point is a row in the data matrix.


Citing KMBOX
---

If you use this toolbox in your research please cite [my Ph.D. thesis](http://gtas.unican.es/pub/255):

    @phdthesis {vanvaerenbergh2010kernel,
      author = {Van Vaerenbergh, Steven}
      title = {Kernel methods for nonlinear identification, equalization and separation of signals},
      year = {2010},
      school = {University of Cantabria},
      month = feb,
      note = {Software available at \url{https://github.com/steven2358/kmbox}}
    }


Included algorithms
---

- Kernel Ridge Regression (KRR).
- Principal Component Analysis (PCA).
- Kernel Principal Component Analysis (KPCA), as proposed in B. Scholkopf, A. Smola and K.R. Muller, "Nonlinear component analysis as a kernel eigenvalue problem", Neural Computation, volume 10, no. 5, pages 1299- 1319, 1998.
- Approximate Linear Dependency Kernel Recursive Least-Squares (ALD-KRLS), as proposed in Y. Engel, S. Mannor, and R. Meir. "The kernel recursive least- squares algorithm", IEEE Transactions on Signal Processing, volume 52, no. 8, pages 2275–2285, 2004.
- Sliding-Window Kernel Recursive Least-Squares (SW-KRLS), as proposed in S. Van Vaerenbergh, J. Via, and I. Santamaria. "A sliding-window kernel RLS algorithm and its application to nonlinear channel identification", 2006 IEEE International Conference on Acoustics, Speech, and Signal Processing (ICASSP), Toulouse, France, 2006.
- Naive Online Regularized Risk Minimization Algorithm (NORMA), as proposed in J. Kivinen, A. Smola and C. Williamson. "Online Learning with Kernels", IEEE Transactions on Signal Processing, volume 52, no. 8, pages 2165-2176, 2004.
- Fixed-Budget Kernel Recursive Least-Squares (FB-KRLS), as proposed in S. Van Vaerenbergh, I. Santamaria, W. Liu and J. C. Principe, "Fixed-Budget Kernel Recursive Least-Squares", 2010 IEEE International Conference on Acoustics, Speech, and Signal Processing (ICASSP 2010), Dallas, Texas, U.S.A., March 2010.
- Incomplete Cholesky Decomposition (ICD), as proposed in Francis R. Bach and Michael I. Jordan. "Kernel Independent Component Analysis", Journal of Machine Learning Research, volume 3, pages 1-48, 2002.
- Kernel Recursive Least-Squares Tracker (KRLS-T), as proposed in M. Lazaro-Gredilla, S. Van Vaerenbergh and I. Santamaria, "A Bayesian Approach to Tracking with Kernel Recursive Least-Squares", 2011 IEEE International  Workshop on Machine Learning for Signal Processing (MLSP 2011), Beijing, China, September, 2011.
- Kernel Canonical Correlation Analysis (KCCA), as proposed in D. R. Hardoon, S. Szedmak and J. Shawe-Taylor, "Canonical Correlation Analysis: An Overview with Application to Learning Methods", Neural Computation, Volume 16 (12), Pages 2639--2664, 2004.
- Quantized Kernel Least Mean Squares (QKLMS), as proposed in Chen B., Zhao S., Zhu P., Principe J.C. "Quantized Kernel Least Mean Square Algorithm," IEEE Transactions on Neural Networks and Learning Systems, vol.23, no.1, Jan. 2012, pages 22-32.
- Alternating Kernel Canonical Correlation Analysis for blind equalization of single-input multiple-output Wiener systems, as proposed in S. Van Vaerenbergh, J. Via and I. Santamaria, "Blind Identification of SIMO Wiener Systems based on Kernel Canonical Correlation Analysis", accepted for publication in IEEE Transactions on Signal Processing, 2013.
- Kernel density estimation (KDE).
- Kernel-based Identification of Hammerstein systems (KIHAM), as proposed in S. Van Vaerenbergh and L. A. Azpicueta-Ruiz, "Kernel-Based Identification of Hammerstein Systems for Nonlinear Acoustic Echo-Cancellation", 2014 IEEE International Conference on Acoustics, Speech, and Signal Processing (ICASSP), Florence, Italy, May 2014.


How to contribute code to the toolbox
---

Option 1: email it to me (steven@gtas.dicom.unican.es)

Option 2: [fork the toolbox on GitHub](https://github.com/steven2358/kmbox), push your change to a named branch, then send me a pull request.

Include at least one "demo" file for each algorithm.


Changelog
---

History of changes:

Changes starting v0.10 are documented in the Git repository.

v0.9 (2013-05-21)
- inclusion of KDE code and demo
- minor changes

v0.8 (2013-02-11)
- inclusion of AKCCA code and demo
- minor changes

v0.7 (2012-09-01):
- inclusion of QKLMS code
- minor changes

v0.6 (2012-03-26):
- inclusion of a demo for kernel canonical correlation analysis (KCCA)

v0.5 (2012-02-14):
- inclusion of KRLS-T
- addition of a file identifier to each file

v0.4 (2011-05-04):
- inclusion of NORMA, fixed-budget KRLS, kernel PCA, incomplete Cholesky decomposition
- inclusion of incomplete cholesky decomposition algorithm (km_kernel_icd).
- included a listing of dependencies in function headers.
- format change: dafault format for data matrices is now one data point per row (instead of one per column).
- format change: one input argument less for online algorithms

v0.3 (2010-12-03):
- modifications to ALD-KRLS implementation.

v0.2 (2010-11-08):
- inclusion of kernel recursive least-squares algorithms (km_krls): ALD-KRLS (Approximate Linear Dependency KRLS), SW-KRLS (Sliding-Window KRLS).
- correction of minor details

v0.1 (2010-09-08):
- original package, includes linear PCA and kernel ridge regression algorithms.