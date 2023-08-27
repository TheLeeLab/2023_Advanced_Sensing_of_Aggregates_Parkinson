function [] = plotBinaryMask(f,BW,colour)
% input  : f, the figure where the mask should be
%          BW, the mask for adding to the image
%          colour, the mask colour
    if nargin < 3
        colour = [0.8500 0.3250 0.0980];
    end
    figure(f); hold on
    [labelBW,numObj] = bwlabel(BW);
    boundaries = bwboundaries(BW, 'noholes');
    for j = 1:numObj
        b = boundaries{j};
        plot(b(:,2),b(:,1),'r','linewidth',1.5,'Color',colour); %Plot boundary

        % ind = find(labelBW==j);
        % [m,n] = ind2sub(size(BW), ind);
        % text(mean(n),mean(m),['\color{white} ' num2str(j)], 'FontSize', 10,'fontweight','bold') %Plot number
    end
end