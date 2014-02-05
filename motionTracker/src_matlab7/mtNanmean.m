function y = nanmeanMT(x);

[nx, mx]=size(x);
FLIP = 0;

if mx > nx,
    x = x';
    [nx, mx]=size(x);
    FLIP = 1;    
end

if mx == 1,
    iGood = find( ~isnan(x) );
else,
    iGood = find( any(~isnan(x), 2));;
end 

y = mean( x(iGood,:));

if FLIP == 1,
    y = y';
end
