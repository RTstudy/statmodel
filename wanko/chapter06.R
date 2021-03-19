
# chapter6 ----------------------------------------------------------------

# ��Z�̖͂ړI
## ���W�X�e�B�b�N��A���f��
## �I�t�Z�b�g��

# load library ------------------------------------------------------------

# �{���ł͎g���Ă��Ȃ����A�f�[�^���@�艺����̂Ɏg��
library(tidyverse)
library(ggplot2)
library(psych)
library(reshape2)


# load data ---------------------------------------------------------------

getwd()
setwd(file.path(getwd(),'RTstudy','statmodel','wanko','kubobook_2012/'))
data_a <- read.csv('./binomial/data4a.csv')
data_b <- read.csv('./binomial/data4b.csv')
data_a  # ������q���Ƒ̃T�C�Y����ю{����ʂ̃f�[�^
data_b  # 


# for data_a --------------------------------------------------------------

summary(data_a)

# fig6.2 by ggplot2
ggplot(data_a, aes(x=x, y=y, col=f, group=f)) +
  geom_point(size=4, alpha=0.5)

# fig6.3 by ggplot
x <- rep(seq(0,8),3)  # k for binomial distribution
y <- sapply(c(0.1, 0.3, 0.8), function(q){  # calc probability of each binomial distribution
  dbinom(seq(0,8), 8, q)}) %>%
  melt() %>%
  select(value)
q <- c(rep(0.1,9), rep(0.3,9), rep(0.8,9))  # create data sequence for p in binomial distribution

data_fig63 <- data.frame(x = x,
                         y = y$value,
                         q = q)

ggplot(data_fig63, aes(x = x, y = y, col=as.character(q), group = q)) +
  geom_point(size = 4) +
  geom_line()

# fig6.4 by ggplot
data_fig64 <- data.frame(z = seq(-6,6,0.1),
                         q = 1/(1+exp(-seq(-6,6,0.1))))
ggplot(data_fig64, aes(x=z, y=q)) +
  geom_line(size=1) +
  geom_vline(xintercept = 0, linetype='dashed', size = 1)

# fig6.5_A by ggplot
beta_1 <- c(2, 0, -3)
beta_2 <- 2
x <- seq(-3, 3, 0.1)

z <- sapply(beta_1, function(q){
  q + beta_2*x
}) %>% melt %>% select(value)

data_fig65_A <- data.frame(x = rep(x,3),
                           q = 1/(1+exp(-z$value)),
                           beta_1 = c(rep(2, length(x)),
                                      rep(0, length(x)),
                                      rep(-3, length(x))))

ggplot(data_fig65_A, aes(x = x, y = q, col = as.character(beta_1), group = beta_1)) +
  geom_line(size=2)


# fig6.5_B by ggplot
beta_1 <- 0
beta_2 <- c(-1, 2, 4)
x <- seq(-3, 3, 0.1)

z <- sapply(beta_2, function(q){
  beta_1 + q*x
}) %>% melt %>% select(value)

data_fig65_B <- data.frame(x = rep(x,3),
                           q = 1/(1+exp(-z$value)),
                           beta_2 = c(rep(-1, length(x)),
                                      rep(2, length(x)),
                                      rep(4, length(x))))

ggplot(data_fig65_B, aes(x = x, y = q, col = as.character(beta_2), group = beta_2)) +
  geom_line(size=2)


# GLM for data_a ----------------------------------------------------------

# fitting
model_a <- glm(cbind(y, N-y) ~ x + f,
               data = data_a,
               family = binomial)

summary(model_a)

# predict
pred <- predict(model_a, newdata = data_a[,c(3,4)])
pred_logit <- 1/(1+exp(-pred))
# pred�͐����m���Ȃ̂ŁA*8���ăX�P�[�������낦�Ă���
data_a_pred <- data.frame(data_a, pred = pred_logit*8)

ggplot(data_a_pred, aes(x=x, y=y, col=f, group=f)) +
  geom_point(size = 2) +
  geom_line(size = 2, aes(x=x, y=pred, col=f, group=f))

