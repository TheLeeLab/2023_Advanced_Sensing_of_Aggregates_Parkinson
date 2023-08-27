function BW = threshold(img,c)
% convert a double matrix to the logical matrix
% input  : img, 2D matrix
%          c, config
%          
% output : BW, binark mask after thresholding
% 
% author : Bin Fu, Univerisity of Cambridge, bf341@cam.ac.uk

    method = c.thres_method; %percentage or ostu
    switch method
        case 'otsu' %otsu's thresholding
            level = multithresh(img,c.ostu_num);
            BW    = logical(imquantize(img,level)-1);
        case 'percentage' %only keep the top nth percent intensity of the image
            thres    = c.percent;
            img      = uint16(img);
            num_bins = 2^16;
            counts   = imhist(img,num_bins);
            p        = counts / sum(counts);
            omega    = cumsum(p);
            
            idx      = find(omega>thres);
            t        = (idx(1) - 1) / (num_bins - 1);
            BW       = img > t*num_bins;
        otherwise
            error('not supported method');
    end
end