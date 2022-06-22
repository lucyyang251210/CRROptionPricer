function [meanLogreturn, stdLogreturn] = yrLogreturn (Data,Year,Securities)
Date = table2array(Data(:,1));
filter = Date >= ("jan 1, "+ Year) & Date <=  ("Dec 31, "+ Year);
Closeprice = table2array(Data(filter,5));
logreturn = diff(log(Closeprice)); % date in the dataset is in ascending order

[nn xx] = hist(logreturn, 30);
bar(xx, nn);
%bar(xx, nn/max(nn));
title (Securities +" log return "+ Year);
x = -0.03: 0.01:0.06;

meanLogreturn = mean(logreturn);
stdLogreturn = std(logreturn);
ny = normpdf(x,meanLogreturn,stdLogreturn);
hold on
plot(x, ny);
hold off


end
