
# chapter3 ----------------------------------------------------------------

# ��O�̖͂ړI
## �����ϐ���g�ݍ��񂾓��v���f��
## �|�A�\����A

## y : ��q��
## x : �̃T�C�Y
## f : �{�쏈���̗L���iC:�Ȃ�, T:����j�@


# load library ------------------------------------------------------------

# �{���ł͎g���Ă��Ȃ����A�f�[�^���@�艺����̂Ɏg��
library(tidyverse)
library(ggplot2)
library(psych)

# set working directory ---------------------------------------------------

getwd()
setwd(file.path(getwd(),'RTstudy','statmodel','wanko','kubobook_2012/'))

# load data ---------------------------------------------------------------

# working directory�����Ɋe�f�[�^�t�H���_��z�u
# ���̒�����f�[�^��ǂݍ���

data <- read.csv('./poisson/data3a.csv')
data


# display data ------------------------------------------------------------

# 3.2

print(data)
data$x
data$y
data$f  # �ϐ�f�͈��q�^�Ŋi�[

class(data) # �w�肵���f�[�^�̌^��\��
class(data$x)
class(data$y)
class (data$f)

summary(data) # �e�ϐ��̗v�񓝌v�ʂ�\��


# visualization -----------------------------------------------------------

# 3.3

# scatter plot
plot(data$x, data$y, pch = c(21, 19)[data$f])
legend('topleft', legend=c('C', 'T'), pch = c(21, 19))

# box-wisker plot
## ��������factor�^�ő�������numeric�^�̏ꍇ�Aplot�͎����I�ɔ��Ђ��}�ɂȂ�
plot(data$f, data$y)

# �{�����
## �̃T�C�Y���傫���Ȃ�ɂ�Ď�q���������Ȃ��Ă�������
## �{����ʂ͉e�����ĂȂ�����

# 3.3 extra

# ��ɐi�ޑO�ɔO�̂��߂̊m�F
## �{��󋵂Ƒ̃T�C�Y�ɑ��ւ��Ȃ����m�F
plot(data$f, data$x)

# �O���[�v�ʂɗv�񓝌v�ʂ��o������
# https://note.com/dhjnk/n/ne09e4398093d
describeBy(data, group = data$f) # psych�̊֐��𗘗p

# �{��T�̏ꍇ�A�̃T�C�Y���傫���Ȃ�X�������肻��
# ����͐����ϐ��Ԃ̌��ݍ�p�ɂ����̂ƍl�����邪�A�{�͂ł͌��ݍ�p�͈���Ȃ��̂Ō�ɏ���i�Z�́j


# poisson regression ------------------------------------------------------

# 3.4.1
## �����N�֐��̐���

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

# �{���̐}3.4�͂����炭x�̕��ϒl9.428��x����0�Ƃ��Ă�����ۂ���������ƈႤ
# ���̃R�[�h������ƒ��ڃf�[�^���牽�����Z�o���Ă���킯�ł͂Ȃ�����
# �Ƃ͂����{���̃O���t�ƂȂ�ƂȂ��߂����̂�����ꂽ�̂ł悵�Ƃ���

# ���������N�֐����g�킸�Ƀɂ��Z�o������ǂ��Ȃ邩�H
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

# �̃T�C�Y�Ǝ�q�������`�̊֌W�ɂȂ�A��q�����}�C�i�X�̒l���Ƃ肤��A�Ƃ����������Ȍ��ʂɂȂ��Ă��܂�
# ���̂��߁A�J�E���g�f�[�^�������ϐ��Ƃ���ꍇ�A���`�̊֌W�����̂܂܎������ނ̂͂��߁A�Ƃ������ƂɂȂ�

# 3.4.2
## �t�B�b�e�B���O

fit <- glm(y ~ x,              # ������ϐ��Ɛ����ϐ��̊֌W��\��
           data,               # �g�p����f�[�^�𖾎�
           family = poisson)   # ������ϐ��̕��z���w��

fit # �t�B�b�e�B���O�̌��ʂ�\��
summary(fit)

# �t�B�b�e�B���O�������f���̑ΐ��ޓx���Z�o
logLik(fit)

# �����_�ł��ꂪ�ǂ��̂������̂��͔��f���悤���Ȃ�


# 3.4.3
## �\��
## �����ŗ\�����Ă���̂͂���̃T�C�Y�ɑΉ��������ώ�q���ɂł���
plot(data$x, data$y, pch = c(21, 19)[data$f])
xx <- seq(min(data$x), max(data$x), length = 100)
lines(xx, exp(1.29 + 0.0757 * xx), lwd = 2)

# ��̃R�[�h�Ɠ������Ƃ�����Ă���
# predict�֐��̕�������������������ČW������͂��Ȃ��ėǂ��̂ŊȒP
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

# �}3.9��plot.d0.R�ŕ`�悳��Ă���