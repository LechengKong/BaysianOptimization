function [] = showDist(tableName)
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
T = table2array(readtable(tableName));
Y = T(:,4);
[f,xi] = ksdensity(Y);
plot(xi,log(f));
end

