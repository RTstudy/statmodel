
# chapter7 ----------------------------------------------------------------

# �掵�̖͂ړI
## ��ʉ����`�������f��(GLMM)
## �̍��A�ꏊ��(=�����_������)�̓���


# load library ------------------------------------------------------------

# �{���ł͎g���Ă��Ȃ����A�f�[�^���@�艺����̂Ɏg��
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


# �}7.2��`�� -----------------------------------------------------------------

# ���Ђ��}�ɕ��z���h�b�g�v���b�g����
# https://k-metrics.netlify.app/post/2018-09/boxplot/
## p146�̐}7.2�ł̓v���b�g���킴�Ƃ��炵�Ċe�_�ɂ�����p�x��\���ł���悤�ɂ��Ă���
## �R�[�h�ŏ������Ƃ���ƃf�[�^��������Ƃ�����K�v�����肻���Ȃ̂ŁAggplot�ŏo�������Ȃ�����T���Ă݂�
ggplot(data=data, aes(x=as.character(x), y=y)) +
  geom_boxplot() + 
  geom_dotplot(binaxis = "y", dotsize = 2, stackdir = "up",
               binwidth = 0.06) +
  xlab('x')

## �t�̐�x��������Ǝ�q�̐�����q�����オ��
## ���̂Ƃ��A�ex�ɂ����鐶����q���͊m��q�ƃT�C�Y8�̓񍀕��z�Ń��f�����ł���
## �񍀕��z�Ń��f��������ꍇ�͐��`�\���q�̌��ʂ����W�b�g�ϊ�����Ηǂ�
## logit(q_i) = ��1 + ��2*x_i


# GLM���Ă݂� -----------------------------------------------------------------

model_glm <- glm(cbind(y, N-y) ~ x, data=data, family=binomial) # binomial�ł��Ƃ��͉����ϐ��̌`���ɒ��ӂ���
summary(model_glm) # intercept:-2.1487, x:0.5104 �{���Ɠ������ʂ�����ꂽ

# predict�̌��ʂ��g���ɂ̓��W�b�g�ϊ�����K�v������̂ŁA�֐����`���Ă���
# �{��p120���Q��
# predict�֐���type='response'�Ƃ���Γ��ɂ���Ȃ����̂�����
logistic <- function(x){ 1/(1+exp(-x))}

# �}�����邽�߂̃t�B�b�e�B���O���ʃf�[�^�𐶐�
pred_glm <- predict(model_glm, newdata = data, type = 'response') %>%
  unique() %>%
  sort()
pred_glm <- data.frame(x = seq(2,6), y = pred_glm*8)

# �^�̕��z�f�[�^
true_y <- logistic(seq(2,6)*1 - 4) * 8 # �p�����[�^�̐^�l��p160�ɋL�� ��1=-4, ��2=1
true_df <- data.frame(x = seq(2,6), y=true_y)

# �}��
ggplot(data=data, aes(x=as.character(x), y=y)) +
  geom_boxplot() + 
  geom_dotplot(binaxis = "y", dotsize = 2, stackdir = "up",
               binwidth = 0.06) +
  geom_line(data=pred_glm, size = 2,aes(x=x-1, y=y))+
  geom_line(data=true_df, size = 2, linetype='dashed',aes(x=x-1, y=y))+
  xlab('x')


# �ߕ��U�̊m�F ------------------------------------------------------------------

# �ex�ɂ����镪�U���Z�o
data %>%
  group_by(x) %>%
  summarise(var(y))

# GLM�Ő��肳�ꂽ���z���番�U�̗��_�l���Z�o
# �񍀕��z�����肵�Ă���̂ŁA���U�̗��_�l��np(1-p)
true_q <- logistic(seq(2,6)*1 - 4)
theoritical_var <- 8 * true_q * (1-true_q)

# x=4�ɂ�����񍀕��z�̗��_�l
theoritical_dist <- data.frame(x=seq(0,8), y=dbinom(seq(0,8), 8, 0.47)*20)

# x=4�ɂ�������f�[�^�̕��z�Ɨ��_�l����̕��z���r
ggplot(data=data[data$x==4,], aes(x=y, y=..density..*8)) +
  geom_histogram() +
  geom_point(data=theoritical_dist, aes(x=x, y=y)) +
  geom_line(data=theoritical_dist, aes(x=x, y=y))

# �񍀕��z�����肷��ƁA���_�l�Ǝ��f�[�^�����炩�ɘ������Ă���
# ���Ƃ��Ɠ񍀕��z�����肵���̂́A����Ɖ����̂���J�E���g�f�[�^������ł�����
# ���z�̑I���̗��R�́u�f�[�^���񍀕��z���Ă��邩��v�ł͂Ȃ��A
# �u�f�[�^�̎����Ă��鐫���ɓ񍀕��z�̐����̈ꕔ�����v���Ă��邩��v�ł���
# ���������āA���_�l�Ǝ��f�[�^�ɘ���������������Ƃ����āA���肵�����z��������/�Ԉ���Ă���Ƃ������Ƃɂ͂Ȃ�Ȃ�

# �Ȃ̂ŁA���ɂ��ׂ����Ƃ�
# �ǂ����f���������炱�̉ߕ��U�̏�Ԃ�\���ł��邩�H
# �Ƃ������Ƃł���A���̂��߂ɍ������ʃ��f���������A�Ƃ����l�����̗���ɂȂ��Ă���

