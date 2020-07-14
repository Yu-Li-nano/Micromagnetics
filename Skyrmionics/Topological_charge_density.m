%{
This MATLAB code is to reproduce the calculation of topological
charge density [1]:
    Q_dens = 1/(4π) m·(∂m/∂x x ∂m/∂y),
referring to Muamx3 [2] ext_topologicalchargedensity [3] function.

***Pre-processing is required:
cd path to output folder, which contains .ovf files;
Use 'mumax3-convert' to convert binary .ovf files into ascii
style, please see details in [4].

For converting to vtk, an alternative, more functional choice
is also recommended [5], developed by Joe Yeh.

[1] H.-B. Braun, Adv. Phys. 61, 1 (2012)
[2] https://mumax.github.io
[3] https://github.com/mumax/3/blob/master/cuda/topologicalcharge.cu
[4] https://godoc.org/github.com/mumax/3/cmd/mumax3-convert
[5] https://github.com/joe-of-all-trades/vtkwrite/blob/master/vtkwrite.m
%}

%% 1.Read FileHeader and system dimension
clc
clear
close all
display('loading data')
%path = ''
%cd(path)
aa3 = dir('m*.ovf');
bbm = {aa3(1:end).name}' %load *.ovf and generate a list
% load cellsize and gridsize in 1st .ovf
ii = 1;
[A,B] = importdata(char(bbm(ii)),' ',28);
cells = A.textdata;
cellx = str2num(cells{24}(13:end));
celly = str2num(cells{25}(13:end));
cellz = str2num(cells{26}(13:end));
gridx = str2num(cells{21}(10:end));
gridy = str2num(cells{22}(10:end));
gridz = str2num(cells{23}(10:end));
%% 2.Using for loops to process .ovf files
for ii = 1:length(bbm)
    %% 2.1.Load mx, my, mz
    [A,B] = importdata(char(bbm(ii)),' ',28);
    mydata_m = A.data; %read magnetisation data
    for zz = 1:gridz
        for yy = 1:gridy
            for xx = 1:gridx
                realn = xx+(yy-1)*gridx+(zz-1)*gridx*gridy;
                u(xx,yy,zz) = mydata_m(realn,1); %mx
                v(xx,yy,zz) = mydata_m(realn,2); %my
                w(xx,yy,zz) = mydata_m(realn,3); %mz
            end
        end
    end
    mm = {u,v,w}; % save mx -> mm{1}, my -> mm{2}, mz -> mm{3}
    %% 2.2.Calculate topological charge density (Qdens)
    m_0 = @(xx, yy, zz) [mm{1}(xx,yy,zz),mm{2}(xx,yy,zz),mm{3}(xx,yy,zz)]; % Function to extract [mx,my,mz]
    Qdens = zeros(gridx,gridy,gridz); % ini Qdens
    for zz = 1:gridz
        for xx = 1:gridx
            for yy = 1:gridy
                % dmdx
                if xx == 1
                    dmdx = -0.5*m_0(xx+2,yy,zz)+2*m_0(xx+1,yy,zz)-1.5*m_0(xx,yy,zz);
                else if xx == 2
                        dmdx = 0.5*(m_0(xx+1,yy,zz)-m_0(xx-1,yy,zz));
                    else if xx < gridx-1
                            dmdx = 2/3*(m_0(xx+1,yy,zz)-m_0(xx-1,yy,zz))+1/12*(m_0(xx-2,yy,zz)-m_0(xx+2,yy,zz));
                        else if xx == gridx-1
                                dmdx = 0.5*(m_0(xx+1,yy,zz)-m_0(xx-1,yy,zz));
                            else if xx == gridx
                                    dmdx = -0.5*m_0(xx-2,yy,zz)+2*m_0(xx-1,yy,zz)-1.5*m_0(xx,yy,zz);
                                end
                            end
                        end
                    end
                end
                
                % dmdy
                if yy == 1
                    dmdy = -0.5*m_0(xx,yy+2,zz)+2*m_0(xx,yy+1,zz)-1.5*m_0(xx,yy,zz);
                else if yy == 2
                        dmdy = 0.5*(m_0(xx,yy+1,zz)-m_0(xx,yy-1,zz));
                    else if yy < gridy-1
                            dmdy = 2/3*(m_0(xx,yy+1,zz)-m_0(xx,yy-1,zz))+1/12*(m_0(xx,yy-2,zz)-m_0(xx,yy+2,zz));
                        else if yy == gridy-1
                                dmdy = 0.5*(m_0(xx,yy+1,zz)-m_0(xx,yy-1,zz));
                            else if yy == gridy
                                    dmdy = -0.5*m_0(xx,yy-2,zz)+2*m_0(xx,yy-1,zz)-1.5*m_0(xx,yy,zz);
                                end
                            end
                        end
                    end
                end
                
                dmdx_x_dmdy = cross(dmdx,dmdy);
                Qdens2 = 1/4/pi*dot(m_0(xx,yy,zz),dmdx_x_dmdy);
                Qdens(xx,yy,zz) = Qdens2;
            end
        end
    end
    
    %% 2.3.Convert .vtk for visualisation
    % Output file name
    nn = char(bbm(ii));
    filename = ['Matlab_Qdens_',nn(1:end-4),'.vtk'];
    tic
    rx = [0:gridx-1]*cellx;
    ry = [0:gridy-1]*celly;
    rz = [0:gridz-1]*cellz;
    [y,x,z] = meshgrid(ry,rx,rz); %position of x y z
    
    u = Qdens;
    v = Qdens;
    w = Qdens;
    nr_of_elements = numel(x);
    fid = fopen(filename, 'w');
    
    %ASCII file header
    fprintf(fid, '# vtk DataFile Version 3.0\n');
    fprintf(fid, 'VTK from Matlab\n');
    fprintf(fid, 'BINARY\n\n');
    fprintf(fid, 'DATASET STRUCTURED_GRID\n');
    fprintf(fid, ['DIMENSIONS ' num2str(size(x,1)) ' ' num2str(size(x,2)) ' ' num2str(size(x,3)) '\n']);
    fprintf(fid, ['POINTS ' num2str(nr_of_elements) ' float\n']);
    fclose(fid);
    
    %append binary x,y,z data
    fid = fopen(filename, 'a');
    fwrite(fid, [reshape(x,1,nr_of_elements);  reshape(y,1,nr_of_elements); reshape(z,1,nr_of_elements)],'float','b');
    
    %append another ASCII sub header
    fprintf(fid, ['\nPOINT_DATA ' num2str(nr_of_elements) '\n']);
    fprintf(fid, 'VECTORS velocity_vectors float\n');
    
    %append binary u,v,w data
    fwrite(fid, [reshape(u,1,nr_of_elements);  reshape(v,1,nr_of_elements); reshape(w,1,nr_of_elements)],'float','b');
    %
    %append some scalar data
    fprintf(fid, '\nSCALARS scalar float\n'); %ASCII header
    fprintf(fid, 'LOOKUP_TABLE default\n'); %ASCII header
    fwrite (fid, reshape(sqrt(u.^2+v.^2+w.^2),1,nr_of_elements),'float','b'); %binary data
    
    fclose(fid);
    toc
end