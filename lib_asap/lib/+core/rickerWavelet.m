function h = rickerWavelet(sigma)
% kernel for strengthen blob features within an image
% input  : sigma, wavelet width
% 
% output : h, output kernel
% 
% author : Bin Fu, Univerisity of Cambridge, bf341@cam.ac.uk

    amplitude = 2 / (sqrt(3*max(sigma)) * pi^(1/4)); 
    switch length(sigma)
        case 1 %1D 
            x           = (0:8*sigma(1)) - 4*sigma(1);
            common_term = x.^2/(2.*sigma(1).^2);
        case 2 %2D
            x           = (0:8*sigma(2)) - 4*sigma(2);
            y           = (0:8*sigma(1)) - 4*sigma(1);
            [X,Y]       = meshgrid(x,y);
%             common_term = (X.^2 + Y.^2)/(2.*sigma(1).^2);
            common_term = (X.^2/(2.*sigma(2).^2)) + (Y.^2/(2.*sigma(1).^2));
        case 3 %3D
            x           = (0:8*sigma(2)) - 4*sigma(2);
            y           = (0:8*sigma(1)) - 4*sigma(1);
            z           = (0:8*sigma(3)) - 4*sigma(3);
            [X,Y,Z]     = meshgrid(x,y,z);
            common_term = (X.^2/(2.*sigma(2).^2)) + (Y.^2/(2.*sigma(1).^2)) + (Z.^2/(2.*sigma(3).^2));
        otherwise
            error('kernel dimension not supported');
    end 
    h         = amplitude*(1-common_term).*exp(-common_term); %rickerWavelet kernel, also called Laplacian of Gaussian kernel
end