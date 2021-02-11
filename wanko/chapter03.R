
# chapter3 ----------------------------------------------------------------

# 第三章の目的
## 説明変数を組み込んだ統計モデル
## ポアソン回帰

## y : 種子数
## x : 体サイズ
## f : 施肥処理の有無（C:なし, T:あり）　


# load library ------------------------------------------------------------

# 本文では使っていないが、データを掘り下げるのに使う
library(tidyverse)
library(ggplot2)
library(psych)
library(reshape2)

# set working directory ---------------------------------------------------

getwd()
setwd(file.path(getwd(),'RTstudy','statmodel','wanko','kubobook_2012/'))

# load data ---------------------------------------------------------------

# working directory直下に各データフォルダを配置
# その中からデータを読み込み

data <- read.csv('./poisson/data3a.csv')
data


# display data ------------------------------------------------------------

# 3.2

print(data)
data$x
data$y
data$f  # 変数fは因子型で格納

class(data) # 指定したデータの型を表示
class(data$x)
class(data$y)
class (data$f)

summary(data) # 各変数の要約統計量を表示


# visualization -----------------------------------------------------------

# 3.3

# scatter plot
plot(data$x, data$y, pch = c(21, 19)[data$f])
legend('topleft', legend=c('C', 'T'), pch = c(21, 19))

# box-wisker plot
## 第一引数がfactor型で第二引数がnumeric型の場合、plotは自動的に箱ひげ図になる
plot(data$f, data$y)

# 本文より
## 体サイズが大きくなるにつれて種子数が多くなっていそうだ
## 施肥効果は影響してなさそう

# 3.3 extra

# 先に進む前に念のための確認
## 施肥状況と体サイズに相関がないか確認
plot(data$f, data$x)

# グループ別に要約統計量を出したい
# https://note.com/dhjnk/n/ne09e4398093d
describeBy(data, group = data$f) # psychの関数を利用

# 施肥Tの場合、体サイズが大きくなる傾向がありそう
# これは説明変数間の交互作用によるものと考えられるが、本章では交互作用は扱わないので後に譲る（六章）


# poisson regression ------------------------------------------------------

# 3.4.1
## リンク関数の説明

beta_1 <- c(-2, -0.8)
beta_2 <- c(-1, 0.4)

data_link <- data.frame(x = data$x,
                        lambda_1 = exp(beta_1[1] + beta_1[2]*data$x),
                        lambda_2 = exp(beta_2[1] + beta_2[2]*data$x))
data_link <- data_link[order(data_link$x),]

plot(data_link$x, data_link$lambda_1, type = 'b')
par(new=T)
plot(data_link$x, data_link$lambda_2, type = 'b',
     xaxt = 'n',
     yaxt = 'n',
     xlab = '',
     ylab = '')
abline(v=9.428)

# 本書の図3.4はおそらくxの平均値9.428をx軸の0としているっぽい→ちょっと違う
# 元のコードを見ると直接データから何かを算出しているわけではなさそう
# とはいえ本文のグラフとなんとなく近いものが得られたのでよしとする

# もしリンク関数を使わずにλを算出したらどうなるか？
data_link <- data.frame(x = data$x,
                        lambda_1 = beta_1[1] + beta_1[2]*data$x,
                        lambda_2 = beta_2[1] + beta_2[2]*data$x)
data_link <- data_link[order(data_link$x),]

plot(data_link$x, data_link$lambda_1, type = 'b')
par(new=T)
plot(data_link$x, data_link$lambda_2, type = 'b',
     xaxt = 'n',
     yaxt = 'n',
     xlab = '',
     ylab = '')

# 体サイズと種子数が線形の関係になり、種子数がマイナスの値をとりうる、というおかしな結果になってしまう
# そのため、カウントデータを被説明変数とする場合、線形の関係をそのまま持ち込むのはだめ、ということになる

# 3.4.2
## フィッティング

fit <- glm(y ~ x,              # 被説明変数と説明変数の関係を表す
           data,               # 使用するデータを明示
           family = poisson)   # 被説明変数の分布を指定

fit # フィッティングの結果を表示
summary(fit)

