% ------------------------------------ %
%  MMF - 1914H Information Technology
%  Lujia Yang 1002955563
% ------------------------------------ %

% Part1 Question5
% Instead of copying and pasting the same code several times, 
% using helper function "yrLogreturn" to 
% creating the histogram, calculating mean and std for log return each
% year for each securities.
% BMO annual log return
[bmo_m1,bmo_std1] = yrLogreturn(BMO,"2007","BMO");
[bmo_m2,bmo_std2] = yrLogreturn(BMO,"2008","BMO");
[bmo_m3,bmo_std3] = yrLogreturn(BMO,"2009","BMO");
[bmo_m4,bmo_std4] = yrLogreturn(BMO,"2010","BMO");

disp('BMO log return - mean and standard deviations')
Year = {'2007';'2008';'2009';'2010'};
Mean = [bmo_m1;bmo_m2;bmo_m3;bmo_m4];
Std = [bmo_std1;bmo_std2;bmo_std3;bmo_std4];
table(Mean, Std,'RowNames',Year)

% GS annual log return
[gs_m1,gs_std1] = yrLogreturn(GS,"2007","GS");
[gs_m2,gs_std2] = yrLogreturn(GS,"2008","GS");
[gs_m3,gs_std3] = yrLogreturn(GS,"2009","GS");
[gs_m4,gs_std4] = yrLogreturn(GS,"2010","GS");

disp('GS log return - mean and standard deviations')
Year = {'2007';'2008';'2009';'2010'};
Mean = [gs_m1;gs_m2;gs_m3;gs_m4];
Std = [gs_std1;gs_std2;gs_std3;gs_std4];
table(Mean, Std,'RowNames',Year)


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