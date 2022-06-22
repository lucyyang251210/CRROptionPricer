% ------------------------------------ %
%  MMF - 1914H Information Technology
%  Lujia Yang 1002955563
% ------------------------------------ %

% Part1 Question3
%BMO time series;
bmodate = table2array(BMO(:,1));
bmoClose=table2array(BMO(:,5));

%GS time series;
gsdate = table2array(GS(:,1));
gsClose=table2array(GS(:,5));

%Time series plot
subplot(2,1,1)
plot(bmodate,bmoClose)
title ("BMO Closing Price 2007-2011");
datetick('x','yyyy-mm-dd')

subplot(2,1,2)
plot(gsdate,gsClose)
title ("GS Closing Price 2007-2011");
datetick('x','yyyy-mm-dd')