# フィッティングしたモデルの対数尤度を算出
logLik(fit)

# 現時点でこれが良いのか悪いのかは判断しようがない


# 3.4.3
## 予測
## ここで予測しているのはある体サイズに対応した平均種子数λである
plot(data$x, data$y, pch = c(21, 19)[data$f])
xx <- seq(min(data$x), max(data$x), length = 100)
lines(xx, exp(1.29 + 0.0757 * xx), lwd = 2)

# 上のコードと同じことをやっている
# predict関数の方がいちいち式を作って係数を入力しなくて良いので簡単
plot(data$x, data$y, pch = c(21, 19)[data$f])
yy <- predict(fit, newdata = data.frame(x = xx), type = "response")
lines(xx, yy, lwd = 2)


# statistical model with categirical data ---------------------------------

# 3.5.1
fit.f <- glm(y ~ f,
             data = data,
             family = poisson)
fit.f
logLik(fit.f)


# statistical model with numerical and categorical data -------------------

fit.all <- glm(y ~ x + f,
               data = data,
               family = poisson)

fit.all
logLik(fit.all)



# other comments ----------------------------------------------------------

# 図3.9はplot.d0.Rで描画されている

# 図3.9をggplotで自力で描いてみる

## データ作成
## λ = exp(β_0 + xβ_1)
x <- seq(0, 2, length = 30)
beta <- c(-4, 3)
lambda <- exp(beta[1] + x * beta[2])
y <- sapply(seq(length(x)), function(i){
  rpois(1, lambda[i])
})

## ポアソン回帰
model <- glm(y ~ x,family = poisson)
summary(model)

## 回帰曲線用のデータを作成
y_pred <- predict(model, newdata = data.frame(x=x), type = 'response')
  
## プロットを確認
plot(x, y) # betaの値はgenerate.d0.Rを参照

## x, lambda, yのデータフレームを作る
data_df <- data.frame(x = x,
                      lambda  = lambda,
                      y = y,
                      y_pred = y_pred)

## ggplotで元データと回帰曲線をプロットしてみる
ggplot(data = data_df, aes(x = x, y = y)) +
  geom_point(size = 3, shape = 21) +
  geom_line(linetype = 'dashed', size = 1, aes(x = x, y = y_pred)) +
  scale_y_continuous(breaks=c(0,seq(max(y))))

## 9, 18, 27番目のlambdaの値におけるポアソン分布を作成
## プロットしてチェック
x_p <- c(0, seq(max(y)))
plot(x_p, dpois(x_p, lambda[9]))
plot(x_p, dpois(x_p, lambda[18]))
plot(x_p, dpois(x_p, lambda[27]))

## 各確率分布をデータフレームにして格納
## tidy dataにする！
p_df <- data.frame(pos = melt(sapply(c(9,18,27), function(i){ rep(i*(2/30), length(x_p)) }))$value,
                   x_p = rep(x_p, 3),
                   prob = melt(sapply(c(9,18,27), function(i){ dpois(x_p, lambda[i]) }))$value)

## 矩形描画用のデータを追加する
## geom_rectの引数
### xmin:左端, xmax:右端, ymin:下端, ymax=上端
p_df$xmin <- p_df$pos - (min(p_df$pos) * (p_df$prob * 0.9))
p_df$xmax <- p_df$pos
p_df$ymin <- p_df$x_p - 0.4
p_df$ymax <- p_df$x_p + 0.4

## 矩形の描画テスト
ggplot() +
  geom_rect(data = p_df, aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax), fill = 'gray69') +
  geom_vline(xintercept = c(9,18,27)*(2/30), color = 'gray69') +
  theme(legend.position = 'none')


## 最終描画
ggplot() +
  geom_rect(data = p_df, aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax), fill = 'gray69') +
  geom_vline(xintercept = c(9,18,27)*(2/30), color = 'gray69') +
  geom_point(data = data_df, size = 3, shape = 21, aes(x = x, y = y)) +
  geom_line(linetype = 'dashed', size = 1, aes(x = x, y = y_pred)) +
  scale_y_continuous(breaks=c(0,seq(max(y)))) +
  theme(legend.position = 'none')
