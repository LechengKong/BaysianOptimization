clear all, close all
rng('default')
p = sobolset(2,'Skip',1e3,'Leap',1e2);
p = scramble(p,'MatousekAffineOwen');
X = net(p,32);
x1 = X(:,1)*15-5;
x2 = X(:,2)*15;
X = cat(3,x1,x2);
Y = log(branin(X));
%[f,xi] = ksdensity(Y);
%plot(xi,f);
%%
X = [x1,x2];
meanfunc = {@meanConst}; hyp.mean = 100;
%hyp = [ log(len scale)
%          log(sig std)  ]
covfunc = {@covSEiso};   hyp.cov = log([1.3;5]);
likfunc = @likGauss; sn = 0.001; hyp.lik = log(sn);
[nlZ,dnlZ] = gp(hyp, @infExact, meanfunc, covfunc, likfunc, X, Y);
hyp2 = minimize(hyp, @gp, -100, @infGaussLik, meanfunc, covfunc, likfunc, X, Y);
disp(hyp2)
%%
t1 = linspace(-5,10,1000);
t2 = linspace(0,15,1000);
[T1,T2] = meshgrid(t1,t2);
bra = log(branin(cat(3,T1,T2)));
T = [reshape(T1,[],1),reshape(T2,[],1)];
[ymu, ys2, fmu, fs2] = gp(hyp2, @infExact, meanfunc, covfunc, likfunc,...
    X, Y, T);
mean_post = reshape(ymu, 1000, 1000);
std_post = sqrt(reshape(ys2, 1000, 1000));
%%
figure
hold on
axis_x1 = [-5 10];
axis_x2 = [0 15];
imagesc(axis_x1,axis_x2,mean_post);
colorbar
scatter(x1, x2, 15, 'r','filled');
hold off
figure
hold on
imagesc(axis_x1,axis_x2,std_post);
colorbar
scatter(x1, x2, 15, 'r','filled');
hold off
%%
residual = reshape((bra-mean_post),[],1);
res_mean = mean(residual);
res_std = std(residual);
[resid,x_res] = ksdensity((residual-res_mean)/res_std);
figure
plot(x_res,resid);
%%
[lk_d, d] = gp(hyp2, @infExact, meanfunc, covfunc, likfunc, X, Y);
bic = 3*log(32)-2*lk_d;
disp(bic)