%{
This MATLAB code is for the generation of a single skyrmion/antiskyrmion
config., and output to a .ovf file.

We have the magnetisation with the position in a cylindrical coordinate:
    r = [r*cos(psi), r*sin(psi), z],
and normalised vector in a spherical coordinate:
    m = [sin(theta) * cos(phi), sin(theta) * sin(phi), cos(theta)].

The out-of-plane theta(r) can be described by the ansatz [1]:
    theta(r) = 2atan[cos(R_s) / sinh(r / delta_s)],      (1)
with R_s the variational parameter and delta_s the skyrmion/antiskyrmion
radius, and the in-plane phi(psi) can be represented as [2]:
    phi = c * psi + phi_1,                               (2)
with
            phi_1 = 0        -> Neel skyrmion,  C_nv symmetry
    c = 1,  0 < phi_1 < pi/2 -> mixed skyrmion, C_n symmetry
            phi_1 = pi/2     -> Bloch skyrmion, D_n symmetry
            
or
    c = -1, 0 < phi_1 < pi/2 -> antiskyrmion,   S_4 symmetry
            phi_1 = pi/2     -> antiskyrmion,   D_2d symmetry

[1] H.-B. Braun, Adv. Phys. 61, 1 (2012)
[2] A. O. Leonov et al., New J. Phys., 18, 065003 (2016)
%}

%% 1.Define the system dimension
clc
clear
close all
cellx = 1e-9; %unit in nm
celly = 1e-9;
cellz = 1e-9;
gridx = 200;
gridy = 200;
gridz = 1;

%% 2.Generate the skyrmion/antiskyrmion profile

R_s = 1e-9;         % R_s variational parameter 
d_s = 20e-9/cellx;	% delta_s the skyrmion/antiskyrmion radius
c = 1;              % c = 1 -> skyrmion, c = -1 -> antiskyrmion
phi_1 = pi/2;       % phi_1

for zz = 1:1
    for yy = 1:gridy
        for xx = 1:gridx
            % the config. is positioned in the centre
            centre = [gridx / 2,gridy / 2];
            
            p = [xx, yy] - centre; % position in the cartesian coordinate
            [psi, r] = cart2pol(p(1), p(2));            % psi and r
            theta = 2 * atan(cos(R_s) / sinh(r/d_s));   % Eq. (1)
            phi = c * psi + phi_1;                      % Eq. (2)
            mm{1}(xx,yy,zz) = sin(theta) * cos(phi);    % mx
            mm{2}(xx,yy,zz) = sin(theta) * sin(phi);    % my
            mm{3}(xx,yy,zz) = cos(theta);               % mz
        end
    end
end

heatmap(mm{3}(:,:,1)) % visulaise mz in a simple way
%% 3. A FileHeader template
% 3.1.Define filename and FileHeader
filename =  'example.ovf';
FileHeader = {
'# OOMMF OVF 2.0'
'# Segment count: 1'
'# Begin: Segment'
'# Begin: Header'
'# Title: m'
'# meshtype: rectangular'
'# meshunit: m'
'# xmin: 0'
'# ymin: 0'
'# zmin: 0'
['# xmax: ', num2str(cellx*gridx)]
['# ymax: ', num2str(celly*gridy)]
['# zmax: ', num2str(cellz*gridz)]
'# valuedim: 3'
'# valuelabels: m_x m_y m_z'
'# valueunits: 1 1 1'
'# Desc: Total simulation time:  0  s'
'# xbase: 1e-09'
'# ybase: 1e-09'
'# zbase: 1e-09'
['# xnodes: ', num2str(gridx)]
['# ynodes: ', num2str(gridy)]
['# znodes: ', num2str(gridz)]
['# xstepsize: ', num2str(cellx)]
['# ystepsize: ', num2str(celly)]
['# zstepsize: ', num2str(cellz)]
'# End: Header'
'# Begin: Data Text'
};

FID = fopen(filename,'w'); % open the output .ovf file

% 3.2.Output the FileHeader
for ll = 1:length(FileHeader)
    fprintf(FID, '%c', FileHeader{ll});
    fprintf(FID,'\n');
end
            
% 3.3.Output the mx, my, mz
for zz = 1:gridz
    for yy = 1:gridy
        for xx = 1:gridx
            fprintf(FID, '%c', [num2str(mm{1}(xx,yy,zz)), ' ', ...
                num2str(mm{2}(xx,yy,zz)), ' ', num2str(mm{3}(xx,yy,zz))]);
            fprintf(FID,'\n');
        end
    end
end
fprintf(FID, '%c', ['# End: Data Text']);
fprintf(FID,'\n');
fprintf(FID, '%c', ['# End: Segment']);
fclose(FID);