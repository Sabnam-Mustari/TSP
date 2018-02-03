%%% Use inhibtWeight = -2.0, threshold = 20 for 6 cities and maxDistance = 1.
nCities = 6;
threshold = 20;
nStops = nCities;
%%% Each input/output unit represents a combination of a particular city
%%% at a particular stop on the tour.
nInputs = nCities * nStops;
inhibWeight = -2.0;
offState = -1; %%% Binary threshold function should return a 1 or a -1.
inputWidth = nCities; %%% for plotting
initialActivations = ones(nInputs,1) * -1;
activations = initialActivations;

%%% Assign x,y coordinates to each city; then calculate distances.

cityLocations = zeros(nCities,2);
cityLocations(1,:) = [0.9 0.5];
cityLocations(2,:) = [0.6 0.9];
cityLocations(3,:) = [0.2 0.7];
cityLocations(4,:) = [0.1 0.2];
cityLocations(5,:) = [0.4 0.4];
cityLocations(6,:) = [0.7 0.1];

% cityLocations(1,:) = [0 3];
% cityLocations(2,:) = [1 5];
% cityLocations(3,:) = [4 5];
% cityLocations(4,:) = [5 2];
% cityLocations(5,:) = [4 0];
% cityLocations(6,:) = [1 0];

%%% Calculate distances between all pairs of cities.

distances = zeros(nCities,nCities);
for city1 = 1:nCities,
  for city2 = 1:nCities,
    difference = cityLocations(city1,:) - cityLocations(city2,:);
    distances(city1,city2) = sqrt(difference(1,1)  * difference(1,1) + ...
                                difference(1,2)  * difference(1,2));
  end
end
%% Normalize distances so that max distance is 1.0;
distances = distances / max(max(abs(distances)));

%%% Calculate weights;

weights = zeros(nInputs,nInputs);
for city1 = 1:nCities,
  for stop1 = 1:nStops,
    for city2 = 1:nCities,
      for stop2 = 1:nStops,
        %%% Constraint I: For a valid tour, the same city should 
        %%% not appear at two different stops. 
        %%% Make large inhibitory weight.
        if ((city1 == city2) & (stop1 ~= stop2))
          weights = setWeight(city1,stop1,city2,stop2, ...
                     inhibWeight,weights,nCities);
        %%% Constraint II: For a valid tour, there shoulud not 
        %%% be two different cities at the same stop on the tour.
        %%% Make large inhibitory weight.
        elseif ((stop1 == stop2) & (city1 ~= city2))
          weights = setWeight(city1,stop1,city2,stop2, ...
                     inhibWeight,weights,nCities);
        %%% Constraint III: For a shortest path tour, cities at 
        %%% adjacent stops on the tour should be a short distance
        %%% apart. Make weight equal to negative of the distance.
        elseif (city1 ~= city2) & (stop1 ~= stop2) & (abs(stop1 - stop2) == 1)
          weights = setWeight(city1,stop1,city2,stop2, ...
                     -distances(city1,city2),weights,nCities);
        end
      end
    end
  end
end


