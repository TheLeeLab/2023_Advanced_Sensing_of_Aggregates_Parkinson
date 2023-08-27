function [coincidence_rate,BW] = coincidence(masks,refChannel)
% find colocalization between two binark masks
% input  : masks, 3D matrix with 2 masks
%          refChannel, the channel on the denominator (compare with which)
% 
% output : coincidence_rate, the proportion of the objects in the ref mask that are colocalized
%          BW, the colocalized object on the ref mask
% 
% author : Bin Fu, Univerisity of Cambridge, bf341@cam.ac.uk

    m1 = masks(:,:,1);
    m2 = masks(:,:,2);
    coincidence_mask = m1&m2;
    ref_mask = masks(:,:,refChannel);
    regions  = bwconncomp(ref_mask,8).PixelIdxList; %return the indices of objects from all overlapping regions between two compared channels

    if ~isempty(regions) %if there is a overlapping
        sumREF = zeros(length(regions),1); sumAND = sumREF;
        for j = 1:length(regions)
            sumREF(j) = sum(ref_mask(regions{j})); %how many individual objects are in the ref channel
            sumAND(j) = sum(coincidence_mask(regions{j})); %how many overlapped objects
        end
        overlap = sumAND./sumREF; %overlap ratio for each objects in the ref channel
        coincidence_rate = length(find(overlap>0.1))/length(regions); %any overlapped objects with more than 10% overlapping ratio will be considered 

        idx = find(overlap<=0.1);
        BW  = core.fillRegions(masks(:,:,refChannel),idx);
    else 
        BW  = false(size(masks(:,:,refChannel)));
        coincidence_rate = 0;
    end
end