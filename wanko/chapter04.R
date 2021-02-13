
# chapter4 ----------------------------------------------------------------

# ��l�̖͂ړI
## AIC
## ���f���I��

## y : ��q��
## x : �̃T�C�Y
## f : �{�쏈���̗L���iC:�Ȃ�, T:����j


# load library ------------------------------------------------------------

# �{���ł͎g���Ă��Ȃ����A�f�[�^���@�艺����̂Ɏg��
library(tidyverse)
library(reshape2)
library(ggplot2)


# 4.2 ��E�x�v�Z ---------------------------------------------------------------

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

# �ΐ��ޓx
logLik(model_1)
logLik(model_2)
logLik(model_3)
logLik(model_4)


# 4.2 ��E�x�����������ڂ��� ---------------------------------------------------------

## 4.2�̃t�����f���ANull���f���₻���ɂ�����ޓx��
## �{���ł͂�����ƕ�����ɂ����̂Ő�����������

# �t�����f���Ƃ�
## ����ꂽ�X��y�ɑ΂��A���ꂼ���y�Ƀp�����[�^�ɂ�ݒ肷��
## �܂�A�X��y��������m�����ł��������z�̃p�����[�^���e�f�[�^���p�ӂ���A�Ƃ�������
## �t�����f���ɂ�����ޓx�͂��̊m���̐ςł���A�ΐ��ޓx�͂��̑ΐ��m���̑��a�ƂȂ�

## �t�����f���ɂ�����ΐ��ޓx = -192.8898
LogLik_full <- sum(log(dpois(data$y, lambda = data$y))) # p74�̃R�[�h


# Null���f���Ƃ�
## �ł����Ă͂܂肪�������f���̂���
## �����ł�����model_1�A�ؕЂ݂̂̃��f�����w��
## �Ȃ��A�{���f�[�^����Z�o�����ɂ�
## �� = exp(2.058) = 7.83

## Null���f���ɂ�����ΐ��ޓx = -237.6432
LogLik_null <- sum(log(dpois(data$y, lambda = exp(2.058))))  # �����logLik(model_1)�̌��ʂƈ�v����,p75

# ���̂Ƃ��A��E�xD = -2logL���
D_full <- -2 * LogLik_full  # �ŏ��̈�E�x = �t�����f���̈�E�x 385.7795
D_null <- -2 * LogLik_null  # �ő�̈�E�x = Null���f���̈�E�x 475.2864

D_null - D_full  # Null��E�x = �ő�̈�E�x - �ŏ��̈�E�x = 89.50694
# D_null�̒l��model_1��Null deviance�Ɠ������imodel_2~4��Null deviance�������l���Ƃ�j
summary(model_1)

## �Ȃ��A�{���Ŏg�p���Ă����E�xD��AIC�̑�ꍀ-2logL�Ɠ������̂ł���
## ���������āAP76�ɂ���悤�ɁAAIC = D+2k�Ƃ����`�ɂȂ��Ă���



# ��胂�f���ɂ�����ő�ΐ��ޓx ---------------------------------------------------------

## �}4�D5
## �������g���Ă��邽�ߖ{���Ƃ͕K��������v���Ȃ����Ƃɒ��ӂ��邱��
lambda_true <- 8  # �^�̃ɂ�8�Ƃ���
n <- 50           # �T���v������50�Ƃ���
data_test <- rpois(n, lambda_true)  # ��L�̏�������f�[�^�𐶐�����
model_test <- glm(data_test ~ 1, family = 'poisson')  # ��胂�f���Ńt�B�b�e�B���O
logLik(model_test)  # -120���炢�̑ΐ��ޓx�ɂȂ�

beta_est <- model_test$coefficients  # �}4.9�`��̂��߁A���肳�ꂽ�����m�ۂ��Ă���

## ����1.9~2.2�܂łӂ����Ƃ��̑ΐ��ޓx���v�Z����
beta_seq <- seq(1.9, 2.2, 0.01)
logLik_test <- sapply(beta_seq, function(x){
  loglike_out <- sum(log(dpois(data_test, lambda = exp(x))))
  return(loglike_out)
})

# �}4.5��`��
par(mfrow=c(1,1))    # �O���t�`��ʂ�1x1�ɖ߂�
plot(beta_seq[which.max(logLik_test)],      # �ΐ��ޓx���ő�ɂȂ���̃C���f�b�N�X��which.max�ŒT����x�̒l�Ƃ���
     max(logLik_test),                      # �ΐ��ޓx���ő�ɂȂ�l��T��
     xlim=c(1.9, 2.2),                      # x�͈̔͂��w��
     ylim=c(floor(min(logLik_test)), ceiling(max(logLik_test))))  # y�͈̔͂��w��Afloor,ceiling���g���Ē[����؂�̂Ă������͐؂�グ�A�㉺�����肬��ɂȂ�Ȃ��悤�ɂ��Ă���
