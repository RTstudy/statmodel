
# chapter10 ---------------------------------------------------------------

# ��\�̖͂ړI
## �K�w�x�C�Y���f���̐���


# load library ------------------------------------------------------------

library(tidyverse)
library(dplyr)
library(ggplot2)
library(rstan)


# load data ---------------------------------------------------------------

getwd()
setwd(file.path(getwd(),'RTstudy','statmodel','wanko','kubobook_2012/'))
data <- read.csv('hbm/data7a.csv')
nested <- read.csv('hbm/nested/d1.csv')


# plot binomial data ------------------------------------------------------

# data7a.csv�̃f�[�^
## id : ��id�A�̐�100
## y : �̂���8�̎�q���̎悵�����̐�����q��
## y��n=8�A�����m��q�̓񍀕��z�ł���Ɖ���ł���

# q�̍Ŗސ����
q_hat <- mean(data$y)/8
q_hat

## q�̍Ŗސ���ʂ�0.50375�ł���
## ���̃p�����[�^�Ɋ�Â��񍀕��z�Ɏ��ۂ̃f�[�^���}�b�`���邩�m�F

# �}10.1(B)��ggplot�ŕ`��

## ���f�[�^��`��p�ɕϊ�
data_count <- data %>%
  group_by(y) %>%
  summarise(count = n())

## �񍀕��z�f�[�^���쐬
data_binom <- data.frame(count=seq(0,8),
                         prob = dbinom(x = seq(0,8), size = 8, prob = q_hat)*100)

## �`��
ggplot(data=data_count, aes(x=y, y=count)) +
  geom_point(size=5, shape=21, fill='black') +
  geom_line(data=data_binom, aes(x=count, y=prob)) +
  geom_point(data=data_binom, size=5, shape=21, fill="white", aes(x=count, y=prob))

## ���U���m�F
var(data$y)  # ���f�[�^�̕��U 9.928384
8 * q_hat *(1-q_hat) # ���_�l 1.999888

## �ߕ��U�ɂȂ�


# �x�C�Y����O��GLMM���Ă݂� ---------------------------------------------------------

library(glmmML)
# �ؕЂƃ����_�����ʂ݂̂̃��f��
model_glmm <- glmmML(cbind(y, 8-y) ~ 1, data=data, family = binomial, cluster = id)
summary(model_glmm)

# ����: beta=0.04496, s=2.769
## r���W���덷2.769�ł΂�����l���Ƃ�
## logit(q[i]) = beta + r[i]

## ���_�l�̏o����
### 1. -20~20�̊Ԃ�0.01���݂�r���ӂ����Ƃ���r�̊m��p���Z�o
### 2. logit(q)=beta+r�Ƃ���q���Z�o���Aq�̊m�����z�����߂�
### 3. 2�œ���ꂽ�m�����z��r�̊m��p���悶�ďd�݂Â�
### 4. �d�݂Â������񍀕��z�𑫂����킹�č������z�Ƃ���

logistic <- function(x){
  1/(1+exp(-x))
}

beta <- 0.04496
x <- 2.769
r_seq <- seq(-20, 20, 0.01)
binomial_posterior <- lapply(r_seq, function(r){
  p_r <- dnorm(x=r, mean=0, sd=2.769) * 0.01
  p_binom <- logistic(beta+r)
  dist_binom <- dbinom(seq(0,8), size=8, prob=p_binom)* p_r
  names(dist_binom) <- as.character(seq(0,8))
  #out <- t(data.frame(p=dist_binom))
  #colnames(out) <- as.character(seq(0,8))
  return(dist_binom)
}) %>%
  bind_cols() %>%
  apply(MARGIN = 1, sum)

binomial_df <- data.frame(x=seq(0,8),
                          count = binomial_posterior*100)

# ���a��1�ɂȂ邩�m�F
sum(binomial_posterior)

## �`��
## ������ۂ����ʂɂȂ���
ggplot(data=data_count, aes(x=y, y=count)) +
  geom_point(size=5, shape=21, fill='black') +
  geom_line(data=binomial_df, aes(x=x, y=count)) +
  geom_point(data=binomial_df, size=5, shape=21, fill="white", aes(x=x, y=count))


# GLMM�̃x�C�Y���f���� ------------------------------------------------------------

# stan�R�[�h�͓��f�B���N�g����chapter_10_1.stan

