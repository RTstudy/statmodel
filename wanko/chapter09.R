
# chapter9 ----------------------------------------------------------------

# ���̖͂ړI
## WinBUSG�ɂ��T���v�����O�̎��H
## �������l�I�Ȏ���ɂ��RStan���g�����Ƃɂ���


# load library ------------------------------------------------------------

library(tidyverse)
library(dplyr)
library(ggplot2)
library(rstan)


# load data ---------------------------------------------------------------

getwd()
setwd(file.path(getwd(),'RTstudy','statmodel','wanko','kubobook_2012/'))
load('./gibbs/d.RData')
length(d)

# x:�̃T�C�Y
# y:�e�̂̎�q��
# ��q��y�̓|�A�\�����z������̂Ɖ��肵�A�p�����[�^�ɂ͑̃T�C�Yx�ɂ���Č��肳���
# ���̂Ƃ��̃����N�֐���log�ł���Alog(��)=��1 + ��2x�̊֌W�ɂ���Ƃ���
# �f�[�^���������Ƃ��̐^�̃p�����[�^�̓�1=1.5, ��2=0.1�ł���Ƃ���


# GLM���Ă݂� -----------------------------------------------------------------

glm_model <- glm(y ~ x, data = d, family=poisson)
summary(glm_model)

pred_glm <- predict(glm_model, newdata = d, type = 'response')

ggplot(d, aes(x=x, y=y)) + 
  geom_point(size=5, shape=21, fill='white') +
  geom_line(data=data.frame(pred = pred_glm), lty='dashed', size=2, aes(x=d$x, y=pred))

# �{���Ƃقړ����O���t���`����


# Stan���Ă݂� ----------------------------------------------------------------

# stan�ɓ����f�[�^�𒊏o
n_sample <- nrow(d)
x <- d$x
y <- d$y

# stan�ɓn�����߂�list�^�ɂ���
d_list <- list(n_sample=n_sample,
               x = x,
               y = y)

# stan���s
stan_model <- stan(file = '../chapter09.stan',
                   data = d_list)
stan_model

## ����
### beta_1=1.56, beta_2=0.08�Ƃقڐ^�̃p�����[�^�ɋ߂��l������ł��Ă���
### Rhat������ƒl���ق�1�ł���A�T���v�����O�Ԃ̑��ւ��Ȃ��ǂ�����ɂȂ��Ă���

# �T���v�����O�̉ߒ���}��
traceplot(stan_model, pars = c('beta_1', 'beta_2'))

# �T���v�����O���ʂ𒊏o�����z��}��
## beta_1
stan_sampling_res <- extract(stan_model)
g_beta1 <- ggplot(data.frame(x=stan_sampling_res$beta_1), aes(x=x, y=..density..)) +
  geom_histogram(binwidth = 0.01) +
  geom_density(fill="blue", alpha=0.2, bw=0.02) +
  xlab('beta_1')
## beta_2
stan_sampling_res <- extract(stan_model)
g_beta2 <- ggplot(data.frame(x=stan_sampling_res$beta_2), aes(x=x, y=..density..)) +
  geom_histogram(binwidth = 0.001) +
  geom_density(fill="blue", alpha=0.2, bw=0.005) +
  xlab('beta_2')

gridExtra::grid.arrange(g_beta1,g_beta2)

## beta_1��beta_2�̓������z
ggplot(data.frame(beta_1=stan_sampling_res$beta_1,
                  beta_2=stan_sampling_res$beta_2), aes(x=beta_1, y=beta_2)) +
  geom_point(size=3, alpha=0.1)

# 95%�M�p���
## beta_1
quantile(stan_sampling_res$beta_1,probs = c(0.025,0.5,0.975))
## beta_2
quantile(stan_sampling_res$beta_2,probs = c(0.025,0.5,0.975))

# �̃T�C�Y�ɑ΂���ɂ̐���l��}��
sampling_df <- lapply(seq(20), function(i){
  data.frame(x=rep(d$x[i]), lambda=stan_sampling_res$lambda[,i], y=stan_sampling_res$yhat[,i])
}) %>% bind_rows()

interval_df <- lapply(seq(20), function(i){
  data.frame(x=d$x[i],
             lower=quantile(stan_sampling_res$yhat[,i], probs = 0.025),
             upper=quantile(stan_sampling_res$yhat[,i], probs = 0.975),
             median=quantile(stan_sampling_res$yhat[,i], probs = 0.5))
}) %>% bind_rows()

ggplot(sampling_df, aes(x=x, y=exp(lambda))) +
  geom_point(size=3, alpha=0.1) +
  geom_point(d=d, size=5, shape=21, fill='white', aes(x=x, y=y))

# �̃T�C�Y�ɑ΂���y��95%�\����Ԃ�}��
ggplot(d, aes(x=x, y=y)) +
  geom_point(size=5, shape=21, fill='white') +
  geom_ribbon(data=interval_df, aes(x=x, ymin=lower, ymax=upper), fill='#000000', alpha=0.3) +
  geom_line(data=interval_df, aes(x=x, y=median))