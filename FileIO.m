%Update: 2021/10/17
close all;
clear all;
clc;

%Frequency analysis setting
N = 64; %Signal length
dt = 888e-6; %Sampling period[s]
fs = 1 / dt; %Sampling frequency[Hz]
df = fs / (N - 1); %Frequency resolution[Hz]
n = 0 : 1 : N - 1; %Index
nw = n ./ (N - 1); %Normalized index
t = 0 : dt : (N - 1) * dt; %Time[s]
f = 0 : df : (N - 1) * df; %Frequency[Hz]

%Waveform
frequency = 30.0; %[Hz]
y1(1 : N) = 0;
y2(1 : N) = 1;
y3(1 : N) = 2;
z1 = 1 * sin(2 * pi * 1 * frequency * t);
z2 = 2 * sin(2 * pi * 2 * frequency * t);
z3 = 1 * sin(2 * pi * 3 * frequency * t);

plot3(t, y1, z1, t, y2, z2, t, y3, z3);
grid on;
set(gca,'TickLength', [0.003 0.03], ... %目盛の長さの設定
        'GridLineStyle', ':', ... %グリッドを点線に設定
        'GridColor', 'k', ... %グリッドの色を黒に設定
        'GridAlpha', 1); %透過性なしに設定

%Output table
OutputTable(:, 1) = z1;
OutputTable(:, 2) = z2;
OutputTable(:, 3) = z3;

%Output csv file
filename = 'data.csv';
csvwrite(filename, OutputTable);
disp(strcat('Output file "', filename, "'"));

%Input csv file
filename = 'data.csv';
InputTable = csvread(filename);
disp(strcat('Input file "', filename, "'"));

%Input table
% A  B  C  D  E  F  G  H  I  J  K  L  M  N  O  P  Q  R  S  T  U  V  W  X  Y  Z
% 1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26
firstrow = 1;
zin_column = 2; %B
zin = transpose(InputTable(firstrow : firstrow + N - 1, zin_column));