# stan�ɓ����f�[�^�𒊏o
n_sample <- nrow(data)
y <- data$y

# stan�ɓn�����߂�list�^�ɂ���
d_list <- list(n_sample=n_sample,
               y = y)

# stan���s
stan_model <- stan(file = '../chapter10_1.stan',
                   data = d_list,
                   chain = 4,                # chain �f�t�H���g4
                   iter = 2000)              # �T���v�����O�� �f�t�H���g2000

# ���ʂ̕\��
options(max.print = 10000)
print(stan_model)

## beta�̎��㕪�z�͂قڃ[��

# �T���v�����O�̉ߒ���}��
traceplot(stan_model, pars = c('beta', 's'))

# �T���v�����O���ʂ𒊏o�����z��}��
# �{��p231�Ƃقړ������z��������

## extract�ŃT���v�����O���ʂ𒊏o
## extract�ŃT���v�����O���ʂ������邪�A���̂Ƃ����o�������ʂ�warmup���Ԃ����������̂ł���
stan_sampling_res <- extract(stan_model)

## beta
g_beta <- ggplot(data.frame(x=stan_sampling_res$beta), aes(x=x, y=..density..)) +
  geom_histogram(binwidth = 0.05) +
  geom_density(fill="blue", alpha=0.2, bw=0.05) +
  xlab('beta')
## s
g_s <- ggplot(data.frame(x=stan_sampling_res$s), aes(x=x, y=..density..)) +
  geom_histogram(binwidth = 0.05) +
  geom_density(fill="blue", alpha=0.2, bw=0.05) +
  xlab('s')

gridExtra::grid.arrange(g_beta,g_s)

# r�̃v���b�g
g_r_list <- lapply(seq(3), function(i){
  g <- ggplot(data.frame(x=stan_sampling_res$r[i,]), aes(x=x, y=..density..)) +
    geom_histogram(binwidth = 0.5) +
    geom_density(fill="blue", alpha=0.2, bw=2) +
    xlab(cat('r[',i,']',sep='')) +
    xlim(-10, 10)
})

gridExtra::grid.arrange(g_r_list[[1]],g_r_list[[2]],g_r_list[[3]])

# �e�̂��Ƃ�y�̗\���l�̒����l���Ƃ�
## ����Ă��邱�ƁF

### �eiteration�ɂ�����y�̌��ʂ��ey���ƂɃJ�E���g
### �J�E���g���ʂ��������Ĉ�̃f�[�^�t���[���ɂ���
### �ey�̃J�E���g�̒����l�A2.5%qautile, 97.5%quntile���o��
y_hat_df <- lapply(seq(1000), function(x){
  count_tmp <- data.frame(y = stan_sampling_res$yhat[x,]) %>%
    group_by(y) %>%
    summarize(count = n()) %>%
    select(count) %>%
    t()
  count_tmp <- as.data.frame(count_tmp)
  #colnames(count_tmp) <- as.character(seq(0,8))
}) %>%
  bind_rows()

y_hat_data <- data.frame(x = seq(0,8),
                         median = apply(y_hat_df, MARGIN = 2, median, na.rm=T),
                         upper = apply(y_hat_df, MARGIN = 2, quantile, probs=c(0.975), na.rm=T),
                         lower = apply(y_hat_df, MARGIN = 2, quantile, probs=c(0.025), na.rm=T))

# plot
## �{���̐}10.4�Ƃقړ������ʂ�����ꂽ
ggplot() +
  geom_ribbon(data=y_hat_data, aes(x=x, ymin=lower, ymax=upper), fill='#000000', alpha=0.3) +
  geom_point(data=data_count, size=5, shape=21, fill='black', aes(x=y, y=count)) +
  geom_line(data=y_hat_data, aes(x=x, y=median)) +
  geom_point(data=y_hat_data, size=5, shape=21, fill="white", aes(x=x, y=median))


# �̍��{�ꏊ���̊K�w�x�C�Y���f���� -------------------------------------------------------

# �ЂƂ܂��v���b�g
ggplot(data=nested, aes(x=pot, y=y)) +
  geom_boxplot(aes(color=f)) +
  geom_segment(x=1,xend=5, y=6.64, yend=6.64, lty='dashed', color='deeppink', size=1) + 
  geom_segment(x=6,xend=10, y=4.4, yend=4.4, lty='dashed', color='skyblue', size=1)

# ���ςƕ��U���m�F
mean(nested[1:50,]$y)    # 6.64
mean(nested[51:100,]$y)  # 4.4
var(nested[1:50,]$y)     # 52.2351
var(nested[51:100,]$y)   # 55.10204

## ��q�����|�A�\�����z�ɏ]���Ƃ���Ɩ��炩�ɉߕ��U�ł���
## �܂������̂΂�����傫��
### �{���̃f�[�^�͈ȉ��̏����Ő�������Ă���
### �ؕ�1, �{����ʂ̌W��0
### �̍��̕W���΍�1, �����̕W���΍�1
### �ؕЂ̕��ς����傫�߂Ɍ��ς����Ă���悤�ɂ������邪�Astan�Ŕ�r�I�ǂ����肳��Ă���

# stan�ɓn���f�[�^�̍쐬
d_list <- list(n_sample = nrow(nested),
               n_pot = max(as.numeric(nested$pot)),
               pot = as.numeric(nested$pot),
               f = as.numeric(nested$f)-1,
               y = nested$y)

# stan���s
stan_model <- stan(file = '../chapter10_2.stan',
                   data = d_list,
                   chain = 4,                # chain �f�t�H���g4
                   iter = 2000)              # �T���v�����O�� �f�t�H���g2000

# ���ʂ̕\��
options(max.print = 10000)
print(stan_model)
## beta_2��95%�M�p��Ԃ�-2.3~0.7�ƁA�{����ʂ��قڂȂ����ʂƂȂ���
## ���̌��ʂ͖{���Ƃ���v����

traceplot(stan_model, pars = c('beta_1', 'beta_2', 's', 'sp'))

## extract�ŃT���v�����O���ʂ𒊏o
stan_sampling_res <- extract(stan_model)

## beta
g_beta_1 <- ggplot(data.frame(x=stan_sampling_res$beta_1), aes(x=x, y=..density..)) +
  geom_histogram(binwidth = 0.05) +
  geom_density(fill="blue", alpha=0.2, bw=0.05) +
  xlab('beta_1')
## beta_2
g_beta_2 <- ggplot(data.frame(x=stan_sampling_res$beta_2), aes(x=x, y=..density..)) +
  geom_histogram(binwidth = 0.05) +
  geom_density(fill="blue", alpha=0.2, bw=0.05) +
  xlab('beta_2')
## s
g_s <- ggplot(data.frame(x=stan_sampling_res$s), aes(x=x, y=..density..)) +
  geom_histogram(binwidth = 0.05) +
  geom_density(fill="blue", alpha=0.2, bw=0.05) +
  xlab('s')
## s
g_sp <- ggplot(data.frame(x=stan_sampling_res$sp), aes(x=x, y=..density..)) +
  geom_histogram(binwidth = 0.05) +
  geom_density(fill="blue", alpha=0.2, bw=0.05) +
  xlab('sp')

gridExtra::grid.arrange(g_beta_1,g_beta_2,g_s,g_sp)

# �e�̂�yhat�̒����l�����߂�
y_hat_vec <- apply(stan_sampling_res$yhat, MARGIN = 2, median)
y_hat_df <- data.frame(nested, yhat=y_hat_vec)

# ����l��}��
ggplot(data=y_hat_df, aes(x=pot, y=y)) +
  geom_boxplot(aes(color=f)) +
  geom_segment(x=1,xend=5, y=6.64, yend=6.64, lty='dashed', color='deeppink', size=1) + 
  geom_segment(x=6,xend=10, y=4.4, yend=4.4, lty='dashed', color='skyblue', size=1)

# �e�����Ƃ�yhat�̕��z�����߂�
y_hat_all <- t(stan_sampling_res$yhat) %>%
  data.frame(.,nested$pot)

y_hat_list <- lapply(levels(nested$pot),function(x){
  vec <- y_hat_all[y_hat_all$nested.pot==x,1:4000] %>% unlist()
  return(data.frame(x=vec))
  })

g_list <- lapply(seq(10), function(i){
  if(i<6){
    fill_color <- 'deeppink'
  }else{
    fill_color <- 'skyblue'
  }
  ggplot(y_hat_list[[i]], aes(x=x, y=..density..)) +
    geom_histogram(binwidth = 1, fill=fill_color) +
    xlim(0,70) +
    xlab(paste('pot',i)) +
    coord_flip()
})

gridExtra::grid.arrange(grobs=g_list, ncol=10)