# model selection
library(MASS)
res_AIC <- stepAIC(model_a)
res_AIC$anova  # stepAIC�̏o�͒���anova�Ɍ��ʂ������Ă���


# GLM for data_a with interaction term ------------------------------------

# check 
## �{��̗L���ɂ��̃T�C�Y�̕��z���قȂ��Ă��邱�Ƃ��m�F
ggplot(data_a, aes(x=f, y=x)) +
  geom_boxplot() + 
  geom_violin(alpha=0.2)

# fit
model_a_2 <- glm(cbind(y, N-y) ~ x * f,  # *�Ƃ��邱�ƂŌ��ݍ�p���܂񂾃��f���ɂł���
                 data = data_a,
                 family = binomial)
summary(model_a_2)

# predict
pred <- predict(model_a_2, newdata = data_a[,c(3,4)])
pred_logit <- 1/(1+exp(-pred))
# pred�͐����m���Ȃ̂ŁA*8���ăX�P�[�������낦�Ă���
data_a_pred_2 <- data.frame(data_a, pred = pred_logit*8)

ggplot(data_a_pred_2, aes(x=x, y=y, col=f, group=f)) +
  geom_point(size = 2) +
  geom_line(size = 2, aes(x=x, y=pred, col=f, group=f))

# ���f���̉���
## ���ݍ�p�������Ă��\�����ʂ͂قƂ�Ǖς�炸�A�ނ���AIC���኱�ቺ���錋�ʂƂȂ����B
## �܂�A���ݍ�p�͍���̃f�[�^�̗\���ɂ͊�^���Ȃ��ƍl������B
## ����Ŏ{��̗L���ɂ��̃T�C�Y�̕��z���قȂ邱�Ƃ��m�F�ł��Ă���B
## ����͌��ݍ�p�Ȃ̂ł͂Ȃ����H�ƍl�����邪�A���߂āu���ݍ�p�Ƃ͂Ȃɂ��H�v�ƍl���Ă݂��
## �u��̈��q�������ɂ���ꍇ�ɂ̂ݔ����������ʁv�Ȃ̂ł����āA�̃T�C�Y���傫���{�삪����Ɛ��������オ��A�Ƃ����킯�ł͂Ȃ�������
## �{��͂܂��S�̓I�ɐ��������グ���A�����ɑ̃T�C�Y��傫��������ʂ�����B
## �܂��A���킹�đ̃T�C�Y�͐����������コ������ʂ�����A�܂�{��͒��ړI�A�ԐړI�����̌��ʂ����ƍl����������R�Ȃ̂ł͂Ȃ����B


# offset term -------------------------------------------------------------

# data description
## y : �̐�
## x : ���邳
## A : �ʐ�

# plot
hist(data_b$x)
ggplot(data_b, aes(x=A, y=y, col=x)) +
  geom_point(size=4)

# poisson regression with offset term
model_b <- glm(y ~ x, offset = log(A), data = data_b, family = poisson)
model_b_nooff <- glm(y ~ x, data = data_b, family = poisson)
summary(model_b)
summary(model_b_nooff)

pred_b <- predict(model_b, newdata = data_b[,c(2,3)])
pred_b_nooff <- predict(model_b_nooff, newdata = data_b[,c(2,3)])
data_b_pred <- data.frame(data_b, pred = exp(pred_b), pred_nooff = exp(pred_b_nooff))
ggplot(data_b_pred,aes(x=y, y=pred, col=x))+
  geom_point(size=4)
ggplot(data_b_pred,aes(x=y, y=pred_nooff, col=x))+
  geom_point(size=4)

## �I�t�Z�b�g���Ȃ��imodel_b_nooff�j���Ƃ܂Ƃ��ȗ\�����ł��Ȃ�
## �P���Ɋϑ��f�[�^�ɑ債�ă|�A�\����A�����Ă��܂��ƁA�ϑ��ʐς̈Ⴂ���l�����ꂸ�A
## �K�؂Ƀ��f�����O�ł��Ă��Ȃ�����

