
# chapter4 ----------------------------------------------------------------

# 第四章の目的
## AIC
## モデル選択

## y : 種子数
## x : 体サイズ
## f : 施肥処理の有無（C:なし, T:あり）


# load library ------------------------------------------------------------

# 本文では使っていないが、データを掘り下げるのに使う
library(tidyverse)
library(reshape2)
library(ggplot2)


# 4.2 逸脱度計算 ---------------------------------------------------------------

# load data
getwd()
setwd(file.path(getwd(),'RTstudy','statmodel','wanko','kubobook_2012/'))
data <- read.csv('./poisson/data3a.csv') %>%
  mutate(y_mean = mean(y))
data

# glm
model_1 <- glm(y ~ 1, data, family = 'poisson')       # model1 : only intercept
model_2 <- glm(y ~ x, data, family = 'poisson')       # model2 : with body size
model_3 <- glm(y ~ f, data, family = 'poisson')       # model3 : with fertilizer
model_4 <- glm(y ~ x + f, data, family = 'poisson')   # model4 : with body size + fertilizer

summary(model_1)
summary(model_2)
summary(model_3)
summary(model_4)

data_sorted <- data[order(data$x),]

par(mfrow = c(2,2))
plot(data_sorted$x, predict(model_1, newdata = data_sorted, type = 'response'), type='l',lty=1, lwd = 3, ylab='', xlab='')
plot(data_sorted$x, predict(model_2, newdata = data_sorted, type = 'response'), type='l',lty=1, lwd = 3, ylab='', xlab='')
plot(data_sorted[data_sorted$f=='T',]$x, predict(model_3, newdata = data_sorted[data_sorted$f=='T',], type = 'response'), type='l',lty=1, lwd = 3, ylab='', xlab='')
lines(data_sorted[data_sorted$f=='C',]$x, predict(model_3, newdata = data_sorted[data_sorted$f=='C',], type = 'response'), lty=2, lwd = 3, col = 'gray')
plot(data_sorted[data_sorted$f=='T',]$x, predict(model_4, newdata = data_sorted[data_sorted$f=='T',], type = 'response'), type='l',lty=1, lwd = 3, ylab='', xlab='')
lines(data_sorted[data_sorted$f=='C',]$x, predict(model_4, newdata = data_sorted[data_sorted$f=='C',], type = 'response'), lty=2, lwd = 3, col = 'gray')

# 対数尤度
logLik(model_1)
logLik(model_2)
logLik(model_3)
logLik(model_4)


# 4.2 逸脱度をもう少し詳しく ---------------------------------------------------------

## 4.2のフルモデル、Nullモデルやそれらにおける尤度が
## 本文ではちょっと分かりにくいので説明を加える

# フルモデルとは
## 得られた個々のyに対し、それぞれのyにパラメータλを設定する
## つまり、個々のyが得られる確率が最も高い分布のパラメータを各データ分用意する、ということ
## フルモデルにおける尤度はその確率の積であり、対数尤度はその対数確率の総和となる

## フルモデルにおける対数尤度 = -192.8898
LogLik_full <- sum(log(dpois(data$y, lambda = data$y))) # p74のコード


# Nullモデルとは
## 最も当てはまりが悪いモデルのこと
## ここでいうとmodel_1、切片のみのモデルを指す
## なお、本文データから算出されるλは
## λ = exp(2.058) = 7.83

## Nullモデルにおける対数尤度 = -237.6432
LogLik_null <- sum(log(dpois(data$y, lambda = exp(2.058))))  # これはlogLik(model_1)の結果と一致する,p75

# このとき、逸脱度D = -2logLより
D_full <- -2 * LogLik_full  # 最小の逸脱度 = フルモデルの逸脱度 385.7795
D_null <- -2 * LogLik_null  # 最大の逸脱度 = Nullモデルの逸脱度 475.2864

D_null - D_full  # Null逸脱度 = 最大の逸脱度 - 最小の逸脱度 = 89.50694
# D_nullの値はmodel_1のNull devianceと等しい（model_2~4のNull devianceも同じ値をとる）
summary(model_1)

## なお、本文で使用している逸脱度DはAICの第一項-2logLと同じものである
## したがって、P76にあるように、AIC = D+2kという形になっている