lines(beta_seq, logLik_test)            # �ΐ��ޓx�������ŕ`��
abline(h = max(logLik_test), lty = 2)   # �ő�ΐ��ޓx�̒l�̉�����j���ŕ`��
abline(v = log(lambda_true), lty = 2)   # �^�̃��̒l�ɏc����j���ŕ`��

## ���������őΐ��ޓx���ő�ƂȂ����I�񂾂Ƃ���ƁA
## ���܂��ܓ���ꂽ�f�[�^�ɑ΂��čł����Ă͂܂肪�ǂ�����I��ł��܂����ƂɂȂ�A
## �^�̃��f������͉����Ȃ��Ă��܂�


# ���ϑΐ��ޓx ------------------------------------------------------------------

# �^�̃��f������̃T���v�����O��200��s���A���̑ΐ��ޓx�̕��ς��Ƃ�
## �T���v�����O
lambda_true <- 8 # �^�̃�
n <- 50          # �T���v�����O1��ӂ�̃T���v����
N <- 200         # �T���v�����O��
data_sampling <- lapply(seq(N), function(x){rpois(n, lambda_true)}) %>%
  bind_cols()

## �X�̃T���v���̑ΐ��ޓx���Z�o
logLik_sampling <- sapply(seq(N), function(x){
  sum(log(dpois(data_sampling[[x]], as.numeric(exp(beta_est)))))
})
hist(logLik_sampling)

## �ő�ΐ��ޓx�ƕ��ϑΐ��ޓx���r
mean(logLik_sampling)  # ���ϑΐ��ޓxE[logL]
logLik(model_test)     # �ő�ΐ��ޓxlogL*

# �}4.9(A)��`��
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

## �ő�ΐ��ޓx�͕��ϑΐ��ޓx�ƕK��������v���Ȃ�

## ��胂�f���ł̐����12��J��Ԃ�
repnum <- 12     # �J��Ԃ���
lambda_true <- 8 # �^�̃�
n <- 50          # �T���v�����O1��ӂ�̃T���v����
N <- 200         # �T���v�����O��

data_rep <- lapply(seq(repnum), function(x){
  # ��胂�f���ł̐���ƍő�ΐ��ޓx�̎Z�o
  data_test <- rpois(n, lambda_true)
  model_test <- glm(data_test ~ 1, family = 'poisson')
  beta_est <- model_test$coefficients
  
  ## ����1.9~2.2�܂łӂ����Ƃ��̑ΐ��ޓx���v�Z����
  beta_seq <- seq(1.9, 2.2, 0.01)
  logLik_test <- sapply(beta_seq, function(x){
    loglike_out <- sum(log(dpois(data_test, lambda = exp(x))))
    return(loglike_out)
  })
  
  # 200��J��Ԃ��ɂ�镽�ϑΐ��ޓx�̎Z�o
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

# �}4.9(B)��`��
## ���ϑΐ��ޓx���Z�o����ۂɂ��T���v�����O���s���Ă���̂ŁA
## �{���̃O���t�̂悤�ɕK���������ꂢ�ɂ͂Ȃ�Ȃ�
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


# �ő�ΐ��ޓx�ƕ��ϑΐ��ޓx�̃o�C�A�X�̕��z���v�Z
repnum <- 10000  # �J��Ԃ��� �{���ł�200�񂾂����܂肫�ꂢ�ȕ��z�ɂȂ�Ȃ��̂�10000��Ƃ���
lambda_true <- 8 # �^�̃�
n <- 50          # �T���v�����O1��ӂ�̃T���v����
N <- 200         # �T���v�����O��

data_bias <- lapply(seq(repnum), function(x){
  # ��胂�f���ł̐���ƍő�ΐ��ޓx�̎Z�o
  data_test <- rpois(n, lambda_true)
  model_test <- glm(data_test ~ 1, family = 'poisson')
  beta_est <- model_test$coefficients
  
  # 200��J��Ԃ��ɂ�镽�ϑΐ��ޓx�̎Z�o
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

## ��胂�f���̏ꍇ�̃o�C�A�X�͂����悻1�ɂȂ�
## ����̓p�����[�^��k=1�Ƃقړ����ł���A
## logL* - k�ɂ�蕽�ϑΐ��ޓx�̐���l�𓾂邱�Ƃ��ł��邱�Ƃ������ꂽ
## �܂�AAIC�͍ő�ΐ��ޓx���p�����[�^���Ńo�C�A�X�␳�����l�ł���A�Ƃ�������


# 4.5 �p�����[�^���̕ω��ɂ��o�C�A�X�̕ω� -------------------------------------------------

## �R�[�h�͏����Ă��Ȃ�
## �̃T�C�Y�̃f�[�^�������߂�ǂ�������������