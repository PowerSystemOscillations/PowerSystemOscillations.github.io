% script to generate the torsional model
%  Joe Chow May 19, 2022

clear all; close all; clc;

run('tor_mod_data');                          % generates tor_mod_con

tor = tor_mod(tor_mod_con);                   % produces the torsional model

load('../mat/datalaag_smib.mat');

smib_tor = smib_tor_mod(smib,tor,tor_mod_con);

save datalaag_smib_tor.mat smib_tor;

% eof
