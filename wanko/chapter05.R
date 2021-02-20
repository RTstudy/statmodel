
# chapter5 ----------------------------------------------------------------

# 第五章の目的
## 仮説検定
## パラメトリックブートストラップ法による検定統計量の分布の作成

## y : 種子数
## x : 体サイズ
## ΔD : 逸脱度の差


# load library ------------------------------------------------------------

# 本文では使っていないが、データを掘り下げるのに使う
library(tidyverse)
library(reshape2)
library(ggplot2)


# 逸脱度の差 -------------------------------------------------------------------

# load data
getwd()
setwd(file.path(getwd(),'RTstudy','statmodel','wanko','kubobook_2012/'))
data <- read.csv('./poisson/data3a.csv') %>%
  mutate(y_mean = mean(y))
data

# glm
model_1 <- glm(y ~ 1, data, family = 'poisson')       # model1 : only intercept
model_2 <- glm(y ~ x, data, family = 'poisson')       # model2 : with body size

# get deviance of each model
D_1 <- model_1$deviance  # deviance of null model
D_2 <- model_2$deviance  # deviance of body-size model

D_1
D_2
D_1 - D_2  # difference of deviance


# パラメトリックブートストラップ ---------------------------------------------------------

# やろうとしていること
## そもそも、逸脱度の差がどのような確率分布をするのかわからない
## そこで、帰無仮説のモデルから生成されたデータを使ってモデルを構築した場合の
## 逸脱度の差の分布を数値シミュレーションによって求める
### このとき、シミュレーション用のデータは体サイズとはまったく無関係に、
### yの平均値をλとしたポアソン分布から発生させる

lambda <- mean(data$y)  # lambda for data generator
x <- data$x             # x for x model
n <- 100                # sample size
N <- 100000             # repeat number of experiment

delta_D <- sapply(seq(N), function(i){
  gy <- rpois(n, lambda)  # data generation
  df <- data.frame(x = x, y = gy)
  model_1 <- glm(y ~ 1, df, family = 'poisson')
  model_2 <- glm(y ~ x, df, family = 'poisson')
  D <- model_1$deviance - model_2$deviance
  return(D)
})

delta_D <- data.frame(delta_D = delta_D)
q_deltaD <- quantile(delta_D$delta_D, probs = c(0.95))

# draw histogram
ggplot(delta_D, aes(x=delta_D, y=..density..)) +
  geom_histogram() +
  geom_vline(xintercept = q_deltaD, linetype='dotted', size = 1, color = 'gray69') + 
  geom_vline(xintercept = D_1 - D_2, linetype='dotted', size = 1, color = 'red')
