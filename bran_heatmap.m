x1 = linspace(-5,10,1000);
x2 = linspace(0,15,1000);
[X1,X2] = meshgrid(x1,x2);
bra = branin(cat(3,X1,X2));
bra = log(bra);
h = heatmap(bra,'GridVisible','off');