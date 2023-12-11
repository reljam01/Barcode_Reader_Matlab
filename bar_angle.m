function angle = bar_angle(I)

    %finds the angle between vertical bar-code lines and the x-axis
    
    BW = edge(I,'canny');
    [H,T,R] = hough(BW);

    P  = houghpeaks(H,10,'threshold',ceil(0.3*max(H(:))));

    lines = houghlines(BW,T,R,P,'FillGap',5,'MinLength',7);
    angles = vertcat(lines.theta);
    angle = -mode(angles);
end

