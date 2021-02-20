
# chapter5 ----------------------------------------------------------------

# ��܏̖͂ړI
## ��������
## �p�����g���b�N�u�[�g�X�g���b�v�@�ɂ�錟�蓝�v�ʂ̕��z�̍쐬

## y : ��q��
## x : �̃T�C�Y
## ��D : ��E�x�̍�


# load library ------------------------------------------------------------

# �{���ł͎g���Ă��Ȃ����A�f�[�^���@�艺����̂Ɏg��
library(tidyverse)
library(reshape2)
library(ggplot2)


# ��E�x�̍� -------------------------------------------------------------------

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


# �p�����g���b�N�u�[�g�X�g���b�v ---------------------------------------------------------

# ��낤�Ƃ��Ă��邱��
## ���������A��E�x�̍����ǂ̂悤�Ȋm�����z������̂��킩��Ȃ�
## �����ŁA�A�������̃��f�����琶�����ꂽ�f�[�^���g���ă��f�����\�z�����ꍇ��
## ��E�x�̍��̕��z�𐔒l�V�~�����[�V�����ɂ���ċ��߂�
### ���̂Ƃ��A�V�~�����[�V�����p�̃f�[�^�͑̃T�C�Y�Ƃ͂܂��������֌W�ɁA
### y�̕��ϒl���ɂƂ����|�A�\�����z���甭��������

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