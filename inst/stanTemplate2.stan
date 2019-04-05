data{
  int<lower=1> nPer;
  int<lower=1> nTime[nPer];
  int<lower=1> maxTime;
  int<lower=1> nPreds;
  matrix[maxTime,nPreds] X[nPer];
  int<lower=0,upper=1> Y[nPer,maxTime];
  matrix[nPer,maxTime] Y;
}

parameters{
  <parameters>
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

    if ("<family>" == "binomial") {
    L[i,1:nTime[i]] ~  multi_normal_cholesky(mu[i,1:nTime[i]], cholSigma[i,1:nTime[i],1:nTime[i]]);
    Y[i,1:nTime[i]] ~ bernoulli_logit(L[i,1:nTime[i]]);
    } else {
      Y[i,1:nTime[i]] ~  multi_normal_cholesky(mu[i,1:nTime[i]], cholSigma[i,1:nTime[i],1:nTime[i]]);
    }

  }
}
