function [] = showDist(tableName)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
T = table2array(readtable(tableName));
Y = T(:,4);
[f,xi] = ksdensity(Y);
plot(xi,log(f));
end

