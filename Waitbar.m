%Update: 2021/10/17
close all;
clear all;
clc;

%-------------------------------------------------------
%User preferences
isWaitbar = 1; %ON: 1, OFF: 0
%-------------------------------------------------------

imax = 30;

%Waitbar
if isWaitbar == 1
    wb = waitbar(0, 'Please wait...');
end
t_start = clock;

tic
for i = 1 : imax
    pause(0.1)
    
    %Waitbar
    if isWaitbar == 1
        if i == 1
            t_est = etime(clock, t_start) * imax;
        end
        
        wb = waitbar(i / imax, ...
            wb, ['Remaining time = ', num2str(t_est - etime(clock, t_start), ...
            '%4.1f'), ...
            'sec']);
    end
end
toc

if isWaitbar == 1
	wb = waitbar(1, wb, 'Graph creation completed.');
	pause(1.0)
	close(wb)
end