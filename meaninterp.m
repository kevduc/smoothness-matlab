function y = meaninterp(x)
    y = [x; (x(1:end-1) + x(2:end))/2, 0];
    y = y(1:end-1);
end
    