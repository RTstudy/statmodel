
# chapter2 ----------------------------------------------------------------

# ���̖͂ړI
## �m�����z�̓���
## �|�A�\�����z�̓���

# Rstudio���command+shift+R�ŃR�[�h��؂��}���ł���
# command+shift+c�Ŏw��s�̃R�����g�A�E�g��on/off��ؑ�


# set working directory ---------------------------------------------------

# R��working directory�͒ʏ�Documents�����ɂȂ�
# setwd()��working directory��ύX�ł���
# �ύX����working directory�ɓǂݍ��ރf�[�^��z�u���Ă�����
# load�̍ۂ̃t�@�C���p�X��Z���ł���A�Ȃǂ̗��_������
# setwd()��R�N�����ɖ��񃊃Z�b�g�����̂Œ���

getwd()
setwd(file.path(getwd(),'RTstudy','statmodel','wanko','kubobook_2012/'))


# load data ---------------------------------------------------------------

# working directory�����Ɋe�f�[�^�t�H���_��z�u
# ���̒�����f�[�^��ǂݍ���

load('./distribution/data.RData')
data


# summary statistics ------------------------------------------------------

# �e��v�񓝌v�ʁA�f�[�^�ʁA�q�X�g�O�����Ȃ�

length(data)
summary(data)
table(data)
hist(data, breaks=seq(-0.5, 9.5, 1))
var(data)
sd(data)
sqrt(var(data))


# poison distribution -----------------------------------------------------

# �v���f�[�^�Ȃ̂ŗ��U���z�̂ЂƂł���|�A�\�����z�𓖂Ă͂߂Ă݂�

y <- 0:9  # Python�ł����Ƃ����range
prob <- dpois(y, lambda = 3.56) # ���ϒl3.56�̃|�A�\�����z�ɂ�����0~9�̊e�l�̊m�������߂�

plot(y, prob, type = 'b', lty = 2)

cbind(y, prob)

# �O�̂��ߊ��Ғl���Z�o
sum(y * prob)  # 3.52�ɂȂ�Alambda�Ƃقڈ�v����

# �q�X�g�O�����ƃ|�A�\�����z���d�˂ĕ\��
hist(data, breaks=seq(-0.5, 9.5, 1))
lines(y, 50 * prob, type = 'b', lty = 2)  # lines�֐����Ɗ����̃O���t�ɏ㏑�����邱�Ƃ��ł���

# �����ڂ͎��Ă��邪�A������ʓI�ɕ]��������@����������


# poison distribution and paramter lambda ---------------------------------

# �܂��̓p�����[�^lambda�ɂ��Ȃɂ��ǂ��ω�����̂��m�F

plot.new()  # �����̐}���폜

y <- seq(20)

pois_1 <- dpois(y, lambda = 3.5)
pois_2 <- dpois(y, lambda = 7.7)
pois_3 <- dpois(y, lambda = 15.1)

# �O���t�B�b�N�X�p�����[�^
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
       title = '�}��',
       legend = c('3.5', '7.7', '15.5'),
       pch = c(1, 2, 5),
       lty = rep(2,3))


# Most Likelihood Estimator(MLE) ------------------------------------------

# ���K
## �ޓx L = ��p(y|��)
## ����m�����z�ɂ����ăp�����[�^�Ƃ��^����ꂽ�Ƃ��ɁA�f�[�^y��������m�������ׂĂ������킹������
## �Ⴆ�΁Alambda=2.0�̃|�A�\�����z�ɂ����āA2���o��m����0.27, 4���o��m����0.09�E�E�E
## ���̊m���l�����ׂĂ������킹��Ɩޓx�����܂�
## �ޓx�֐������̂܂܈����Ɩʓ|�Ȃ̂ŁA�ΐ����Ƃ��đ��ς𑍘a�ɕϊ�����
## ���̑ΐ��ޓx�֐��͒P�������֐��Ȃ̂ŁA�Δ�������0�ƂȂ�p�����[�^���ΐ��ޓx���ő�ɂ���p�����[�^�ƂȂ�
## ������Ŗސ���ʂƌĂ�

logL <- function(m) sum(dpois(data, m, log = TRUE))  # �|�A�\�����z�̑ΐ��ޓx���Z�o���č��v����֐�
lambda <- seq(2, 5, 0.1)   # �p�����[�^lambda��2~5�܂�0.1�Ԋu�ŐU��
plot(lambda, sapply(lambda, logL), type = 'l')  # �ΐ��ޓx��x����lambda�Ƃ��ăv���b�g

# �ΐ��ޓx��lambda�ƈꏏ�Ƀf�[�^�t���[���ɂ��ă\�[�g���A�ޓx���ő�ɂȂ�lambda��T��
df_mle <- data.frame(lambda = lambda, Likelihood = sapply(lambda, logL))
df_mle[order(df_mle$Likelihood),]

# �Ȃ��A�{�����ΐ��ޓx�֐���lambda�ŕΔ����i�������T���v������50�j���Čv�Z�������ʁA
# �Ŗސ���ʂ�3.56�ƂȂ���

# p26�̃O���t��`���Ă݂�R�[�h
lambda <- seq(2, 5.2, 0.4)
y <- seq(0,20)
par(mfrow = c(3,3))  # �O���t�`�敔����3x3�ɕ���
sapply(lambda, function(x){   # sapply�ŕ`������[�v
  prob <- dpois(y, lambda = x)
  L <- sum(dpois(data, lambda = x, log = TRUE))
  hist(data, breaks=seq(-0.5, 9.5, 1), xlim = c(0, 10), ylim = c(0, 15))
  lines(y, 50 * prob, type = 'b', lty = 2)
  print(c(paste('lambda =',round(x,1)), paste('logL =',round(L,1))))
  text(x=8, y=15, paste('lambda =',round(x,1)))
  text(x=8, y=13, paste('logL =',round(L,1)))
})


# Numerical experiment ----------------------------------------------------

# �������g���ăf�[�^�𔭐��������Ƃ��̍Ŗސ���ʂ̂΂���𐔒l��������
# lambda=3.5�̃|�A�\�����z�ɂ��������T���v����50�̃f�[�^��3000�񔭐������A�Ŗސ���ʂ̂΂�����m�F����

par(mfrow=c(1,1))

n <- 50   # ����1�񂠂���̃T���v����
N <- 3000 # ������
lambda <- 3.5 # �p�����[�^
mle_vec <- sapply(seq(N), function(x){ # ������N�����A�f�[�^�𔭐������čŖސ���ʂ��Z�o
  y <- rpois(n, lambda = lambda)
  lambda_hat <- mean(y)
  return(lambda_hat)
})
hist(mle_vec, breaks = 20) # ����ꂽ3000�̍Ŗސ���ʂ̃q�X�g�O����

# �Ŗސ���ʂ̕��U��
# lambda/n = 0.07
# �ɂȂ�
var(mle_vec) #�Ŗސ���ʂ̕��U

# �Q�l�F
# �t�B�b�V���[���ʁA�N�����[�����I�̕s����

