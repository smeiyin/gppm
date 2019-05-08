data{
  int<lower=1> nPer;
  int<lower=1> nTime[nPer];
  int<lower=1> maxTime;
  int<lower=1> nPreds;
  matrix[maxTime,nPreds] X[nPer];
  matrix[nPer,maxTime] Y;
  int<lower=0,upper=1> Yclass[nPer,maxTime];
}

transformed data{
  real delta = 1e-9;
}

parameters{
  <parameters>
  matrix[nPer,maxTime] L;
  real a;
}

transformed parameters{
  matrix[nPer,maxTime] mu;
  matrix[maxTime,maxTime] Sigma[nPer];
  matrix[maxTime,maxTime] cholSigma[nPer];
  for (i in 1:nPer){
    for(j in 1:nTime[i]){
          mu[i,j] = <meanfunction>;
      for(k in 1:nTime[i]){
        Sigma[i,j,k] = <covfunction>;
        if (j==k){
          // deal with non-positive-definiteness
          Sigma[i,j,k] = Sigma[i,j,k] + delta;
        }
      }
    }
	if(i==1){
		print(Sigma[1,1:nTime[i],1:nTime[i]]);
	}
    cholSigma[i,1:nTime[i],1:nTime[i]] = cholesky_decompose(Sigma[i,1:nTime[i],1:nTime[i]]);
  }
}

model{
  for (i in 1:nPer){
    // binary response
    if (<family> == 1) {
      L[i,1:nTime[i]] ~  multi_normal_cholesky(mu[i,1:nTime[i]], cholSigma[i,1:nTime[i],1:nTime[i]]);
      // logit link
      if (<link> ==1) {
        for (j in 1:nTime[i]){
          Yclass[i,j] ~ bernoulli_logit(a + L[i,j]);
        }
        // probit link
      } else if (<link> ==0) {
        for (j in 1:nTime[i]){
          Yclass[i,j] ~ bernoulli(Phi(a + L[i,j]));
        }
      }
    // continuous response
    } else {
      Y[i,1:nTime[i]] ~  multi_normal_cholesky(mu[i,1:nTime[i]], cholSigma[i,1:nTime[i],1:nTime[i]]);
    }
  }
}
