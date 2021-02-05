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

## 統計検定対応

### ポアソン分布の平均の導出
<img src="https://latex.codecogs.com/gif.latex?\begin{align*}&space;E[X]&space;&=&space;\sum_{k=0}^{n}k\frac{\lambda&space;^{k}exp(-\lambda&space;)}{k!}\\&space;&=&space;\sum_{k=0}^{n}\frac{\lambda&space;^{k}exp(-\lambda&space;)}{(k-1)!}\\&space;&=&space;\lambda&space;\sum_{k=0}^{n}\frac{\lambda&space;^{k-1}exp(-\lambda&space;)}{(k-1)!}\\&space;&=&space;\lambda&space;\end{align*}" />

- k-1 = k', n=∞と置くと、後ろの項がポアソン分布であり、確率分布関数の総和は1になることを利用している

### ポアソン分布の分散の導出
<img src="https://latex.codecogs.com/gif.latex?\begin{align*}&space;E[X^2]&space;&=&space;\sum_{k=0}^{n}k^2\frac{\lambda&space;^{k}exp(-\lambda&space;)}{k!}\\&space;&=&space;\sum_{k=0}^{n}(k(k-1)&plus;k)\frac{\lambda&space;^{k}exp(-\lambda&space;)}{k!}\\&space;&=&space;\sum_{k=0}^{n}k(k-1)\frac{\lambda&space;^{k}exp(-\lambda&space;)}{k!}&space;&plus;&space;\sum_{k=0}^{n}k\frac{\lambda&space;^{k}exp(-\lambda&space;)}{k!}\\&space;&=&space;\sum_{k=0}^{n}(k-1)\frac{\lambda&space;^{k}exp(-\lambda&space;)}{(k-1)!}&space;&plus;&space;\lambda\\&space;&=&space;\sum_{k=0}^{n}\frac{\lambda&space;^{k}exp(-\lambda&space;)}{(k-2)!}&space;&plus;&space;\lambda\\&space;&=&space;\lambda&space;^{2}\sum_{k=0}^{n}\frac{\lambda&space;^{k-2}exp(-\lambda&space;)}{(k-2)!}&space;&plus;&space;\lambda\\&space;&=&space;\lambda&space;^{2}&space;&plus;&space;\lambda&space;\end{align*}" />

<img src="https://latex.codecogs.com/gif.latex?\begin{align*}&space;Var(X)&space;&=&space;E[X^2]&space;-&space;E[X]^2\\&space;&=&space;\lambda^{2}&plus;\lambda&space;-&space;\lambda^{2}\\&space;&=&space;\lambda&space;\end{align*}" />

- 以上より、ポアソン分布の平均はλ、分散もλである

### 自分用メモ

- 最尤法によるパラメータの推定量の分散はVar(X)/n（推定量の漸近正規性）
- クラメールラオの不等式より、推定量の分散はフィッシャー情報量の逆数よりも小さくなることはできない
- つまり、推定量の分散がフィッシャー情報量の逆数と等しいとき、その推定量がもっとも良い推定量（=有効推定量）となる
- より詳しくは「統計的機械学習の数理100問 with Python」のp95~98(4.2項)を参照すること
- もしくは「自然科学の統計学」のp128~p132(4.4.1一致性、4.4.2漸近有効性)が、ポアソン分布を例に説明してあるのでわかりやすい
- 証明は込み入っているが、数値シミュレーションでもパラメータが正規分布すること、その分散がVar(X)/nになることは確かめられる
