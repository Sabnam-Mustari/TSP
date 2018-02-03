%%% forward pass for hopfield program
stable = 0;
order = scramble([1:nInputs]');
somebodyChanged = 0;
for i = 1:nInputs,
    unit = order(i,1);
    oldActivation = activations(unit,1);
    netIn = weights(unit,:) * activations;
    if netIn >= threshold
      activations(unit,1) = 1;
    else 
      activations(unit,1) = offState;
    end
    if oldActivation ~= activations(unit,1)
      somebodyChanged = 1;
    end
end
if somebodyChanged == 0
    stable = 1;
end

%%  Read activations vector (a column vector) into a 2d matrix for plotting.
%%% The output units' activations in the activations vector are
%   ordered as follows:  
%%% activations = ...
%%% [City1Stop1, City2Stop1, ..., CityN,Stop1, City1Stop2, City2Stop2, ..., ]';
%%% After reshaping, we get a 2D matrix like this:
%%% activationGrid = ...
%%% [   City1Stop1,  City1Stop2, City1Stop3, ..., City1StopN;
%%%     City2Stop1,  City2Stop2, City2Stop3, ... City2StopN;
%%%     ...
%%%     CityNStop1, CityNStop2, CityNStop3, ...  CityNStopN]    
%%% Add an extra column of zeros at the right and an extra
%%% row of zeros at the bottom, because pcolor does not plot
%%% the very last row and column. SO now we will have
%%% activationGrid = ...
%%% [   City1Stop1,  City1Stop2, City1Stop3, ..., City1StopN,  0 ;
%%%     City2Stop1,  City2Stop2, City2Stop3, ... City2StopN,   0 ;
%%%     ...
%%%     CityNStop1, CityNStop2, CityNStop3, ...  CityNStopN,   0; 
%%%      0        , 0         , 0         , ...   0        ,   0]
n = inputWidth;
activationGrid = zeros(n+1,n+1);
activationGrid(1:n,1:n) = reshape(activations,n,n);
%% plot the activations as a grid


figure(1); %%% Plot the matrix of activations. Red is on, blue is off.
pcolor(activationGrid);
xlabel('Stop')
ylabel('City')
set(gca,'XTick',[1:nStops]);
set(gca,'YTick',[1:nCities]);

figure(2);  %%% Plot the activations as a tour through the cities.
clf; hold on;
maxX = max(cityLocations(:,1)) + 1;
maxY = max(cityLocations(:,2)) + 1;
minX = min(cityLocations(:,1)) - 1;
minY = min(cityLocations(:,2)) - 1;
plot(cityLocations(:,1),cityLocations(:,2),'o');
axis([minX maxX minY maxY]);
tour = zeros(nCities * nStops,2);
stopNum = 1;
for stop = 1:nStops,
  for city = 1:nCities,
    if activationGrid(city,stop) == 1
       tour(stopNum,:) = cityLocations(city,:);
       stopNum = stopNum + 1;
    end
  end
end
numStops = stopNum -1;
plot(tour(:,1),tour(:,2));

for city = 1:nCities,
   cityName = sprintf('City %d',city);
   text(cityLocations(city,1),cityLocations(city,2),cityName);
end

stdout = 1;
if stable == 1
  fprintf(stdout,'\nconverged\n');
end
