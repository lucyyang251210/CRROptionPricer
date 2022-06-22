% ------------------------------------ %
%  MMF - 1914H Information Technology
%  Lujia Yang 1002955563
% ------------------------------------ %

% Part3 Question4 - ForLoop

function optionPrice = P3Q4_CRROptionPricerForLoops (currStockPrice, strikePrice, intRate, divYield, vol, totSteps, yearsToExp, optionType, american)
	% BinomialOptionPricer implements a simple binomial model for option pricing
	%
	% currStockPrice = Current price of the underlying stock
	% strikePrice = Strike price of the option
	% intRate = Annualized continuous compounding interest rate
	% divYield = Annualized continuous compounding dividend yield
	% vol = Expected forward annualized stock price volatility
	% totStep = Depth of the tree model
	% yearsToExp = Time to expiry in years
	% optionType = "CALL" or "PUT"
	% american = true or false, i.e. is early excercise allowed (true = American option, false = European)
	%
	% optionPrice = return value is the calculated price of the option

	% calculate the number of time steps that we require
	timeStep = yearsToExp / totSteps;

	growthRate = exp(intRate * timeStep);    % one step interst rate

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

	% avoid using i and j as variable names 
	%   because they are Matlab primitives for the imaginary part of a complex number

	for ii = 2:(totSteps+1)  % add the endfor now
	  % vector calculation of all the up steps (show how the indexing works on line)
	  for jj = 1:(ii-1)
		priceTree(jj, ii) = priceTree(jj, ii-1) * u;
	  end

	  % The diagonal will hold the series of realizations that is always down
	  % this is a scalar calculation
	  priceTree(ii, ii) = priceTree((ii-1), (ii-1)) * d;
	end

	% Now we can calculate the value of the option at each node
	% We need a matrix to hold the option values that is the same size as the price tree
	% Note that size returns a vector of dimensions [r, c] which is why it can be passed as dimensions to nan
	optionValueTree = nan(size(priceTree));

	% First we calculate the end value
	switch optionType
	  case 'CALL'
		for jj = 1:size(priceTree, 1) % size function -> 1 is # of rows
		  optionValueTree(jj, end) = max(0, priceTree(jj, end) - strikePrice);
		end
		% note the handy matrix shortcut syntax & max applied elementwise
	  case 'PUT'
		for jj = 1:size(priceTree, 1) % size function -> 1 is # of rows
		  optionValueTree(jj, end) = max(0, strikePrice - priceTree(jj, end));
		end
	end

	discountRate = exp(-intRate * timeStep);

	% Now we step backwards to calculate the probability weighted option value at every previous node
	% How many backwards steps?
	backSteps = size(priceTree, 2) - 1;  % notice the size function -> 2 is # of columns
	for ii = backSteps:-1:1  % step backwards by 1, to 1
	  for jj = 1:ii
		optionValueTree(jj, ii) = ...   % note line continuation symbol
		   discountRate * ...    % present value one time step backSteps
			  (pu * optionValueTree(jj, ii+1) ...   % probability weighted value of the forward up step
			  + pd * optionValueTree(jj+1, ii+1));    % probability weighted value of the forward down step
			
		if american    % add the end right away
			% exercise if the value of the option is less than the terminal value
			switch optionType
			  case 'CALL'
				optionValueTree(jj, ii) = max(priceTree(jj, ii) - strikePrice, ...
												optionValueTree(jj, ii));
			  case 'PUT'
				optionValueTree(jj, ii) = max(strikePrice - priceTree(jj, ii), ...
												optionValueTree(jj, ii));
			end
		end
	   end
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
