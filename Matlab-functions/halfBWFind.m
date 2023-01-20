function [pks,pk_f,hbwMag,hbwFreqIntersects,eta_loss] = halfBWFind(data, freq,minPeak,nPeak)
    %halfBWFind Finds peaks and the half power bandwidth and loss factor of
    %the given data.
    %Removes infinite values (zero peak)

    [pks,locs] = findpeaks(data,'MinPeakProminence',minPeak,'NPeaks',nPeak);
    %Level of halfbandwidth
    hbwMag = pks -3;
    %Loop through the peaks and calculate intersections
    for i = length(pks):-1:1
        pk_f(i) = freq(locs(i)); %Freqency at which peaks occur
        %Split the data at the peak
        dataLeft = flip(data(1:locs(i)));
        dataRight = data(locs(i):end);
        %Find intersection by using zero-crossing function
        zci = @(v) find(v(:).*circshift(v(:), [-1 0]) <= 0);                    % Returns Zero-Crossing Indices Of Argument Vector
        zxL = zci(dataLeft-hbwMag(i)); 
        zxR = zci(dataRight-hbwMag(i)); 
        
        if hbwMag(i) ~= inf
        if mean(diff(freq))==diff(freq(1:2))
            dF = diff(freq(1:2));
            %Linear interpolation between two datapoints to find x values
            %of intersection       
            zxL_int = -((hbwMag(i)-dataLeft(zxL(1)))/(dataLeft(zxL(1)+1)-dataLeft(zxL(1))))*dF + (freq(locs(i)-(zxL(1)-1)));     %Min X value
            zxR_int = ((hbwMag(i)-dataRight(zxR(1)))/(dataRight(zxR(1)+1)-dataRight(zxR(1))))*dF  + (freq(locs(i)+(zxR(1)-1)));  %Max X value
        else %Irregularly spaced data
            %Calculate the irregular step size case by case.
            dF_L = (freq(locs(i)-zxL(1)+1)) - (freq(locs(i)-zxL(1)));
            dF_R = (freq(locs(i)+zxR(1))) - (freq(locs(i)+zxR(1)-1));
            %Linear interpolation between two datapoints to find x values
            %of intersection.
            zxL_int = -((hbwMag(i)-dataLeft(zxL(1)))/(dataLeft(zxL(1)+1)-dataLeft(zxL(1))))*dF_L + (freq(locs(i)-(zxL(1)-1)));     %Min X value
            zxR_int = ((hbwMag(i)-dataRight(zxR(1)))/(dataRight(zxR(1)+1)-dataRight(zxR(1))))*dF_R  + (freq(locs(i)+(zxR(1)-1)));  %Max X value
         end
        else
            %Set all to zero if inf point (maybe use NaN in future)
            zxL_int = 0;
            zxR_int = 0;
            hbwMag(i) = 0;
            pks(i) = 0;
            pk_f(i) = 0;
        end
        %Set the intersects in matrix for output
        hbwFreqIntersects(i,:) = [zxL_int, zxR_int];
    end
    %Remove zero values
    l = length(nonzeros(hbwFreqIntersects));
        hbwFreqIntersects = hbwFreqIntersects(hbwFreqIntersects~=0)';
        hbwFreqIntersects = reshape(hbwFreqIntersects,[l/2,2]);
        hbwMag = hbwMag(hbwMag~=0)';
        hbwMag = reshape(hbwMag,[l/2,1]);
        pks = pks(pks~=0)';
        pks = reshape(pks,[l/2,1]);
        pk_f = pk_f(pk_f~=0)';
        pk_f = reshape(pk_f,[l/2,1]);
    %Calculate loss factor
        eta_loss = (hbwFreqIntersects(:,1)-hbwFreqIntersects(:,2))./pks(:);
end
