clear all, close all
rng('default')
trans_fun = @(x)log(x);
p = sobolset(2,'Skip',1e3,'Leap',1e2);
p = scramble(p,'MatousekAffineOwen');
X = net(p,32);
x1 = X(:,1)*15-5;
x2 = X(:,2)*15;
X = cat(3,x1,x2);
Y = branin_transform(X, trans_fun);
%% Training section
X = [x1,x2];
meanfunc = {@meanConst}; hyp.mean = 5;
%hyp = [ log(len scale)
%          log(sig std)  ]
covfunc = {@covSEiso};   hyp.cov = log([1.3;1]);
likfunc = @likGauss; sn = 0.001; hyp.lik = log(sn);
disp(covfunc)
[nlZ,dnlZ] = gp(hyp, @infExact, meanfunc, covfunc, likfunc, X, Y);
hyp2 = minimize(hyp, @gp, -100, @infGaussLik, meanfunc, covfunc, likfunc, X, Y);
disp(hyp2)
%% Prediction
precision = 1000;
test_size = 1000;
t1 = linspace(-5,10,precision);
t2 = linspace(0,15,precision);
[T1,T2] = meshgrid(t1,t2);
j1 = rand(test_size);
j2 = rand(test_size);
jbra = branin_transform(cat(3,j1,j2), trans_fun);
bra = branin_transform(cat(3,T1,T2), trans_fun);
jT = [reshape(j1,[],1),reshape(j2,[],1)];
T = [reshape(T1,[],1),reshape(T2,[],1)];
[ymu, ys2, fmu, fs2] = gp(hyp2, @infExact, meanfunc, covfunc, likfunc,...
    X, Y, T);
[ymuj, ys2j, ~, ~] = gp(hyp2, @infExact, meanfunc, covfunc, likfunc,...
    X, Y, jT);
mean_post = reshape(ymu, precision, precision);
std_post = sqrt(reshape(ys2, precision, precision));
mean_j_post = reshape(ymuj, test_size, test_size);
%% figures
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
figure
hold on
imagesc(axis_x1, axis_x2, bra);
colorbar
hold off
%% estimate
residual = reshape((jbra-mean_j_post),[],1);
res_mean = mean(residual);
res_std = std(residual);
[resid,x_res] = ksdensity((residual-res_mean)/res_std);
figure
plot(x_res,resid);
%% BIC
[lk_d, d] = gp(hyp2, @infExact, meanfunc, covfunc, likfunc, X, Y);
bic = 3*log(32)+2*lk_d;
disp(bic)