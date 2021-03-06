
# chapter7 ----------------------------------------------------------------

# 第七章の目的
## 一般化線形混合モデル(GLMM)
## 個体差、場所差(=ランダム効果)の導入


# load library ------------------------------------------------------------

# 本文では使っていないが、データを掘り下げるのに使う
library(tidyverse)
library(ggplot2)
library(psych)
library(reshape2)


# load data ---------------------------------------------------------------

getwd()
setwd(file.path(getwd(),'RTstudy','statmodel','wanko','kubobook_2012/'))
data <- read.csv('./glmm/data.csv')
data6a <- read.csv('./glmm/data6a.csv')
data6b <- read.csv('./glmm/data6b.csv')
data_b <- read.csv('./binomial/data4b.csv')


# 図7.2を描画 -----------------------------------------------------------------

# 箱ひげ図に分布をドットプロットする
# https://k-metrics.netlify.app/post/2018-09/boxplot/
## p146の図7.2ではプロットをわざとずらして各点における頻度を表現できるようにしている
## コードで書こうとするとデータをちょっといじる必要がありそうなので、ggplotで出来そうなやり方を探してみた
ggplot(data=data, aes(x=as.character(x), y=y)) +
  geom_boxplot() + 
  geom_dotplot(binaxis = "y", dotsize = 2, stackdir = "up",
               binwidth = 0.06) +
  xlab('x')

## 葉の数xが増えると種子の生存種子数が上がる
## このとき、各xにおける生存種子数は確率qとサイズ8の二項分布でモデル化できる
## 二項分布でモデル化する場合は線形予測子の結果をロジット変換すれば良い
## logit(q_i) = β1 + β2*x_i


# GLMしてみる -----------------------------------------------------------------

model_glm <- glm(cbind(y, N-y) ~ x, data=data, family=binomial) # binomialでやるときは応答変数の形式に注意する
summary(model_glm) # intercept:-2.1487, x:0.5104 本文と同じ結果が得られた

# predictの結果を使うにはロジット変換する必要があるので、関数を定義しておく
# 本文p120を参照
# predict関数でtype='response'とすれば特にいらないものだった
logistic <- function(x){ 1/(1+exp(-x))}

# 図示するためのフィッティング結果データを生成
pred_glm <- predict(model_glm, newdata = data, type = 'response') %>%
  unique() %>%
  sort()
pred_glm <- data.frame(x = seq(2,6), y = pred_glm*8)

# 真の分布データ
true_y <- logistic(seq(2,6)*1 - 4) * 8 # パラメータの真値はp160に記載 β1=-4, β2=1
true_df <- data.frame(x = seq(2,6), y=true_y)

# 図示
ggplot(data=data, aes(x=as.character(x), y=y)) +
  geom_boxplot() + 
  geom_dotplot(binaxis = "y", dotsize = 2, stackdir = "up",
               binwidth = 0.06) +
  geom_line(data=pred_glm, size = 2,aes(x=x-1, y=y))+
  geom_line(data=true_df, size = 2, linetype='dashed',aes(x=x-1, y=y))+
  xlab('x')


# 過分散の確認 ------------------------------------------------------------------

# 各xにおける分散を算出
data %>%
  group_by(x) %>%
  summarise(var(y))

# GLMで推定された分布から分散の理論値を算出
# 二項分布を仮定しているので、分散の理論値はnp(1-p)
true_q <- logistic(seq(2,6)*1 - 4)
theoritical_var <- 8 * true_q * (1-true_q)

# x=4における二項分布の理論値
theoritical_dist <- data.frame(x=seq(0,8), y=dbinom(seq(0,8), 8, 0.47)*20)

# x=4における実データの分布と理論値からの分布を比較
ggplot(data=data[data$x==4,], aes(x=y, y=..density..*8)) +
  geom_histogram() +
  geom_point(data=theoritical_dist, aes(x=x, y=y)) +
  geom_line(data=theoritical_dist, aes(x=x, y=y))

# 二項分布を仮定すると、理論値と実データが明らかに乖離している
# もともと二項分布を仮定したのは、上限と下限のあるカウントデータだからであった
# 分布の選択の理由は「データが二項分布しているから」ではなく、
# 「データの持っている性質に二項分布の性質の一部が合致しているから」である
# したがって、理論値と実データに乖離が生じたからといって、仮定した分布が正しい/間違っているということにはならない

