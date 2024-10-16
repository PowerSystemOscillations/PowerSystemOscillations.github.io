function [x,y]=dr_plot(ws,wf,dr,col)
% plots a line corresponding to a defined damping ratio on an argand diagram
if ws<0
   y=[ws 0 wf];
else
   y = [ws wf];
end
x = -dr*abs(y)/sqrt(1-dr*dr);
plot(x,y,col)
