clear all, close all
x1 = linspace(-5,10,1000);
x2 = linspace(0,15,1000);
[X1,X2] = meshgrid(x1,x2);
axis_x1 = [-5 10];
axis_x2 = [0 15];
figure
bra = branin(cat(3,X1,X2));
hold on
imagesc(axis_x1, axis_x2, bra);
colorbar
hold off
figure
bra = log(bra);
hold on
imagesc(axis_x1, axis_x2, bra);
colorbar
hold off

