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
X = [x1,x2];
%% Func config
meanfuncs = {{@meanConst}}; mean_param = {5};
covfuncs = {{@covSEiso},{@covRQiso}};   cov_param = {log([1.3;1]),log([1.3,1,5])};
likfunc = @likGauss; sn = 0.001; hyp.lik = log(sn);
for i = 1:1
    for j = 1:2
        hyp.mean = mean_param{i};
        hyp.cov = cov_param{j};
        disp(findBIC(X,Y,meanfuncs{i},covfuncs{j},likfunc,hyp));
    end
end