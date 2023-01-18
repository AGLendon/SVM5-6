function [pks,locs,hbwMag,hbwFreqIntersects] = halfBWFind(data,minPeak,nPeak)
    %UNTITLED2 Summary of this function goes here
    %   
    [pks,locs] = findpeaks(data,'MinPeakProminence',minPeak,'NPeaks',nPeak);

    hbwMag = pks -3;
    
    for i = length(pks):-1:1
        dataLeft = flip(data(1:locs(i)));
        dataRight = data(locs(i):end);

        zci = @(v) find(v(:).*circshift(v(:), [-1 0]) <= 0);                    % Returns Zero-Crossing Indices Of Argument Vector
        zxL = zci(dataLeft-hbwMag(i)); 
        zxR = zci(dataRight-hbwMag(i)); 
        
        zxL_int = -((hbwMag(i)-dataLeft(zxL(1)))/(dataLeft(zxL(1)+1)-dataLeft(zxL(1)))) + (locs(i)-(zxL(1)-1));     %Min X value
        zxR_int = ((hbwMag(i)-dataRight(zxR(1)))/(dataRight(zxR(1)+1)-dataRight(zxR(1)))) + (locs(i)+(zxR(1)-1));  %Max X value 
        
        hbwFreqIntersects(i,:) = [zxL_int, zxR_int];

    end
end