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


# 第三章

## 一般化線形モデルとリンク関数
- 3.4.1で割と唐突に「リンク関数」が出てくるので、一般化線形モデルの前提を少し加える

### 線形モデルってなんだったっけ？
<img src="https://latex.codecogs.com/gif.latex?y_{i}&space;=&space;\beta_{0}&space;&plus;&space;\beta_{1}x_{i1}&space;&plus;&space;\beta_{2}x_{i2}&space;&plus;&space;..." />

- 線形モデルとは説明変数xに係数βをかけたものの和から被説明変数を算出するもの
- 説明変数の値ごとにyが正規分布していることを前提としている
- 正規分布している、ということは説明変数の平均と分散をそのまま正規分布の平均と分散の推定値とすることができる、ということ
	- 説明変数から算出した平均をそのまま正規分布のパラメータとして用いることができる、という意味
- では、被説明変数が正規分布以外（本書ではポアソン分布）の分布の場合はどうしたら良いのだろうか？

### 線形モデルを一般化線形モデルに拡張
- たとえば被説明変数がカウントデータの場合、正規分布を用いることができない
	- カウントデータは0～∞の離散値であり、-∞~∞の連続値を対象とした正規分布はそぐわないため
- なので、被説明変数のパラメータ（ポアソン分布の場合はλ）を説明変数から算出するには、説明変数から得られた推定値を被説明変数が従う分布のパラメータに変換してやる必要がある
- **その変換のための関数がリンク関数である**

## 図3.9を自力で描画してみた
![fig_3_3](fig_3_9.png)


# 第四章

## あらすじ
- 最大対数尤度でモデルの「当てはまりの良さ」を評価することができる
- しかし、それは「たまたま得られたデータに対する当てはまりの良さ」であり、新たにとられるであろうデータに対する当てはまりの良さではない
- そこで数値実験により平均対数尤度（最大対数尤度の期待値）を算出し、最大対数尤度との差の分布を検討した
- その結果、差の期待値（=バイアス）はおおよそパラメータ数と一致することが分かった
- AICが対数尤度にパラメータ数を足しているのは、そのバイアスを補正するためである

## 不偏分散の証明（統計検定対応）
- バイアスという言葉でふと思い出したので、本文には直接関係ないが、不偏分散の証明を復習した

