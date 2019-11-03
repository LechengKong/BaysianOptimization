clear all, close all
rng('default')
p = sobolset(2,'Skip',1e3,'Leap',1e2);
p = scramble(p,'MatousekAffineOwen');
X = net(p,32);
x1 = X(:,1)*15-5;
x2 = X(:,2)*15;
X = cat(3,x1,x2);
Y = branin(X);
[f,xi] = ksdensity(Y);
plot(xi,f);
%%
X = [x1,x2];
meanfunc = {@meanConst}; hyp.mean = 1;
covfunc = {@covSEiso};   hyp.cov = log([1;1]);
likfunc = @likGauss; sn = 0.001; hyp.lik = log(sn);
disp(hyp)
nlml = gp(hyp, @infExact, meanfunc, covfunc, likfunc, X, Y);