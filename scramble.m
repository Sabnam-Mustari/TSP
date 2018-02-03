%%% return the original column vector with its elements rearranged 
%%% in random order . note that RANDPERM is available as a built-in
%%% function in matlab versions 5 and higher that will do what scramble does.
function [vector] = scramble (vector)
  nPoints = size(vector,1);
  for i = 1:nPoints,
    j = round(rand(1,1) * (nPoints-1)) + 1;
    temp = vector(i,1);
    vector(i,1) = vector(j,1); 
    vector(j,1) = temp;
  end