# 一定モデルにおける最大対数尤度 ---------------------------------------------------------

## 図4．5
## 乱数を使っているため本文とは必ずしも一致しないことに注意すること
lambda_true <- 8  # 真のλを8とする
n <- 50           # サンプル数を50とする
data_test <- rpois(n, lambda_true)  # 上記の条件からデータを生成する
model_test <- glm(data_test ~ 1, family = 'poisson')  # 一定モデルでフィッティング
logLik(model_test)  # -120くらいの対数尤度になる

beta_est <- model_test$coefficients  # 図4.9描画のため、推定されたβを確保しておく

## βを1.9~2.2までふったときの対数尤度を計算する
beta_seq <- seq(1.9, 2.2, 0.01)
logLik_test <- sapply(beta_seq, function(x){
  loglike_out <- sum(log(dpois(data_test, lambda = exp(x))))
  return(loglike_out)
})

# 図4.5を描画
par(mfrow=c(1,1))    # グラフ描画面を1x1に戻す
plot(beta_seq[which.max(logLik_test)],      # 対数尤度が最大になるβのインデックスをwhich.maxで探してxの値とする
     max(logLik_test),                      # 対数尤度が最大になる値を探す
     xlim=c(1.9, 2.2),                      # xの範囲を指定
     ylim=c(floor(min(logLik_test)), ceiling(max(logLik_test))))  # yの範囲を指定、floor,ceilingを使って端数を切り捨てもしくは切り上げ、上下がぎりぎりにならないようにしている
lines(beta_seq, logLik_test)            # 対数尤度を実線で描く
abline(h = max(logLik_test), lty = 2)   # 最大対数尤度の値の横線を破線で描く
abline(v = log(lambda_true), lty = 2)   # 真のβの値に縦線を破線で描く

## もしここで対数尤度が最大となるβを選んだとすると、
## たまたま得られたデータに対して最も当てはまりが良いβを選んでしまうことになり、
## 真のモデルからは遠くなってしまう


# 平均対数尤度 ------------------------------------------------------------------

# 真のモデルからのサンプリングを200回行い、その対数尤度の平均をとる
## サンプリング
lambda_true <- 8 # 真のλ
n <- 50          # サンプリング1回辺りのサンプル数
N <- 200         # サンプリング回数
data_sampling <- lapply(seq(N), function(x){rpois(n, lambda_true)}) %>%
  bind_cols()

## 個々のサンプルの対数尤度を算出
logLik_sampling <- sapply(seq(N), function(x){
  sum(log(dpois(data_sampling[[x]], as.numeric(exp(beta_est)))))
})
hist(logLik_sampling)

## 最大対数尤度と平均対数尤度を比較
mean(logLik_sampling)  # 平均対数尤度E[logL]
logLik(model_test)     # 最大対数尤度logL*

# 図4.9(A)を描画
plot(rep(beta_est, length(logLik_sampling)),
     logLik_sampling,
     xlim=c(1.9, 2.2),
     ylim=c(floor(min(logLik_sampling)), ceiling(max(logLik_sampling))),
     pch = '-')
abline(h=mean(logLik_sampling), lty=2)
abline(h=logLik(model_test), lty=2)
lines(beta_seq, logLik_test)
par(new=T)
plot(beta_est, mean(logLik_sampling),
     xlim=c(1.9, 2.2),
     ylim=c(floor(min(logLik_sampling)), ceiling(max(logLik_sampling))),
     pch = 16, col='gray69', cex=2,
     ylab='', xlab='')
par(new=T)
plot(beta_est, logLik(model_test),
     xlim=c(1.9, 2.2),
     ylim=c(floor(min(logLik_sampling)), ceiling(max(logLik_sampling))),
     pch = 21, col='gray69', bg = 'white', cex=2,
     ylab='', xlab='')

## 最大対数尤度は平均対数尤度と必ずしも一致しない

## 一定モデルでの推定を12回繰り返す
repnum <- 12     # 繰り返し回数
lambda_true <- 8 # 真のλ
n <- 50          # サンプリング1回辺りのサンプル数
N <- 200         # サンプリング回数

