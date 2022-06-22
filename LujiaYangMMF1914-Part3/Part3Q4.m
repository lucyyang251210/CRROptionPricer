% ------------------------------------ %
%  MMF - 1914H Information Technology
%  Lujia Yang 1002955563
%  Part3 Question4
% ------------------------------------ %

% Part3 Question4 - Vector Version
%[optionPrice delta gamma theta] = P3Q4_CRROptionPricer(currStockPrice, strikePrice, intRate, 
%                                   divYield, vol, totSteps, yearsToExp, optionType, american)

% initials
%tStart = tic;
steps = [20:20:1000];
n = length(steps);

ElapsedTime= zeros(1,n);
diff = zeros(1,n);
Price = zeros(1,n);
% American Call, current stock price = 100; strick = 105; 
% risk free rate = 0.02; dividend = 0.01
% volatility = 0.2; years to expiry = 1

for i = 1:n
    totSteps = steps(i);
    tic
    [P D G T] = P3Q4_CRROptionPricer(100, 105, 0.02, 0.01, 0.2, totSteps, 1, "CALL", 1);
    ElapsedTime(i)=toc;
    Price(i) = P;
    if i == 1
        diff (i) = 0;
    else
        diff (i) = Price(i)-Price(i-1);
    end 
end 


% Part3 Question4 - loops Version

ElapsedTimeLoop= zeros(1,n);
diffLoop = zeros(1,n);
PriceLoop = zeros(1,n);
% American Call, current stock price = 100; strick = 105; 
% risk free rate = 0.02; dividend = 0.01
% volatility = 0.2; years to expiry = 1

for i = 1:n
    totSteps = steps(i);
    tic
    P = P3Q4_CRROptionPricerForLoops(100, 105, 0.02, 0.01, 0.2, totSteps, 1, "CALL", 1);
    ElapsedTimeLoop(i)=toc;
    PriceLoop(i) = P;
    if i == 1
        diffLoop (i) = 0;
    else
        diffLoop (i) = PriceLoop(i)-PriceLoop(i-1);
    end 
end 


% plot the price against steps, 
% and the difference of prices as total steps increase
subplot(3,2,1)
plot(steps,Price,'LineWidth',2)
title ("Price vs. steps");

subplot(3,2,3)
plot(steps,diff,"b",'LineWidth',2)
title ("Difference vs. steps");
hold on
yline(0.01,"r",'LineWidth',2);

subplot(3,2,5)
plot(steps, ElapsedTime, 'LineWidth',2);
title ("Elapsed Time vs. steps");

subplot(3,2,2)
plot(steps,PriceLoop,'LineWidth',2)
title ("Price (loop) vs. steps");

subplot(3,2,4)
plot(steps,diffLoop,"b",'LineWidth',2)
title ("Difference (loop) vs. steps");
hold on
yline(0.01,"r",'LineWidth',2);

subplot(3,2,6)
plot(steps, ElapsedTimeLoop,'LineWidth',2);
title ("Elapsed Time (loop) vs. steps");


%plot elapsed times for the vector version and the for loops version
plot(steps, ElapsedTime, steps, ElapsedTimeLoop,'LineWidth',3);
lgd = legend("Vector version","Loops version");
lgd.FontSize = 14;
title ("Elapsed Time vector vs. loop");