# 6�͂܂ł͊�{�I�ɑz�肵���m�����z�Ǝ��f�[�^�����v���Ă���A�Ƃ����z�肾�������Ƃɗ��ӂ��邱�ƁI


# GLMM������Ă݂� --------------------------------------------------------------

# glm�֐��ł͕ϗʌ��ʂ���ꂽ���f�������Ȃ��̂ŁAglmmML���C���X�g�[������
library(glmmML)

# cluster�����͕ϗʌ��ʁi�{���ł͌̍��A�ꏊ���ȂǂƂ����Ă�����́j�𐄒肷��ϐ����w�肷��
## �ϗʌ��ʂ��l������O���[�v���w�肷��B�̂��Ƃɂ��ׂĈႤ�ƍl����Ȃ��id���w�肷��B
## ���Ƃ��ΐA�ؔ���8�����ĐA�ؔ����ƂɈႤ�Ƃ���Ȃ�A8�̃O���[�v�ɂ킯��id���w�肷�邱�ƂɂȂ�

# �v�Z���ʂ��{���Ƃق�̂�����ƈقȂ�
# R�܂��̓p�b�P�[�W�̃o�[�W�����Ⴂ�H��method��ghq�ɂ���ƍ��v����
model_glmm <- glmmML(cbind(y, N-y) ~ x, data = data, family = binomial, cluster = id, method='ghq')
summary(model_glmm)  # �Ȃ��AglmmMM�I�u�W�F�N�g��predict�֐��ɂ͒ʂ�Ȃ�

# GLMM�Ő��肳�ꂽ�p�����[�^
# beta_1=-4.1296, beta_2=0.9903, s=2.494

# �\���l���Z�o
# r_i�͂����܂Ŋex�ɂ�����񍀕��z�̉ߕ��U��\�����邽�߂̃p�����[�^�ł���A
# �ex�ɂ�����\���ɂ͗p���Ȃ�
# �\�����ꂽbeta�̓����_�����ʂ��܂񂾗\���ł��邱�Ƃɗ��ӂ��邱��
pred_y <- logistic(seq(2,6)*0.9903 - 4.1296) * 8 # ���肳�ꂽ�p�����[�^��beta_1=-4.1296, beta_2=0.9903
pred_glmm <- data.frame(x = seq(2,6), y=pred_y)

# �}��(�}7.10(A))
ggplot(data=data, aes(x=as.character(x), y=y)) +
  geom_boxplot() + 
  geom_dotplot(binaxis = "y", dotsize = 2, stackdir = "up",
               binwidth = 0.06) +
  geom_line(data=pred_glmm, size = 1,aes(x=x-1, y=y))+
  geom_line(data=true_df, size = 1, linetype='dashed',aes(x=x-1, y=y))+
  xlab('x')


# �������z������Ă݂�i�}7.10(B)�j ----------------------------------------------------

# GLMM�Ő��肳�ꂽ�p�����[�^
# beta_1=-4.1296, beta_2=0.9903, s=2.494
# ���̃p�����[�^���g���āA�t��=4�̎��̍����񍀕��z������Ă݂�

# 1. �܂�0.1���݂�-10~10��r�̊m���Ƃ��̎���q�l�����߂ăf�[�^�t���[���ɂ���
norm_interval <- seq(-10,10,0.1)
norm_prob <- dnorm(norm_interval, mean=0, sd=2.494)*0.1
norm_df <- data.frame(interval=norm_interval, prob=norm_prob)

# 2. ����ɑΉ�����񍀕��z��q�l�����߂�
# logit(q)=beta_1 + beta_2*x_i + r_i
# ���̂Ƃ��Ax_i=4, r_i�͂��łɋ��߂��l�Ƃ���

binomial_q <- sapply(norm_interval, function(x){logistic(-4.1296 + 0.9903*4 + x)})

# 3. 0~8�̓񍀕��z��norm_prob�ŏd�݂Â����Ă��ׂđ������킹��
binomial_mixed <- sapply(seq(length(binomial_q)), function(x){
  dbinom(seq(0,8),8,binomial_q[x]) * norm_prob[x]
}) %>%
  apply(MARGIN = 1, sum) # apply��y�����ɍ��v����Ηǂ�

## �O�̂��߁A���v��1�ɂȂ��Ă��邩�m�F
sum(binomial_mixed)  # �ق�1�ɂȂ��Ă���̂�OK

# 4. �`��i�}7.10(B)���ۂ��Ȃ邩�m�F�j
# ���ۂ����f�[�^�A���ۂ�����l
data_mixed <- data.frame(y=seq(0,8), prob=binomial_mixed)
data_org <- data[data$x==4,] %>%
  group_by(y) %>%
  summarise(n=n()) %>%
  data.frame()  # �q�X�g�O�������ƕ�����Â炩�����̂ŁApoint�v���b�g���邽�߃f�[�^�����W�v����
ggplot(data=data_org, aes(x=y, y=n)) +
  geom_point(size=5) +
  geom_line(data=data_mixed, aes(x=y, y=prob*20)) +  # �t��4�̌̐��͑S����20�Ȃ̂Ŋm���l��20�������Ă���
  geom_point(data=data_mixed, size=5, shape=21, fill='white', aes(x=y, y=prob*20)) +
  ylim(min=0, max=6)

            