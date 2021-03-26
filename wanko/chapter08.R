
# chapter8 ----------------------------------------------------------------

# �攪�̖͂ړI
## MCMC����уx�C�Y����ւ̓���
## ���g���|���X�@�̉������ю���


# load library ------------------------------------------------------------

# �{���ł͎g���Ă��Ȃ����A�f�[�^���@�艺����̂Ɏg��
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

count_set <- seq(0,8) # �񍀕��z�v�Z�p�̓��͒l�Z�b�g
q_true <- 0.45  # �^�̐����m��q�͐}8.1�̋r���ɋL��
n <- 20
binom_theoritical <- dbinom(count_set, size = 8, prob = q_true)*n # 20�̂���e8����q���Ƃ肻�̐�����q���𑪒�

# �O���t�`��p�̃f�[�^�Z�b�g���쐬
## ���ɂ����܂ł��K�v�͂Ȃ���������ǁA�Ƃ肠�����Ƃ��Ă���
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

# �ΐ��ޓx�̔��O��Ōv�Z���Ă݂�
loglik_df_c <- loglik_df %>%
  mutate(left=exp(lag(loglik)-loglik), right=exp(lead(loglik)-loglik))

# implementation of Metropolis method -------------------------------------

# q={0.01, ... ,0.99}�̊Ԃ̒l���Ƃ肤��
# ���E�̑J�ڊm����0.5�Ƃ���
# �I�΂ꂽ�����őΐ��ޓx���ǂ��Ȃ�ꍇ�͊m��1�őJ�ڂ���
# �I�΂ꂽ�����őΐ��ޓx�������Ȃ�ꍇ��L(q_new)/L(q_old)�̊m���őJ�ډ\�Ƃ���
## ���ӁF�ΐ��ޓx�Ōv�Z����Ƃ���exp(L(q_new)-L(q_old))�ƂȂ邱�Ƃɗ��ӂ��邱��
# �������Aq=0.01or0.99�̏ꍇ�͕K��0.02or0.98�ɑJ�ڂ���
# �ȏ���w��񐔌J��Ԃ�

n <- 100000  # �J��Ԃ���
q_temp <- sample(q_seq, 1) # q�̏����l��ݒ�
res_df <- data.frame(step=seq(n),
                     q=rep(0,n),
                     p=rep(0,n),
                     res=rep(NA,n)) # ��̃f�[�^�t���[���𐶐�

for(i in seq(n)){
  # �ŏ���q���[�_�̏ꍇ�̏��������s
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
  
  # ���E�ǂ��炩�������_���ɑI��
  next_direction <- sample(c(-1,1),1)
  
  # �I�񂾕�����q�Ƒΐ��ޓx���擾
  q_next <- loglik_df[which(q_seq==q_temp)+next_direction,]$q
  loglik_next <- loglik_df[which(q_seq==q_temp)+next_direction,]$loglik
  loglik_temp <- loglik_df[which(q_seq==q_temp),]$loglik
  
  # �m���Ńp�����[�^�̍X�V������
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

# �O�Ղ�`�����߂̃f�[�^�t���[�����쐬
res_df_walk <- merge(res_df, loglik_df, by = 'q') %>%
  mutate(loglik_plot = loglik + (step-(n/2))*0.00001) %>%
  arrange(step)

# �O�Ղ�`��
ggplot(res_df_walk, aes(x=q, y=loglik_plot)) +
  geom_point(size=2, alpha=0.01)

# q�̃X�e�b�v�i�W�ɂ�鐄��
ggplot(res_df, aes(x=step, y=q)) +
  geom_line()

# �S�X�e�b�v�f�[�^���g����q�̃q�X�g�O����
ggplot(res_df, aes(x=q, y=..density..)) +
  geom_histogram(binwidth = 0.001)

# �O��10000�X�e�b�v���������q�X�g�O����
ggplot(res_df[res_df$step>10000,], aes(x=q, y=..density..)) +
  geom_histogram(binwidth = 0.01) +
  geom_density(fill='blue',alpha=0.3, bw=0.01) +
  geom_vline(xintercept = 0.45, lty='dashed', size=2)

# q��95%�M�p���
quantile(res_df[res_df$step>10000,2],probs = c(0.025,0.5,0.975))