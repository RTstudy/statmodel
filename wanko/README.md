# 第二章

## ポアソン分布の最尤推定量

- ポアソン分布
<img src="https://latex.codecogs.com/gif.latex?f(x)&space;=&space;\frac{\lambda^x&space;exp(x)}{x!}" />

- ポアソン分布の尤度関数L
<img src="https://latex.codecogs.com/gif.latex?L(\lambda&space;)&space;=&space;\prod_{i}^{n}\frac{\lambda^{x_{i}}exp({x_{i}})}{{x_{i}}!}" />

- 対数尤度関数l
<img src="https://latex.codecogs.com/gif.latex?log(L(\lambda&space;))&space;=&space;l(\lambda)\\&space;=&space;\sum_{i}^{n}log(\frac{\lambda&space;^{x_{i}}exp(\lambda&space;)}{x_{i}!})&space;\\&space;=&space;\sum_{i}^{n}\left&space;\{&space;log(\lambda&space;^{x_{i}})&space;&plus;&space;log(exp(\lambda&space;))&space;-&space;{x_{i}!})&space;\right&space;\}\\&space;=&space;\sum_{i}^{n}\left&space;\{&space;{x_{i}}&space;log(\lambda)&space;&plus;&space;\lambda&space;-&space;{x_{i}!})&space;\right&space;\}" />
