
# chapter2 ----------------------------------------------------------------

# 第二章の目的
## 確率分布の導入
## ポアソン分布の導入

# Rstudio上でcommand+shift+Rでコード区切りを挿入できる
# command+shift+cで指定行のコメントアウトのon/offを切替


# set working directory ---------------------------------------------------

# Rのworking directoryは通常Documents直下になる
# setwd()でworking directoryを変更できる
# 変更したworking directoryに読み込むデータを配置しておくと
# loadの際のファイルパスを短くできる、などの利点がある
# setwd()はR起動時に毎回リセットされるので注意

getwd()
setwd(file.path(getwd(),'RTstudy','statmodel','wanko','kubobook_2012/'))


# load data ---------------------------------------------------------------

# working directory直下に各データフォルダを配置
# その中からデータを読み込み

load('./distribution/data.RData')
data


# summary statistics ------------------------------------------------------

# 各種要約統計量、データ量、ヒストグラムなど

length(data)
summary(data)
table(data)
hist(data, breaks=seq(-0.5, 9.5, 1))
var(data)
sd(data)
sqrt(var(data))


# poison distribution -----------------------------------------------------

# 計数データなので離散分布のひとつであるポアソン分布を当てはめてみる

y <- 0:9  # Pythonでいうところのrange
prob <- dpois(y, lambda = 3.56) # 平均値3.56のポアソン分布における0~9の各値の確率を求める

plot(y, prob, type = 'b', lty = 2)

cbind(y, prob)

# 念のため期待値を算出
sum(y * prob)  # 3.52になり、lambdaとほぼ一致する

# ヒストグラムとポアソン分布を重ねて表示
hist(data, breaks=seq(-0.5, 9.5, 1))
lines(y, 50 * prob, type = 'b', lty = 2)  # lines関数だと既存のグラフに上書きすることができる

# 見た目は似ているが、これを定量的に評価する方法を検討する


# poison distribution and paramter lambda ---------------------------------

# まずはパラメータlambdaによりなにがどう変化するのか確認

plot.new()  # 既存の図を削除

y <- seq(20)

pois_1 <- dpois(y, lambda = 3.5)
pois_2 <- dpois(y, lambda = 7.7)
pois_3 <- dpois(y, lambda = 15.1)

# グラフィックスパラメータ
# http://cse.naro.affrc.go.jp/takezawa/r-tips/r/53.html
plot(y,
     pois_1,
     type = 'b',
     pch = 1,
     lty = 2,
     ylim = c(0, 0.25))
par(new=T) 
plot(y, pois_2,
     type = 'b',
     pch = 2,
     lty = 2,
     ylim = c(0, 0.25),
     xaxt = 'n',
     yaxt = 'n',
     xlab = '',
     ylab = '')
par(new=T) 
plot(y, pois_3,
     type = 'b',
     pch = 5,
     lty = 2,
     ylim = c(0, 0.25),
     xaxt = 'n',
     yaxt = 'n',
     xlab = '',
     ylab = '')

legend("topright",
       title = '凡例',
       legend = c('3.5', '7.7', '15.5'),
       pch = c(1, 2, 5),
       lty = rep(2,3))


# Most Likelihood Estimator(MLE) ------------------------------------------

# 復習
## 尤度 L = Πp(y|θ)
## ある確率分布においてパラメータθが与えられたときに、データyが得られる確率をすべてかけ合わせたもの
## 例えば、lambda=2.0のポアソン分布において、2が出る確率は0.27, 4が出る確率は0.09・・・
## この確率値をすべてかけ合わせると尤度が求まる
## 尤度関数をそのまま扱うと面倒なので、対数をとって総積を総和に変換する
## この対数尤度関数は単調増加関数なので、偏微分して0となるパラメータが対数尤度を最大にするパラメータとなる
## これを最尤推定量と呼ぶ

logL <- function(m) sum(dpois(data, m, log = TRUE))  # ポアソン分布の対数尤度を算出して合計する関数
lambda <- seq(2, 5, 0.1)   # パラメータlambdaを2~5まで0.1間隔で振る
plot(lambda, sapply(lambda, logL), type = 'l')  # 対数尤度をx軸をlambdaとしてプロット

# 対数尤度をlambdaと一緒にデータフレームにしてソートし、尤度が最大になるlambdaを探す
df_mle <- data.frame(lambda = lambda, Likelihood = sapply(lambda, logL))
df_mle[order(df_mle$Likelihood),]

# なお、本文より対数尤度関数をlambdaで偏微分（ただしサンプル数は50）して計算した結果、
# 最尤推定量は3.56となった

# p26のグラフを描いてみるコード
lambda <- seq(2, 5.2, 0.4)
y <- seq(0,20)
par(mfrow = c(3,3))  # グラフ描画部分を3x3に分割
sapply(lambda, function(x){   # sapplyで描画をループ
  prob <- dpois(y, lambda = x)
  L <- sum(dpois(data, lambda = x, log = TRUE))
  hist(data, breaks=seq(-0.5, 9.5, 1), xlim = c(0, 10), ylim = c(0, 15))
  lines(y, 50 * prob, type = 'b', lty = 2)
  print(c(paste('lambda =',round(x,1)), paste('logL =',round(L,1))))
  text(x=8, y=15, paste('lambda =',round(x,1)))
  text(x=8, y=13, paste('logL =',round(L,1)))
})


# Numerical experiment ----------------------------------------------------

# 乱数を使ってデータを発生させたときの最尤推定量のばらつきを数値実験する
# lambda=3.5のポアソン分布にしたがうサンプル数50のデータを3000回発生させ、最尤推定量のばらつきを確認する

par(mfrow=c(1,1))

n <- 50   # 実験1回あたりのサンプル数
N <- 3000 # 実験回数
lambda <- 3.5 # パラメータ
mle_vec <- sapply(seq(N), function(x){ # 実験回数Nだけ、データを発生させて最尤推定量を算出
  y <- rpois(n, lambda = lambda)
  lambda_hat <- mean(y)
  return(lambda_hat)
})
hist(mle_vec, breaks = 20) # 得られた3000個の最尤推定量のヒストグラム

# 最尤推定量の分散は
# lambda/n = 0.07
# になる
var(mle_vec) #最尤推定量の分散

# 参考：
# フィッシャー情報量、クラメールラオの不等式


