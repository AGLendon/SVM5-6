% Analayze my meas data from the SVM Lab 6 on the Laser Doppler Vibrometer

clear variables
close all
clc

%% ===========================================================================
% setup section
% ============================================================================
to_load = 'Scan.mat';         % file to load
movie_id = '1khz';                          % name for saved animation
save_switch = false;                        % save data?

% which measurement point corresponts to input mobility?
% NOTE: Depends on your measurement setup!
input_coord = 172;

% if the beam was not really parallel to the ground you can compensate this here
% (mostly cosmetic change), probably good to start with 0
tilt_angle = 0.66;                          % tilt angle, degrees

% beam geometry, double check!
a = 0.935;                                  % length, m
b = 0.046;                                  % height, m

% distance between measurement points for transfer mobility in part 1 of lab
% double check!
point_dist = 0.1525;

% length and number of frames for animation
num_periods = 2;
num_frames = 24;          % per period

%% ===========================================================================
% load data
% ============================================================================
load(to_load);
num_coord = size(vertices,1); %#ok<SUSENS>

%% ===========================================================================
% plot input mobility and get freq to plot
% ============================================================================
f = df:df:maxF;

while true
  figure(1)
  semilogx(f,20*log10(abs(H1_mobility(input_coord,:)))); %#ok<SUSENS>
  xlabel('f in Hz')
  ylabel('20 log10 |H1| in dB')
  title('Input mobility')
  axis tight
  grid on
  xlim([0 maxF])
  set(gcf,'Position',[50 100 1600 900]);
  [chosen,~] = ginput(1);

  % find closest frequency to chosen one
  low  = find(f<chosen,1,'last');
  high = find(f>chosen,1,'first');
  if chosen-f(low) <= f(high)-chosen
    ind = low;
  else
    ind = high;
  end

  %% ===========================================================================
  % create displacement for chosen frequency
  % ============================================================================
  % mobility to receptance
  X = H1_mobility(:,ind)./(1i*2*pi*f(ind));

  xi  = abs(X);         % magnitude
  phi = angle(X);       % phase

  %% ===========================================================================
  % Undo rotation of measurement grid
  % ============================================================================
  tilt_angle = deg2rad(tilt_angle);

  % rotation matrix
  R = [cos(tilt_angle) -sin(tilt_angle)
       sin(tilt_angle) cos(tilt_angle)];

  % rotate vertices
  vert = vertices*0;
  for ii=1:num_coord %#ok<*FORPF>
    vert(ii,:) = (R*vertices(ii,:).').';
  end

  %% ===========================================================================
  % right length scales
  % ============================================================================
  % FIXME This is a lot easier if distance to beam is known as vertices saves
  % the angles of the laser
  beam_length = a;
  meas_length = max(vert(:,1))-min(vert(:,1));

  ratio = beam_length/meas_length;
  vert = vert*ratio;

  % set lower left corner to coordinate origin
  vert(:,1) = vert(:,1) - min(vert(:,1));
  vert(:,2) = vert(:,2) - min(vert(:,2));

  % min/max of vertices, needed later for plotting
  vert_max = max(vert);
  vert_min = min(vert);

  %% ===========================================================================
  % plot movement
  % ============================================================================
  % scaling factor for displacement
  scal = (vert_max(2)-vert_min(2))./max(xi(:));

  % full vertice matrix with z-coordinates
  full_vert = zeros(num_coord,3);
  full_vert(:,1:2) = vert;

  Phi = linspace(0,num_periods*2*pi-(2*pi)/num_frames,num_periods*num_frames);

  % animate displacements
  mom_xi = zeros(num_coord,num_frames);
  for ii=1:num_frames
    mom_phi      = phi + Phi(ii);
    mom_xi(:,ii) = real(xi .* exp(1j*mom_phi));
  end

  % for coloring
  max_xi = max(abs(mom_xi(:)));
  norm_xi = mom_xi./max_xi;

  % plotting
  movie_fig = figure;
  set(gcf,'Position',[50 100 1600 900]);
  if save_switch
    avi_obj = VideoWriter(['Modeshape_' movie_id num2str(round(f(ind)))  'Hz.avi']); %#ok<*UNRCH>
    avi_obj.FrameRate = 10;
    open(avi_obj);
  end
  for ii=1:num_frames
    full_vert(:,3) = mom_xi(:,ii)*scal;
    cla
    hpatch = patch('vertices',full_vert,'faces',faces,'EdgeColor',[0.2 0.2 0.2],...
                    'CData',norm_xi(:,ii),'CDataMapping','scaled');
    set(hpatch,'FaceLighting','phong','FaceColor','interp')
    set(gcf,'Colormap',jet)
    set(gca,'CLim',[-1 1],'CLimMode','manual')
    view(3)
    grid on
    axis equal
    axis([0-vert_max(1)/10 1.1*vert_max(1) 0-vert_max(2)/10 1.1*vert_max(2) -0.05 0.05])
    title([num2str(f(ind)) ' Hz'])
    xlabel('m')
    ylabel('m')
    if save_switch
      frame = getframe(movie_fig,[0 0 1550 800]);
      writeVideo(avi_obj, frame);
    else
      % pause
      pause(0.1)
    end
  end

  if save_switch
    close(avi_obj);
    close(movie_fig)
  end
  clear chosen
end
