%% Calculate critical parameters for micromagnetics
% in the SI unit
clear
u = symunit
%% Physical constants
% vacuum permeability
mu0 = 4*pi*1e-7 * u.H/u.m; %(H/m), included in symunit since MATLAB R2020a

%% magnetic parameters
% used FeGe as an example

% lattice constant
a = 4.7                 * u.Ao;             %(angstrom)
% saturation magnetisation
Ms = 384e3              * u.A/u.m;          %(A/m)
% exchange constant
A = 8.78e-12            * u.J/u.m;          %(J/m)
% Dzyaloshinskii-Moriya interaction (DMI)
D = 1.58e-3             * u.J/u.m^2;        %(J/m^2)
% 1st order uniaxial ansotropy
Ku1 = 0                 * u.J/u.m^3;        %(J/m^3)


%% critical parameters
% helical period
L_D = A/D*4*pi;                             %(m)

% Critical field
% Field for reversal of skyrmion state to ferromagnetic state
H_D = D^2/2/A/Ms;                           %(T)

% Quality factor
Q = 2*Ku1/mu0/Ms^2;                         %(1)

% exchange length l_ex
% For micromagnetic simulations, the cell size should be smaller than
% 0.5*l_ex, otherwise the estimationit on the domain wall energy will 
% be incorrect.
l_ex = sqrt(2*A/mu0/Ms^2);                  %(m)

% DMI length
l_DMI = 2*D/mu0/Ms^2;                       %(m)

% Effective anisotropy for thin film
Keff = Ku1-0.5*mu0*Ms^2                     %(m)
%% which value you'd like to check?
[len units] = separateUnits(Q)
len = double(len)