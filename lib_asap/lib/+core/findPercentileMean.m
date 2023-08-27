function m = findPercentileMean(counts,percentile)
% find mean value from brightest nth pixels in the image
% input  : counts, the 2D image
%          percentile, the percentage for finding the mean value 
% output : m, mean value
% 
% author : Bin Fu, Univerisity of Cambridge, bf341@cam.ac.uk

    counts  = sort(counts(:));
    highend = round(length(counts)*(1-percentile));
    counts  = counts(highend:end);
    m       = mean(counts);
end