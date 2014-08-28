%% XivelyRead
%  How to read and use data from Xively IoT API
%  Copyright (C) 2014  Jorge Garcia Tiscar
% 
%  This program is free software: you can redistribute it and/or modify
%  it under the terms of the GNU General Public License as published by
%  the Free Software Foundation; either version 3 of the License, or
%  (at your option) any later version (see LICENSE).

%% Initialize
%  Close all figures, clear workspace and console
%  Add required files
addpath .ignore
clear all
close all
clc

%% Get data 
%  Fetch from Xively if there's none or is older than 1 hour
file = dir('feed.csv');
if isempty(file) || abs(file(1).datenum-now) > 1/24
    
    % Inform the user
    disp('Fetching data from Xively');
    
    % Parameters 
    load key
    feedID   = '426071678';
    start    = '2014-01-28T00:00:00Z';
    streams  = 'CPU_load,CPU_temp';
    interval = '30000';
    limit    = '1000';
    
    % Query REST API
    raw = urlread(['https://api.xively.com/v2/feeds/' feedID '.csv?datastreams=' streams ...
                   '&key=' key '&start=' start '&interval=' interval '&limit=' limit]);
               
    % Write to file
    dlmwrite('feed.csv',raw,'delimiter','');
end

%  Read file into feed object
feed = importdata('feed.csv',',');

%% Format data
%  Store datastreams as fields
datastreams = unique(feed.textdata(:,1));
for i = 1:length(datastreams)
    feed.(datastreams{i}) = feed.data(strcmp(feed.textdata(:,1),datastreams(i)));
end

%  Format time vector
dummyTime = cell2mat(feed.textdata(1:length(datastreams):end,2));
feed.Time = datenum(dummyTime(:,1:end-4),'yyyy-mm-ddTHH:MM:SS.FFF');

%  Remove obsolete fields
feed = rmfield(feed,{'data','textdata'});

%% Use data: plot evolution of relative CPU temperature
%  Get points where CPU_load < 15
lowLoadTemps = feed.CPU_load < 15;

%  Smooth data
avgCPU_temp  = smooth(feed.CPU_temp,75,'lowess');

%  Plot
figure('DefaultAxesFontSize',10)
plot(feed.Time(lowLoadTemps),feed.CPU_temp(lowLoadTemps),'-.')
hold all
plot(feed.Time(lowLoadTemps),avgCPU_temp(lowLoadTemps),'-','LineWidth',2)

%  Format figure
title('RasPi - Evolution of CPU temperature (when CPU load < 15%)')
xlabel('Date');
ylabel('T [ºC]');
dynamicDateTicks % mathworks.com/matlabcentral/fileexchange/27075-intelligent-dynamic-date-ticks
axis tight
grid on

%  Save figure
set(gcf, 'Position', [0, 0, 640, 400]);
set(gcf, 'Color', 'w');
export_fig('TempCPU','-png','-a3','-r200') % github.com/ojwoodford/export_fig