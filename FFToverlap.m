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
Nol = 2048; %Window size
dt = 888e-6; %Sampling period[s]
fs = 1 / dt; %Sampling frequency[Hz]
df = fs / (Nol - 1); %Frequency resolution[Hz]
n = 0 : 1 : Nol - 1; %Index
nw = n ./ (Nol - 1); %Index for window
tol = 0 : dt : (Nol - 1) * dt; %Time[s]
f = 0 : df : (Nol - 1) * df; %Frequency[Hz]
%f = flip(f);
%-------------------------------------------------------

%Waveform
N = 65535; %Signal length
t = 0 : dt : (N - 1) * dt; %Time[s]
frequency = 4.0; %[Hz]
y_original = 1 * sin(2 * pi * frequency * t .* t);

%Overlapping
overlap_max = fix(2 * N / Nol) - 1;
y_overlap = zeros(overlap_max, Nol);
for i = 1 : overlap_max
    y_overlap(i, :) = y_original(1, 1 + (i - 1) * Nol / 2 : Nol + (i - 1) * Nol / 2);
end

%Detrending(Linear approximation)

%Windowing
blackman = transpose(blackman(Nol) / mean(blackman(Nol)));
hanning = transpose(hann(Nol) / mean(hann(Nol)));
hamming = transpose(hamming(Nol) / mean(hamming(Nol)));
flattop = transpose(flattopwin(Nol) / mean(flattopwin(Nol)));

y_overlap_win = zeros(overlap_max, Nol);
for i = 1 : overlap_max
    y_overlap_win(i, :) = flattop .* y_overlap(i, :);
end

%Magnitude spectrum
y_fft = complex(zeros(overlap_max, Nol), 0);
re_y = zeros(overlap_max, Nol);
im_y = zeros(overlap_max, Nol);
y_magnitude = zeros(overlap_max, Nol);
for i = 1 : overlap_max
    y_fft(i, :) = fft(y_overlap_win(i, :));
    re_y(i, :) = real(y_fft(i, :));
    im_y(i, :) = imag(y_fft(i, :));
    y_magnitude(i, :) = sqrt(re_y(i, :) .^ 2.0 + im_y(i, :) .^ 2.0) .* 2.0 ./ Nol;
end

%Phase spectrum
y_phase = zeros(overlap_max, Nol);
for i = 1 : overlap_max
    y_phase(i, :) = angle(y_fft(i, :)) * 180.0 / pi;
end

%Graph preferences
if isPlot == 1
    figure_window = figure;
elseif isPlot == 0
    figure_window = figure('visible','off');
end

if isMaximize == 1
    figure_window.WindowState = 'maximized';
end

for i = 1 : overlap_max
    hold on;
    
    %Graph1
    str_title = "Waveform";
    str_x = "Time";
    str_xunit = strcat("[", "s", "]");
    str_xlabel = strcat(str_x, str_xunit);
    str_y = "Value";
    str_yunit = "";
    str_ylabel = strcat(str_y, str_yunit);

    subplot(2, 2, 1), plot(t, y_original);
    xline(i / 2 * Nol * dt, '--r', {"Start"});
    xline((i + 2) / 2 * Nol * dt, '--r', {"End"});
    xlim([t(1), t(end)]);
    ylim([min(min(y_original)), max(max(y_original))] * 1.1);
    title(str_title, 'FontWeight', 'bold');
    xlabel(str_xlabel, 'FontWeight', 'bold');
    ylabel(str_ylabel, 'FontWeight', 'bold');
    grid on;
    set(gca,'TickLength', [0.003 0.03], ... %目盛の長さの設定
            'GridLineStyle', ':', ... %グリッドを点線に設定
            'GridColor', 'k', ... %グリッドの色を黒に設定
            'GridAlpha', 1) %透過性なしに設定

    %Graph2
    str_title = "Waveform (preprocessed)";
    str_x = "Time";
    str_xunit = strcat("[", "s", "]");
    str_xlabel = strcat(str_x, str_xunit);
    str_y = "Value";
    str_yunit = "";
    str_ylabel = strcat(str_y, str_yunit);

    subplot(2, 2, 3), plot(tol + i / 2 * Nol * dt, y_overlap_win(i, :));
    xline(i / 2 * Nol * dt, '--r', {"Start"});
    xline((i + 2) / 2 * Nol * dt, '--r', {"End"});
    xlim([t(1), t(end)]);
    ylim([min(min(y_overlap_win)), max(max(y_overlap_win))] * 1.1);
    title(str_title, 'FontWeight', 'bold');
    xlabel(str_xlabel, 'FontWeight', 'bold');
    ylabel(str_ylabel, 'FontWeight', 'bold');
    grid on;
    set(gca,'TickLength', [0.003 0.03], ... %目盛の長さの設定
            'GridLineStyle', ':', ... %グリッドを点線に設定
            'GridColor', 'k', ... %グリッドの色を黒に設定
            'GridAlpha', 1) ... %透過性なしに設定

    %Graph3
    str_title = "Frequency spectrum";
    str_x = "Frequency";
    str_xunit = strcat("[", "Hz", "]");
    str_xlabel = strcat(str_x, str_xunit);
    str_y = "Value";
    str_yunit = "";
    str_ylabel = strcat(str_y, str_yunit);

    subplot(2, 2, 2), semilogy(f, y_magnitude(i, :));
    xlim([0, fs / 2.0]);
    ylim([1e-6, max(max(y_overlap_win))]);
    title(str_title, 'FontWeight', 'bold');
    xlabel(str_xlabel, 'FontWeight', 'bold');
    ylabel(str_ylabel, 'FontWeight', 'bold');
    grid on;
    set(gca,'TickLength', [0.003 0.03], ... %目盛の長さの設定
            'GridLineStyle', ':', ... %グリッドを点線に設定
            'GridColor', 'k', ... %グリッドの色を黒に設定
            'GridAlpha', 1) %透過性なしに設定

    %Graph4
    str_title = "Frequency spectrum (Time transition)";
    str_x = "Time";
    str_xunit = strcat("[", "s", "]");
    str_xlabel = strcat(str_x, str_xunit);
    str_y = "Frequency";
    str_yunit = strcat("[", "Hz", "]");
    str_ylabel = strcat(str_y, str_yunit);
    
    subplot(2, 2, 4), imagesc(t, f, transpose(y_magnitude));
    axis xy;
    colorbar;
    xlim([t(1), t(end)]);
    ylim([0, fs / 2.0]);
    set(gca, 'clim', [0 1]);
    title(str_title, 'FontWeight', 'bold');
    xlabel(str_xlabel, 'FontWeight', 'bold');
    ylabel(str_ylabel, 'FontWeight', 'bold');
    grid on;
    set(gca,'TickLength', [0.003 0.03], ... %目盛の長さの設定
            'GridLineStyle', ':', ... %グリッドを点線に設定
            'GridColor', 'k', ... %グリッドの色を黒に設定
            'GridAlpha', 1) %透過性なしに設定
    
    pause(0);
    
    if isSave == 1
        plotname = strcat("data", num2str(1), additional_filename);
        print(plotname,'-dpng');
    end
end
hold off;