### 不偏推定量とは
- あるパラメータ<img src="https://latex.codecogs.com/gif.latex?\inline&space;\theta" title="\theta" />がその推定量<img src="https://latex.codecogs.com/gif.latex?\inline&space;\hat{\theta}" title="\hat{\theta}" />の期待値と一致するとき、<img src="https://latex.codecogs.com/gif.latex?\inline&space;\hat{\theta}" title="\hat{\theta}" />を不偏推定量と呼ぶ
- [不偏推定量とは？平均と分散を例に分かりやすく解説](https://ai-trend.jp/basic-study/estimator/unbiasedness/)
<img src="https://latex.codecogs.com/gif.latex?\inline&space;E[\hat{\theta}]&space;=&space;\theta" title="E[\hat{\theta}] = \theta" />

### 推定量のバイアス
- 推定量のバイアスは以下の式で定式化される。
- バイアスが0のとき、<img src="https://latex.codecogs.com/gif.latex?\inline&space;\hat{\theta}" title="\hat{\theta}" />は不偏推定量である
- バイアスが0でないとき、<img src="https://latex.codecogs.com/gif.latex?\inline&space;\hat{\theta}" title="\hat{\theta}" />をバイアスで補正することにより不偏推定量を得ることができる
- [偏り(Wikipedia JP)](https://ja.wikipedia.org/wiki/%E5%81%8F%E3%82%8A)
<img src="https://latex.codecogs.com/gif.latex?\inline&space;bias&space;=&space;E[\hat{\theta}]&space;-&space;\theta" title="bias = E[\hat{\theta}] - \theta" />

### 平均<img src="https://latex.codecogs.com/gif.latex?\inline&space;\overline{X}" />の分散
- 確率変数<img src="https://latex.codecogs.com/gif.latex?\inline&space;X" />を考える
- Xは平均<img src="https://latex.codecogs.com/gif.latex?\inline&space;\mu" />、分散<img src="https://latex.codecogs.com/gif.latex?\inline&space;\sigma&space;^{2}" />をもつ分布から得られたものとする
- このときのXの標本平均<img src="https://latex.codecogs.com/gif.latex?\inline&space;\overline{X}" />の分散は以下のように求められる

<img src="https://latex.codecogs.com/gif.latex?\begin{align*}&space;Var(\overline{X})&space;&=&space;Var(\frac{x_{1}&plus;x_{2}&plus;...&plus;x_{n}}{n})\\&space;&=&space;\frac{1}{n^{2}}Var(x_{1}&plus;x_{2}&plus;...&plus;x_{n}))\\&space;&=&space;\frac{1}{n^{2}}\left&space;\{Var(x_{1})&plus;Var(x_{2})&plus;...&plus;Var(x_{n})\right&space;\}\\&space;&=&space;\frac{1}{n^{2}}n\sigma&space;^{2}\\&space;&=&space;\frac{1}{n}\sigma^{2}\\&space;&=&space;E((\overline&space;X-\mu)^{2})&space;&space;\end{align*}" />

- 一般に以下の等式が成り立つ
- より詳細は[Variance(wikipedia in En)](https://en.wikipedia.org/wiki/Variance)を参照

<img src="https://latex.codecogs.com/gif.latex?Var(X)&space;=&space;E[(X-\mu)^{2}]" />

### 標本分散<img src="https://latex.codecogs.com/gif.latex?\inline&space;S^{2}" />の算出
<img src="https://latex.codecogs.com/gif.latex?\begin{align*}&space;S^{2}&space;&=&space;\frac{1}{n}\sum_{i=1}^{n}\left&space;(&space;x_{i}-\overline{x}&space;\right&space;)^{2}&space;\end{align*}" />

### 標本分散<img src="https://latex.codecogs.com/gif.latex?\inline&space;S^{2}" />の式変形
<img src="https://latex.codecogs.com/gif.latex?\begin{align*}&space;S^{2}&space;&=&space;\frac{1}{n}\sum_{i=1}^{n}\left&space;(&space;x_{i}-\overline{x}&space;\right&space;)^{2}\\&space;&=&space;\frac{1}{n}\sum_{i=1}^{n}\left&space;(&space;x_{i}-\overline{x}&space;-&space;\mu&space;&plus;&space;\mu&space;\right&space;)^{2}\\&space;&=&space;\frac{1}{n}\sum_{i=1}^{n}&space;\left&space;\{(x_{i}-\mu)-(\overline{x}&space;-&space;\mu)&space;\right&space;\}&space;^{2}\\&space;&=&space;\frac{1}{n}\sum_{i=1}^{n}&space;\left&space;\{(x_{i}-\mu)^{2}-2(x_{i}-\mu)(\overline{x}&space;-&space;\mu)&plus;(\overline{x}&space;-&space;\mu)^{2}\right&space;\}\\&space;&=&space;\frac{1}{n}\sum_{i=1}^{n}&space;(x_{i}-\mu)^{2}&space;-&space;\frac{2}{n}\sum_{i=1}^{n}(x_{i}-\mu)(\overline{x}&space;-&space;\mu)&space;&plus;&space;\frac{1}{n}\sum_{i=1}^{n}(\overline{x}&space;-&space;\mu)^{2}\\&space;&=&space;\frac{1}{n}\sum_{i=1}^{n}&space;(x_{i}-\mu)^{2}&space;-&space;\frac{2}{n}(\overline{x}&space;-&space;\mu)\sum_{i=1}^{n}(x_{i}-\mu)&space;&plus;&space;(\overline{x}&space;-&space;\mu)^{2}\\&space;&=&space;\frac{1}{n}\sum_{i=1}^{n}&space;(x_{i}-\mu)^{2}&space;-&space;(\overline{x}&space;-&space;\mu)^{2}\\&space;\end{align*}" />

### 標本分散の期待値
<img src="https://latex.codecogs.com/gif.latex?\begin{align*}&space;E[S^{2}]&space;&=&space;E[\frac{1}{n}\sum_{i=1}^{n}&space;(x_{i}-\mu)^{2}&space;-&space;(\overline{x}&space;-&space;\mu)^{2}]\\&space;&=&space;E[\frac{1}{n}\sum_{i=1}^{n}&space;(x_{i}-\mu)^{2}]&space;-&space;E[(\overline{x}&space;-&space;\mu)^{2}]\\&space;&=&space;\frac{1}{n}E[\sum_{i=1}^{n}&space;(x_{i}-\mu)^{2}]&space;-&space;\frac{\sigma^{2}}{n}\\&space;&=&space;\frac{1}{n}E[(x_{1}-\mu)^{2}&space;&plus;&space;(x_{1}-\mu)^{2}&plus;...&plus;(x_{n}-\mu)^{2}]&space;-&space;\frac{\sigma^{2}}{n}\\&space;&=&space;\frac{1}{n}n\sigma^{2}&space;-&space;\frac{\sigma^{2}}{n}\\&space;&=&space;\sigma^{2}&space;-&space;\frac{\sigma^{2}}{n}\\&space;&=&space;\frac{(n-1)\sigma^{2}}{n}&space;\end{align*}" />

### バイアス補正
<img src="https://latex.codecogs.com/gif.latex?\begin{align*}&space;\frac{1}{n}\sum_{i=1}^{n}(x_{i}-\overline{x})&space;&=&space;\frac{(n-1)\sigma^{2}}{n}\\&space;\frac{1}{n-1}\sum_{i=1}^{n-1}(x_{i}-\overline{x})&space;&=&space;\sigma^{2}\\&space;\end{align*}" />