data_rep <- lapply(seq(repnum), function(x){
  # 一定モデルでの推定と最大対数尤度の算出
  data_test <- rpois(n, lambda_true)
  model_test <- glm(data_test ~ 1, family = 'poisson')
  beta_est <- model_test$coefficients
  
  ## βを1.9~2.2までふったときの対数尤度を計算する
  beta_seq <- seq(1.9, 2.2, 0.01)
  logLik_test <- sapply(beta_seq, function(x){
    loglike_out <- sum(log(dpois(data_test, lambda = exp(x))))
    return(loglike_out)
  })
  
  # 200回繰り返しによる平均対数尤度の算出
  data_sampling <- lapply(seq(N), function(x){rpois(n, lambda_true)}) %>%
    bind_cols()
  logLik_sampling <- sapply(seq(N), function(x){
    sum(log(dpois(data_sampling[[x]], as.numeric(exp(beta_est)))))
  })
  logLik_mean <- mean(logLik_sampling)
  
  return(list(logLik_value = data.frame(beta_est = beta_est,
                                        logLik_test = logLik(model_test),
                                        logLik_mean = logLik_mean),
              logLik_sampling = data.frame(beta_est = rep(beta_est,N),
                                           logLik_sampling = logLik_sampling)))
})

df_logLik <- lapply(data_rep, function(x){ x$logLik_value }) %>% bind_rows()
df_sampling <- lapply(data_rep, function(x){ x$logLik_sampling }) %>% bind_rows()

# 図4.9(B)を描画
## 平均対数尤度を算出する際にもサンプリングを行っているので、
## 本書のグラフのように必ずしもきれいにはならない
plot(df_sampling$beta_est,
     df_sampling$logLik_sampling,
     xlim=c(1.9, 2.2),
     ylim=c(floor(min(df_sampling$logLik_sampling)), ceiling(max(df_sampling$logLik_sampling))),
     pch = '-')
par(new=T)
plot(df_logLik$beta_est, df_logLik$logLik_mean,
     xlim=c(1.9, 2.2),
     ylim=c(floor(min(df_sampling$logLik_sampling)), ceiling(max(df_sampling$logLik_sampling))),
     pch = 16, col='gray69', cex=2,
     ylab='', xlab='')
par(new=T)
plot(df_logLik$beta_est, df_logLik$logLik_test,
     xlim=c(1.9, 2.2),
     ylim=c(floor(min(df_sampling$logLik_sampling)), ceiling(max(df_sampling$logLik_sampling))),
     pch = 21, col='gray69', bg = 'white', cex=2,
     ylab='', xlab='')


# 最大対数尤度と平均対数尤度のバイアスの分布を計算
repnum <- 10000  # 繰り返し回数 本書では200回だがあまりきれいな分布にならないので10000回とした
lambda_true <- 8 # 真のλ
n <- 50          # サンプリング1回辺りのサンプル数
N <- 200         # サンプリング回数

data_bias <- lapply(seq(repnum), function(x){
  # 一定モデルでの推定と最大対数尤度の算出
  data_test <- rpois(n, lambda_true)
  model_test <- glm(data_test ~ 1, family = 'poisson')
  beta_est <- model_test$coefficients
  
  # 200回繰り返しによる平均対数尤度の算出
  data_sampling <- lapply(seq(N), function(x){rpois(n, lambda_true)}) %>%
    bind_cols()
  logLik_sampling <- sapply(seq(N), function(x){
    sum(log(dpois(data_sampling[[x]], as.numeric(exp(beta_est)))))
  })
  logLik_mean <- mean(logLik_sampling)
  
  return(data.frame(beta_est = beta_est,
                    logLik_test = logLik(model_test),
                    logLik_mean = logLik_mean,
                    bias = logLik(model_test) - logLik_mean))
}) %>%
  bind_rows()

summary(data_bias)

ggplot(data_bias, aes(x=bias, y=..density..)) +
  geom_histogram() +
  geom_density()

## 一定モデルの場合のバイアスはおおよそ1になる
## これはパラメータ数k=1とほぼ同じであり、
## logL* - kにより平均対数尤度の推定値を得ることができることが示された
## つまり、AICは最大対数尤度をパラメータ数でバイアス補正した値である、とも言える


# 4.5 パラメータ数の変化によるバイアスの変化 -------------------------------------------------

## コードは書いていない
## 体サイズのデータ発生をめんどくさがったため
