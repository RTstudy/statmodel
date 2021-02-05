# 第二章

## ポアソン分布の最尤推定量

- ポアソン分布
<img src="https://latex.codecogs.com/gif.latex?f(x)&space;=&space;\frac{\lambda^x&space;exp(-\lambda)}{x!}" />

- ポアソン分布の尤度関数L
<img src="https://latex.codecogs.com/gif.latex?L(\lambda&space;)&space;=&space;\prod_{i}^{n}\frac{\lambda^{x_{i}}exp({-\lambda})}{{x_{i}}!}" />

- 対数尤度関数l
<img src="https://latex.codecogs.com/gif.latex?\begin{align*}&space;log(L(\lambda&space;))&space;&=&space;\ell(\lambda)\\&space;&=&space;\sum_{i}^{n}log(\frac{\lambda&space;^{x_{i}}exp(-\lambda&space;)}{x_{i}!})&space;\\&=&space;\sum_{i}^{n}\left&space;\{&space;log(\lambda^{x_{i}})&space;&plus;&space;log(exp(-\lambda))&space;-&space;{x_{i}!})&space;\right&space;\}\\&=&space;\sum_{i}^{n}\left&space;\{&space;{x_{i}}&space;log(\lambda)&space;-&space;\lambda&space;-&space;{x_{i}!})&space;\right&space;\}\end{align*}" />

- 対数尤度関数をλで偏微分
<img src="https://latex.codecogs.com/gif.latex?\begin{align*}&space;\frac{\partial&space;\ell(\lambda&space;)}{\partial&space;\lambda&space;}&space;&=&space;\sum_{i=1}^{n}\left&space;(&space;\frac{x_{i}}{\lambda&space;}&space;-&space;1&space;\right&space;)\\&space;&=&space;\frac{1}{\lambda&space;}\sum_{i=1}^{n}x_{i}&space;-&space;n&space;\end{align*}" />

- 偏微分下対数尤度関数を0とおいてλについて解く
<img src="https://latex.codecogs.com/gif.latex?\begin{align*}&space;\frac{1}{\lambda&space;}\sum_{i=1}^{n}x_{i}&space;-&space;n&space;&=&space;0\\&space;\frac{1}{\lambda&space;}\sum_{i=1}^{n}x_{i}&space;&=&space;n\\&space;\lambda&space;&=&space;\frac{1}{n}\sum_{i=1}^{n}x_{i}&space;\end{align*}" />

- 以上より、λの最尤推定量はデータの平均値である

- なお、上記の数式はオンラインLaTex数式エディタ[CODECOGS](https://www.codecogs.com/latex/eqneditor.php)で作成した
