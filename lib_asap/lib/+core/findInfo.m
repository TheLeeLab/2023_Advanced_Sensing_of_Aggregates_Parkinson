function result_oligomer = findInfo(BW,zimg,j)
% find number of diffraction-limited and non-diffraction-limited aggregates, intensity and background of diffraction-limited objects
% input  : BW, binary mask
%          zimg, the processed image stack
%          j, the current loop number
% 
% output : result_oligomer, result per oligomer
%          result_slice, result per slice
% 
% author : Bin Fu, Univerisity of Cambridge, bf341@cam.ac.uk

    [sigImage,bgImage] = core.extractBg(imdilate(BW,strel('disk',2)),zimg); %pure signal and pure background
    result_oligomer    = regionprops('table',BW,sigImage,'centroid','MeanIntensity','Area');
    result_bg = regionprops('table',BW,bgImage,'MeanIntensity');
    result_bg = result_bg.MeanIntensity;

    if ~isempty(result_oligomer) %if there is at least one oligomer in the FoV
        sumintensity    = 2*result_oligomer.MeanIntensity.*result_oligomer.Area; %total intensity per oligomer in long format, 2x from calibration between gaussian and flood fill intensity finding calibration
        tmpt = array2table([repmat(j,size(result_oligomer,1),1),sumintensity,result_bg],'VariableNames', {'z','SumIntensity','bg'}); % add extra columns to the table
        result_oligomer = [result_oligomer(:,2),tmpt]; %concat data into the long format
    else
        result_oligomer = array2table([0 0 0 0 0 0 j]);
        result_oligomer = mergevars(result_oligomer,[2,3]);
        result_oligomer = renamevars(result_oligomer,1:6,{'Centroid','SumIntensity','bg','z'});
    end
end