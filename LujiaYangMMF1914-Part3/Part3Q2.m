% ------------------------------------ %
%  MMF - 1914H Information Technology
%  Lujia Yang 1002955563
% ------------------------------------ %

% Part3 Question2 Testing

% Euro Barrier Call
[P1 D1 G1 T1] = P3Q2_CRROptionPricer(20, 20, 0.05, 0, 0.2, 10, 1, "Euro Barrier Call", 25); % initail test
[P2 D2 G2 T2] = P3Q2_CRROptionPricer(20, 20, 0.05, 0, 0.2, 100, 1, "Euro Barrier Call", 30); % change total steps and barrier
[P3 D3 G3 T3] = P3Q2_CRROptionPricer(20, 15, 0.05, 0, 0.2, 100, 1, "Euro Barrier Call", 25); % change total steps and strike
[P4 D4 G4 T4] = P3Q2_CRROptionPricer(20, 20, 0.05, 0, 0.2, 10, 1, "Euro Barrier Call", 15); % test when barrier < strike
[P5 D5 G5 T5] = P3Q2_CRROptionPricer(20, 20, 0.05, 0, 0.2, 10, 1, "Euro Barrier Call", 20); % test when barrier = strike

disp('Euro Barrier Call')
Price = [P1;P2;P3;P4;P5];
Delta = [D1;D2;D3;D4;D5];
Gamma = [G1;G2;G3;G4;G5];
Theta = [T1;T2;T3;T4;T5];
table(Price, Delta, Gamma, Theta)

% Euro Barrier Put
[P1 D1 G1 T1] = P3Q2_CRROptionPricer(30, 30, 0.05, 0, 0.2, 10, 1, "Euro Barrier Put", 15); % initail test
[P2 D2 G2 T2] = P3Q2_CRROptionPricer(30, 30, 0.05, 0, 0.2, 100, 1, "Euro Barrier Put", 10); % change total steps and barrier
[P3 D3 G3 T3] = P3Q2_CRROptionPricer(30, 25, 0.05, 0, 0.2, 100, 1, "Euro Barrier Put", 15); %change total steps and strike
[P4 D4 G4 T4] = P3Q2_CRROptionPricer(30, 30, 0.05, 0, 0.2, 10, 1, "Euro Barrier Put", 35); % test when barrier > strike
[P5 D5 G5 T5] = P3Q2_CRROptionPricer(30, 30, 0.05, 0, 0.2, 10, 1, "Euro Barrier Put", 30); % test when barrier = strike

disp('Euro Barrier Put')
Price = [P1;P2;P3;P4;P5];
Delta = [D1;D2;D3;D4;D5];
Gamma = [G1;G2;G3;G4;G5];
Theta = [T1;T2;T3;T4;T5];
table(Price, Delta, Gamma, Theta)

% related function - P3Q2_CRROptionPricer
function [optionPrice delta gamma theta] = P3Q2_CRROptionPricer(currStockPrice, strikePrice, intRate, divYield, vol, totSteps, yearsToExp, optionType, barrierPrice)
 
  timeStep = yearsToExp / totSteps;

  growthRate = exp(intRate * timeStep);    % one step growth rate

  % one step random walk (price increases)
  u = exp(vol * sqrt(timeStep));
  % one step random walk (price decreases)
  d = exp(-vol * sqrt(timeStep));

  % risk neutral probability of an up move
  pu = (growthRate * exp(-divYield * timeStep) - d) / (u - d);
  % risk neutral probability of a down move
  pd = 1 - pu;
  % Tree is evaluated in two passes
  % In the first pass the probability weighted value of the stock price is calculated at each node
  % In the second pass the value of the option is calculated for each node given the stock price, backwards from the final time step
  % Note that the tree is recombinant, i.e. u+d = d+u

  % First we need an empty matrix big enough to hold all the calculated prices
  priceTree = nan(totSteps + 1, totSteps + 1); % matrix filled with NaN == missing values
  % Note that this tree is approx twice as big as needed because we only need one side of diagonal
  % We use the top diagonal for efficiency

  % Initialize with the current stock price, then loop through all the steps
  priceTree(1, 1) = currStockPrice;
  for ii = 2:(totSteps+1)  % add the endfor now
    % vector calculation of all the up steps (show how the indexing works on line)
    priceTree(1:(ii-1), ii) = priceTree(1:(ii-1), ii-1) * u;

    % The diagonal will hold the series of realizations that is always down
    % this is a scalar calculation
    priceTree(ii, ii) = priceTree((ii-1), (ii-1)) * d;
  end

  % Now we can calculate the value of the option at each node
  % We need a matrix to hold the option values that is the same size as the price tree
  % Note that size returns a vector of dimensions [r, c] which is why it can be passed as dimensions to nan
  optionValueTree = nan(size(priceTree));

  % ----- European Discrete Barrier Option ----------%
  % First we calculate the end value
  switch optionType
    case 'Euro Barrier Call'
       
        if barrierPrice <= strikePrice
            disp ("Error - condition violate");
        end
        bar_index = priceTree(:, end)>barrierPrice;
        optionValueTree(:, end) = max(0, priceTree(:, end) - strikePrice);
        optionValueTree(bar_index, end) = 0;
        
      % note the handy matrix shortcut syntax & max applied elementwise
    case 'Euro Barrier Put'
        if barrierPrice >= strikePrice
            disp ("Error - condition violate");
        end 
        bar_index = priceTree(:, end) < barrierPrice;
        optionValueTree(:, end) = max(0, strikePrice - priceTree(:, end));
        optionValueTree(bar_index, end) = 0;
        
  end
  
  
  % ----- Backwards Induction ----------%
  discountRate = exp(-intRate * timeStep);

  % Now we step backwards to calculate the probability weighted option value at every previous node
  % How many backwards steps?
  backSteps = size(priceTree, 2) - 1;  % notice the size function -> 2 is # of columns
  for ii = backSteps:-1:1  % step backwards by 1, to 1
    optionValueTree(1:ii, ii) = ...   % note line continuation symbol
        discountRate * ...    % present value one time step backSteps
          (pu * optionValueTree(1:ii, ii+1) ...   % probability weighted value of the forward up step
          + pd * optionValueTree(2:(ii+1), ii+1));    % probability weighted value of the forward down step
       
   end


  % After all that, the current price of the option will be in the first element of the optionValueTree
  optionPrice = optionValueTree(1, 1);

  % Delta is the difference between the up and down option prices at the first branch, divided by the price change
  %   Note that time is not held constant in this way
  %     the more steps the more closely the estimate will match "instantaneous"

  delta = D(1,1);

  gamma = (D(1,2) - D(2,2)) / (0.5 * (priceTree(1,3) - priceTree(3, 3)));

  % Note that theta is measured in the underlying units of timeStep, typically years
  theta = (optionValueTree(2, 3) - optionValueTree(1, 1)) / (2 * timeStep);
  theta = theta / 365;

  % handy to create a nested function for delta, which we can use for gamma calculation
  % note that the nested function does not need to be defined before its used, unlike languages like C/C++/Java
      function d = D(x, y)
        d = (optionValueTree(x, y+1) - optionValueTree(x+1, y+1)) / (priceTree(x, y+1) - priceTree(x+1, y+1));
      end
end