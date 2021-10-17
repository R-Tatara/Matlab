%Update: 2021/10/17
close all;
clear all;
clc;

%Save animation (AVI)
vw = VideoWriter('animation.avi');
vw.Quality = 100;
vw.FrameRate = 60;
open(vw);

%Save animation (GIF)
filename = "animation.gif";

N = 128;
x = linspace(0, 2 * pi, N);
for i = 1 : N
    hold on;
    str_title = "Waveform";
    str_x = "x";
    str_xunit = strcat("[", "m", "]");
    str_xlabel = strcat(str_x, str_xunit);
    str_y = "y";
    str_yunit = strcat("[", "m", "]");
    str_ylabel = strcat(str_y, str_yunit);
    
    plot(x(i), sin(x(i)), ".k");
    xlim([x(1), x(end)]);
    ylim([-1, 1]);
    title(str_title, 'FontWeight', 'bold');
    xlabel(str_xlabel, 'FontWeight', 'bold');
    ylabel(str_ylabel, 'FontWeight', 'bold');
    pause(0)
    
    %Save animation (AVI)
    frame = getframe(gcf);
    writeVideo(vw, frame);
    
    %Save animation (GIF)
    frame = getframe(gcf);
    im = frame2im(frame);
    [A,map] = rgb2ind(im,256);
    if i == 1
        imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',.01);
    else
        imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',.01);
    end
end
hold off;

%Save animation (AVI)
close(vw);