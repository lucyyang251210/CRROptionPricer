% ------------------------------------ %
%  MMF - 1914H Information Technology
%  Lujia Yang 1002955563
% ------------------------------------ %

% Part1 Question4
% Instead of copying and pasting the same code several times, 
% using helper function "yrLogreturn" to 
% creating the histogram, calculating mean and std for log return each
% year for each securities.

% BMO annual log return
subplot(2,2,1)
[bmo_m1,bmo_std1] = yrLogreturn(BMO,"2007","BMO");
subplot(2,2,2)
[bmo_m2,bmo_std2] = yrLogreturn(BMO,"2008","BMO");
subplot(2,2,3)
[bmo_m3,bmo_std3] = yrLogreturn(BMO,"2009","BMO");
subplot(2,2,4)
[bmo_m4,bmo_std4] = yrLogreturn(BMO,"2010","BMO");

% GS annual log return
subplot(2,2,1)
[gs_m1,gs_std1] = yrLogreturn(GS,"2007","GS");
subplot(2,2,2)
[gs_m2,gs_std2] = yrLogreturn(GS,"2008","GS");
subplot(2,2,3)
[gs_m3,gs_std3] = yrLogreturn(GS,"2009","GS");
subplot(2,2,4)
[gs_m4,gs_std4] = yrLogreturn(GS,"2010","GS");


% related function - yrLogreturn

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
plot(x, ny)
%plot(x, ny/max(ny));
hold off


end