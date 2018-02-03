%% weights is a matrix with each row representing the 
%% incoming weights of a different unit. 
%% The rows and columns in the weight matrix correspond to input/output units 
%%  in the following order: 
%% city1-stop1, city2-stop1, ... , cityN-stop1, city1-stop2, city2-stop2,..., 
%%% cityN-stop2,  ... , city1-stopN, city2-stopN, ... , cityN-stopN
%%
%% This function changes the value of a single weight in 
%% the matrix to have the value 'wt'. It also sets the value of the
%% symmetric weight.
function [weights] = setWeight(city1,stop1,city2,stop2,wt,weights,nCities)
  unit1 = (stop1 - 1) * nCities + city1;
  unit2 = (stop2 - 1) * nCities + city2;
  weights(unit1,unit2) = wt;
  weights(unit2,unit1) = wt;

