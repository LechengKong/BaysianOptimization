function [y] = branin_transform(xx, handle)
y = handle(branin(xx));
end
