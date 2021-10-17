%Update: 2021/10/17
close all;
clear all;
clc;

%-------------------------------------------------------
%User preferences
isPlot = 1; %Make graph? Yes: 1, no: 0
isSave = 0; %Save graph? Yes: 1, no: 0
isMaximize = 1; %Maximized plot? Yes: 1, no: 0
additional_filename = '';

%Frequency analysis setting
N = 2048; %Signal length
dt = 888e-6; %Sampling period[s]
fs = 1 / dt; %Sampling frequency[Hz]
df = fs / (N - 1); %Frequency resolution[Hz]
n = 0 : 1 : N - 1; %Index
nw = n ./ (N - 1); %Normalized index
t = 0 : dt : (N - 1) * dt; %Time[s]
f = 0 : df : (N - 1) * df; %Frequency[Hz]
%-------------------------------------------------------

%Waveform
frequency = 10.0; %[Hz]
y1 = 1 * sin(2 * pi * frequency * t);

%Detrending(Linear approximation)
%a = polyfit(t, y1, 1);
%y1 = y1 - (a(1) * t + a(2));

%Windowing
blackman = transpose(blackman(N) / mean(blackman(N)));
hanning = transpose(hann(N) / mean(hann(N)));
hamming = transpose(hamming(N) / mean(hamming(N)));
flattop = transpose(flattopwin(N) / mean(flattopwin(N)));

y1_win = flattop .* y1; %[CHECK]

%Magnitude spectrum
y1_fft = fft(y1_win);
re_y1 = real(y1_fft);
im_y1 = imag(y1_fft);
magnitude1 = sqrt(re_y1 .^ 2.0 + im_y1 .^ 2.0) .* 2.0 ./ N;

%Phase spectrum
phase1 = angle(y1_fft) * 180.0 / pi;

%Graph preferences
if isPlot == 1
    figure_window = figure;
elseif isPlot == 0
    figure_window = figure('visible','off');
end

if isMaximize == 1
    figure_window.WindowState = 'maximized';
end

%Graph1
str_title = "Waveform";
str_x = "Time";
str_xunit = strcat("[", "s", "]");
str_xlabel = strcat(str_x, str_xunit);
str_y = "Value";
str_yunit = "";
str_ylabel = strcat(str_y, str_yunit);

subplot(3, 1, 1), plot(t, y1);
xlim([t(1), t(end)]);
ylim([min(y1), max(y1)] * 1.1);
title(str_title, 'FontWeight', 'bold');
xlabel(str_xlabel, 'FontWeight', 'bold');
ylabel(str_ylabel, 'FontWeight', 'bold');
grid on
set(gca,'TickLength', [0.003 0.03], ... %目盛の長さの設定
        'GridLineStyle', ':', ... %グリッドを点線に設定
        'GridColor', 'k', ... %グリッドの色を黒に設定
        'GridAlpha', 1); %透過性なしに設定

%Graph2
str_title = "Waveform (preprocessed)";
str_x = "Time";
str_xunit = strcat("[", "s", "]");
str_xlabel = strcat(str_x, str_xunit);
str_y = "Value";
str_yunit = "";
str_ylabel = strcat(str_y, str_yunit);

subplot(3, 1, 2), plot(t, y1_win);
xlim([t(1), t(end)]);
ylim([min(y1_win), max(y1_win)] * 1.1);
title(str_title, 'FontWeight', 'bold');
xlabel(str_xlabel, 'FontWeight', 'bold');
ylabel(str_ylabel, 'FontWeight', 'bold');
grid on;
set(gca,'TickLength', [0.003 0.03], ... %目盛の長さの設定
        'GridLineStyle', ':', ... %グリッドを点線に設定
        'GridColor', 'k', ... %グリッドの色を黒に設定
        'GridAlpha', 1); %透過性なしに設定

%Graph3
str_title = "Frequency spectrum";
str_x = "Frequency";
str_xunit = strcat("[", "Hz", "]");
str_xlabel = strcat(str_x, str_xunit);
str_y = "Value";
str_yunit = "";
str_ylabel = strcat(str_y, str_yunit);

subplot(3, 1, 3), semilogy(f, magnitude1);
xlim([0, fs / 2.0]);
ylim auto;
title(str_title, 'FontWeight', 'bold');
xlabel(str_xlabel, 'FontWeight', 'bold');
ylabel(str_ylabel, 'FontWeight', 'bold');
grid on;
set(gca,'TickLength', [0.003 0.03], ... %目盛の長さの設定
        'GridLineStyle', ':', ... %グリッドを点線に設定
        'GridColor', 'k', ... %グリッドの色を黒に設定
        'GridAlpha', 1); %透過性なしに設定

if isSave == 1
    plotname = strcat("data", num2str(1), additional_filename);
    print(plotname,'-dpng');
end