## �ǂ�ȍ����I�t�Z�b�g���ɂ���Ηǂ��̂��H
## ���Ƃ��Αΐ��ϊ�����Ɛ��K���z�ɂȂ邱�Ƃ����炩�ɂȂ��Ă���悤�ȕϐ��ł��A�ΐ��ϊ��͂��Ȃ��ق����ǂ��̂��낤���H
## �ϑ��l��ΐ��ϊ����ĉ�A����ꍇ�̈Ӗ������ɂ��Ă͉��L���Q��
## [�ΐ��ϊ����s���Ӗ��ɂ��āB��A���͂ɂ����đΐ��ϊ�����w�i�ɂ���O��Ƃ́H](https://atarimae.biz/archives/13161)

# normal distribution -----------------------------------------------------

# ���K���z�̊m�����x
y <- seq(-5, 5, 0.1)
plot(y, dnorm(y, mean = 0, sd = 1), type = 'l') # dnorm : �������ŗ^����ꂽ�_�ɂ�����m����Ԃ�

pnorm(1.8, 0, 1) - pnorm(1.2, 0, 1) # pnorm : -��~�������܂ł̗ݐϊm����Ԃ��B���L�̂悤�ɂ����1.2~1.8�̋�Ԃ̗ݐϊm���ƂȂ�


# gamma distribution ------------------------------------------------------

library(ciTools)

# load data
load('./gamma/d.RData')

# plot
plot(d$x, d$y)

## ���������āA�Z��i�̂悤�ɐ��̒l�����Ƃ炸�A�ɒ[�Ȓl���Ƃ肪���ȕϐ��ɂ��Ă͑ΐ��ϊ������ɃK���}���z���g���̂��ǂ��H

model_c <- glm(y ~ log(x),
               family= Gamma(link = 'log'),
               data = d)
summary(model_c)

# plot with predict
pred <- predict(model_c, newdata = d, interval="prediction",  level=0.95)
data_c <- data.frame(d, pred = exp(pred))
ggplot(data_c, aes(x=x, y=y)) +
  geom_point(size = 4, alpha=0.5) +
  geom_line(size=2, linetype='dashed', aes(x=x, y=pred))

## �\����Ԃ̏o����
## ciTools���g�����@
## https://cran.r-project.org/web/packages/trending/vignettes/prediction_intervals.html
## predict�֐���se���o�͂��ċ��߂���@
## http://testblog234wfhb.blogspot.com/2014/07/generalized-linear-modelconfidence.html

x_seq <- seq(0.01, 0.8, 0.01)

pred_test <- add_pi(data_c, model_c, names = c("lpb", "upb"), type='boot', alpha = 0.1, nsims = 200000000)
pred_test <- add_pi(pred_test, model_c, names = c("ci_lpb", "ci_upb"), type='boot', alpha = 0.5, nsims = 200000000)

#pred_test <- predict(model_c, newdata = d, se.fit = T)
#critval <- qnorm(0.975,0,1)
#conf.upr <- exp(pred_test$fit + critval * pred_test$se.fit)
#conf.lwr <- exp(pred_test$fit - critval * pred_test$se.fit)
#pred.upr <- qgamma(0.975, conf.upr)
#pred.lwr <- qgamma(0.025, conf.lwr)

#data_c_test <- data.frame(d, pred = exp(pred_test$fit),
#                          conf.lwr = conf.lwr,
#                          conf.upr = conf.upr,
#                          pred.upr = pred.upr,
#                          pred.lwr = pred.lwr)

ggplot(pred_test, aes(x=x, y=y)) +
  geom_point(size = 4, alpha=0.5) +
  geom_line(size=2, linetype='dashed', aes(x=x, y=pred)) +
  geom_ribbon(size=1, aes(ymin=lpb, ymax=upb), alpha=0.2) +
  geom_ribbon(size=1, aes(ymin=ci_lpb, ymax=ci_upb), alpha=0.2)

# ciTools���Ƃ����������Ă��܂�����ǂ��A�{���Ƃقړ������ʂɂȂ������ۂ��̂ł���ŗǂ��Ƃ���