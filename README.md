# ML_toolbox

**ML_toolbox**: A Machine learning toolbox containing algorithms for dimensionality reduction, clustering, classification and regression along with examples and tutorials which accompany the Master level course [Advanced Machine Learning](http://lasa.epfl.ch/teaching/lectures/ML_MSc_Advanced/index.php)  and [Machine Learning Programming](http://edu.epfl.ch/coursebook/fr/machine-learning-programming-MICRO-401) taught at [EPFL](https://www.epfl.ch/) by [Prof. Aude Billard](http://lasa.epfl.ch/people/member.php?SCIPER=115671).

Go to the ```./examples``` folder to run some simple demos and examples from each method. More in-depth tutorials are provided in ```tutorials-spring-2016``` for testing, parameter optimization, evaluation of the following 4 specific topics.

--

#### Tutorials
For access to the ```tutorials-spring-2016``` contact the [current maintainer](http://lasa.epfl.ch/people/member.php?SCIPER=238387).

##### Non-linear Dimensionality Reduction
Topics covered: kernel Principal Component Analysis (kPCA), Laplacian Eigenmaps, Isomaps.

<p align="center">
<img src="https://github.com/epfl-lasa/ML_toolbox/blob/master/img/kernelPCA.png" width="290"><img src="https://github.com/epfl-lasa/ML_toolbox/blob/master/img/2D_circle.png" width="290"><img src="https://github.com/epfl-lasa/ML_toolbox/blob/master/img/2D_circle_proj_lap.png" width="290">
</p>

#####  Classification
Topics covered: Support Vector Machine (C-SVM, nu-SVM), Relevance Vector Machine (RVM) and Adaboost
<p align="center">
<img src="https://github.com/epfl-lasa/ML_toolbox/blob/master/img/nusvm.png" width="250"><img src="https://github.com/epfl-lasa/ML_toolbox/blob/master/img/csvm_optimal_visual.png" width="250"><img src="https://github.com/epfl-lasa/ML_toolbox/blob/master/img/ada_50_iterations_alpha.png" width="300">
</p>


#####  Regression
Topics covered: Support Vector Regression (eps-SVR, nu-SVR), Relevance Vector Regression (RVM), Bayesian Linear Regression (BLR) and Gaussian Process Regression (GPR)

<p align="center">
<img src="https://github.com/epfl-lasa/ML_toolbox/blob/master/img/nonlinear_bignoise_nu001.png" width="275"><img src="https://github.com/epfl-lasa/ML_toolbox/blob/master/img/rvr_good_kernel.png" width="275"><img src="https://github.com/epfl-lasa/ML_toolbox/blob/master/img/gp_5_0_002.png" width="275">
</p>

--

#### Examples
##### Reinforcement Learning
Policy Iteration (PI) and Value Iteration (VI) in 2D grid world, Moutain car example with Temporal Difference (TD) Learning
<p align="center">
<img src="https://github.com/epfl-lasa/ML_toolbox/blob/master/img/PE_multiple.gif" width="700">
</p>

--

#### 3rd Party Software
This toolbox includes 3rd party software for the implementation of a couple of algorithms, namely:
- [Matlab Toolbox for Dimensionality Reduction](https://lvdmaaten.github.io/drtoolbox/)
- [LibSVM](https://www.csie.ntu.edu.tw/~cjlin/libsvm/)
- [Kernel Methods Toolbox](https://github.com/steven2358/kmbox)
- [SparseBayes Software](http://www.miketipping.com/downloads.htm)

You DO NOT need to install these, they are already pre-packaged in this toolbox.

--
The main authors of this toolbox and accompanying tutorials were the TA's from Spring 2016/2017 semesters:  
[Guillaume de Chambrier](http://chambrierg.com/), [Nadia Figueroa](http://lasa.epfl.ch/people/member.php?SCIPER=238387) and [Denys Lamotte](http://lasa.epfl.ch/people/member.php?SCIPER=231543)


**Current Maintainer**: [Nadia Figueroa](http://lasa.epfl.ch/people/member.php?SCIPER=238387) (nadia.figueroafernandez AT epfl dot ch)