# なので、次にすべきことは
# どうモデル化したらこの過分散の状態を表現できるか？
# ということであり、そのために混合効果モデルをつかう、という考え方の流れになっている

# 6章までは基本的に想定した確率分布と実データが合致している、という想定だったことに留意すること！


# GLMMをやってみる --------------------------------------------------------------

# glm関数では変量効果を入れたモデルが作れないので、glmmMLをインストールする
library(glmmML)

# cluster引数は変量効果（本文では個体差、場所差などといっているもの）を推定する変数を指定する
## 変量効果を考慮するグループを指定する。個体ごとにすべて違うと考えるならばidを指定する。
## たとえば植木鉢が8個あって植木鉢ごとに違うとするなら、8つのグループにわけたidを指定することになる

# 計算結果が本文とほんのちょっと異なる
# Rまたはパッケージのバージョン違い？→methodをghqにすると合致した
model_glmm <- glmmML(cbind(y, N-y) ~ x, data = data, family = binomial, cluster = id, method='ghq')
summary(model_glmm)  # なお、glmmMMオブジェクトはpredict関数には通らない

# GLMMで推定されたパラメータ
# beta_1=-4.1296, beta_2=0.9903, s=2.494

# 予測値を算出
# r_iはあくまで各xにおける二項分布の過分散を表現するためのパラメータであり、
# 各xにおける予測には用いない
# 予測されたbetaはランダム効果も含んだ予測であることに留意すること
pred_y <- logistic(seq(2,6)*0.9903 - 4.1296) * 8 # 推定されたパラメータはbeta_1=-4.1296, beta_2=0.9903
pred_glmm <- data.frame(x = seq(2,6), y=pred_y)

# 図示(図7.10(A))
ggplot(data=data, aes(x=as.character(x), y=y)) +
  geom_boxplot() + 
  geom_dotplot(binaxis = "y", dotsize = 2, stackdir = "up",
               binwidth = 0.06) +
  geom_line(data=pred_glmm, size = 1,aes(x=x-1, y=y))+
  geom_line(data=true_df, size = 1, linetype='dashed',aes(x=x-1, y=y))+
  xlab('x')


# 混合分布を作ってみる（図7.10(B)） ----------------------------------------------------

# GLMMで推定されたパラメータ
# beta_1=-4.1296, beta_2=0.9903, s=2.494
# このパラメータを使って、葉数=4の時の混合二項分布を作ってみる

# 1. まず0.1刻みで-10~10のrの確率とその時のq値を求めてデータフレームにする
norm_interval <- seq(-10,10,0.1)
norm_prob <- dnorm(norm_interval, mean=0, sd=2.494)*0.1
norm_df <- data.frame(interval=norm_interval, prob=norm_prob)

# 2. それに対応する二項分布のq値を求める
# logit(q)=beta_1 + beta_2*x_i + r_i
# このとき、x_i=4, r_iはすでに求めた値とする

binomial_q <- sapply(norm_interval, function(x){logistic(-4.1296 + 0.9903*4 + x)})

# 3. 0~8の二項分布をnorm_probで重みづけしてすべて足し合わせる
binomial_mixed <- sapply(seq(length(binomial_q)), function(x){
  dbinom(seq(0,8),8,binomial_q[x]) * norm_prob[x]
}) %>%
  apply(MARGIN = 1, sum) # applyでy方向に合計すれば良い

## 念のため、合計が1になっているか確認
sum(binomial_mixed)  # ほぼ1になっているのでOK

# 4. 描画（図7.10(B)っぽくなるか確認）
# 黒丸が実データ、白丸が推定値
data_mixed <- data.frame(y=seq(0,8), prob=binomial_mixed)
data_org <- data[data$x==4,] %>%
  group_by(y) %>%
  summarise(n=n()) %>%
  data.frame()  # ヒストグラムだと分かりづらかったので、pointプロットするためデータ数を集計する
ggplot(data=data_org, aes(x=y, y=n)) +
  geom_point(size=5) +
  geom_line(data=data_mixed, aes(x=y, y=prob*20)) +  # 葉数4の個体数は全部で20なので確率値に20をかけている
  geom_point(data=data_mixed, size=5, shape=21, fill='white', aes(x=y, y=prob*20)) +
  ylim(min=0, max=6)

            