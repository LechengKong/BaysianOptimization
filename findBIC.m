function [bic] = findBIC(X, Y, meanfunc, covfunc, likfunc, hyp)
%UNTITLED3 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
hyp2 = minimize(hyp, @gp, -100, @infGaussLik, meanfunc, covfunc, likfunc, X, Y);
[lk_d, ~] = gp(hyp2, @infExact, meanfunc, covfunc, likfunc, X, Y);
bic = (numel(hyp.cov)+numel(hyp.mean))*log(size(X,1))+2*lk_d;
end

