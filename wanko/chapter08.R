
# chapter8 ----------------------------------------------------------------

# 第八章の目的
## MCMCおよびベイズ推定への導入
## メトロポリス法の解説および実装


# load library ------------------------------------------------------------

# 本文では使っていないが、データを掘り下げるのに使う
library(tidyverse)
library(ggplot2)
library(psych)
library(reshape2)


# load data ---------------------------------------------------------------

getwd()
setwd(file.path(getwd(),'RTstudy','statmodel','wanko','kubobook_2012/'))
load('./mcmc/data.RData')
length(data)


# draw data ---------------------------------------------------------------

count_set <- seq(0,8) # 二項分布計算用の入力値セット
q_true <- 0.45  # 真の生存確率qは図8.1の脚注に記載
n <- 20
binom_theoritical <- dbinom(count_set, size = 8, prob = q_true)*n # 20個体から各8個ずつ種子をとりその生存種子数を測定

# グラフ描画用のデータセットを作成
## 特にここまでやる必要はなかったけれど、とりあえずとっておく
data_draw <- data.frame(table(data)) %>%
  rename(n=data, freq_obs=Freq) %>%
  mutate_if(is.factor, as.numeric) %>%
  rbind(data.frame(n=c(7,8), freq_obs=c(0,0))) %>%
  merge(data.frame(n=count_set,freq_true=binom_theoritical), all.y = T) %>%
  replace_na(list(n=0, freq_obs=0))

ggplot(data=data.frame(data=data), aes(x=data)) +
  geom_bar(width=1,color='black', fill='white') +
  geom_line(data=data_draw, lty='dashed', aes(x=n, y=freq_true)) +
  geom_point(data=data_draw, size=5, shape=21, fill='white', aes(x=n, y=freq_true))
  

# calculate log-likelihood and plot ---------------------------------------

q_seq <- seq(0.01, 0.99, 0.01)
loglik_vec <- sapply(q_seq, function(x){sum(dbinom(data, 8, x, log=T))})
loglik_df <- data.frame(q=q_seq, loglik = loglik_vec)

ggplot(loglik_df, aes(x=q_seq, y=loglik)) +
  geom_point() +
  xlim(0.25, 0.65) +
  ylim(-60, -30)

# 対数尤度の比を前後で計算してみる
loglik_df_c <- loglik_df %>%
  mutate(left=exp(lag(loglik)-loglik), right=exp(lead(loglik)-loglik))

# implementation of Metropolis method -------------------------------------

# q={0.01, ... ,0.99}の間の値をとりうる
# 左右の遷移確率を0.5とする
# 選ばれた方向で対数尤度が良くなる場合は確率1で遷移する
# 選ばれた方向で対数尤度が悪くなる場合はL(q_new)/L(q_old)の確率で遷移可能とする
## 注意：対数尤度で計算するときはexp(L(q_new)-L(q_old))となることに留意すること
# ただし、q=0.01or0.99の場合は必ず0.02or0.98に遷移する
# 以上を指定回数繰り返す

n <- 100000  # 繰り返し回数
q_temp <- sample(q_seq, 1) # qの初期値を設定
res_df <- data.frame(step=seq(n),
                     q=rep(0,n),
                     p=rep(0,n),
                     res=rep(NA,n)) # 空のデータフレームを生成

for(i in seq(n)){
  # 最初にqが端点の場合の処理を実行
  if(q_temp==0.01){
    q_temp <- 0.02
    res_df[i, 2] <- q_temp 
    res_df[i, 4] <- 'right'
    next
  }else if(q_temp==0.99){
    q_temp <- 0.98
    res_df[i, 2] <- q_temp
    res_df[i, 4] <- 'left'
    next
  }
  
  # 左右どちらかをランダムに選ぶ
  next_direction <- sample(c(-1,1),1)
  
  # 選んだ方向のqと対数尤度を取得
  q_next <- loglik_df[which(q_seq==q_temp)+next_direction,]$q
  loglik_next <- loglik_df[which(q_seq==q_temp)+next_direction,]$loglik
  loglik_temp <- loglik_df[which(q_seq==q_temp),]$loglik
  
  # 確率でパラメータの更新を決定
  if(loglik_next>loglik_temp | exp(loglik_next-loglik_temp)>runif(1)){
    q_temp <- q_next
    res_df[i, 2] <- q_temp
    res_df[i, 3] <- exp(loglik_next-loglik_temp)
    res_df[i, 4] <- next_direction
    next
  }else{
    q_temp <- q_temp
    res_df[i, 2] <- q_temp
    res_df[i, 3] <- exp(loglik_next-loglik_temp)
    res_df[i, 4] <- 0
    next
  }
}


# plot result -------------------------------------------------------------

# 軌跡を描くためのデータフレームを作成
res_df_walk <- merge(res_df, loglik_df, by = 'q') %>%
  mutate(loglik_plot = loglik + (step-(n/2))*0.00001) %>%
  arrange(step)

# 軌跡を描く
ggplot(res_df_walk, aes(x=q, y=loglik_plot)) +
  geom_point(size=2, alpha=0.01)

# qのステップ進展による推移
ggplot(res_df, aes(x=step, y=q)) +
  geom_line()

# 全ステップデータを使ったqのヒストグラム
ggplot(res_df, aes(x=q, y=..density..)) +
  geom_histogram(binwidth = 0.001)

# 前半10000ステップを除いたヒストグラム
ggplot(res_df[res_df$step>10000,], aes(x=q, y=..density..)) +
  geom_histogram(binwidth = 0.01) +
  geom_density(fill='blue',alpha=0.3, bw=0.01) +
  geom_vline(xintercept = 0.45, lty='dashed', size=2)

# qの95%信用区間
quantile(res_df[res_df$step>10000,2],probs = c(0.025,0.5,0.975))
