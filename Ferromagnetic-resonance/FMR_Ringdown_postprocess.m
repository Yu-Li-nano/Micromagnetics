%{
This MATLAB code is to postprocess the results of Mumax3 simulation
'FMR_Ringdown.mx3'

Before running this code, cd to 'Mumax3-simulation-result-folder.out/'

Tips in order to get high precision:
 1.Increase Fs/N. As Fs/N = (1/time_step)/num_of_points = 1/run_time,
 longer running time leads to smaller interval of adjacent frequency
 value

 2.Low damping parameter (alpha) in Mumax3 simulation.
 The magnetisation takes longer time to find its equilibrium state, and it
 leads to higher PSD peaks of characteristic frequencies.

                               |\
                               | \
            ___/\___   ->   ___|  \________

%}
%%
clear;
clf
data = readtable('table.txt'); % read data file
mx = data.mx__;
my = data.my__;
mz = data.mz__;
run_time = 5e-9; % run(5e-9) in Mumax3 simulation
time_step = 1e-12; % tableautosave(1e-11) in Mumax3 simulation
num_of_points = run_time/time_step; % number of points per loop
for ii = 1:4 % 4 loops with varying magnetic field
    data_range = (ii-1)*num_of_points+2:ii*num_of_points+1; % avoid 1st abnormal data point
    datat_nth_loop = my(data_range); % pick up the my data in nth loop
    N = length(datat_nth_loop);
    Fs = 1/time_step;
    xdft = fft(datat_nth_loop);
    xdft = xdft(1:N/2);
    psdx = abs(xdft).^2;
    psdx = 2*psdx; % power of density (PSD)
    freq = 1:Fs/N:Fs/2; % Frequency (Hz)
    plot(freq/1e9, psdx); % PSD spectrum
    hold on;
    %% find peaks and label them in the figure
    [pks,locs,peak_width,p]=findpeaks(psdx);
    for ii2 = 1:20
        text(freq(locs(ii2))/1e9,pks(ii2)*2,num2str(freq(locs(ii2))/1e9))
    end
    
    xlabel('Frequency (GHz)')
    ylabel('PSD spectrum')
    set(gca,'yscale','log')
end
% legend of magnetic field corresponds to loops in Mumax3 simulation
legend('B_{ext} = 0.1 T','B_{ext} = 0.3 T','B_{ext} = 0.5 T','B_{ext} = 0.7 T')


