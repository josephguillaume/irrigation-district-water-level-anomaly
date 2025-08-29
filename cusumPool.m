%% CUSUM on Pool
%% S K Ooi May 2024

clear all

%load interpolated data

% Time around blockage occured
starttime=758000; %==23/01/2024 16:41:48
endtime=761000; % ==25/01/2024 02:01:48

% Rename relevant data
% Downstream/Out
usout=[starttime:endtime;DS_POOL_REG_USL_VALi{:,2}(starttime:endtime)]'; %upstream water level of downstream gate
gout=[starttime:endtime;DS_POOL_REG_GATE_ELEVATIONi{:,2}(starttime:endtime)]'; %position of gate
hout=[usout(:,1) max(0,usout(:,2)-gout(:,2)) ]; %head over gate, remove negative head

% Upstream/In
usin=[starttime:endtime;US_POOL_REG_USL_VALi{:,2}(starttime:endtime)]'; %upstream water level of upstream gate 
gin=[starttime:endtime;US_POOL_REG_GATE_ELEVATIONi{:,2}(starttime:endtime)]'; %position of gate
hin=[usin(:,1) max(0,usin(:,2)-gin(:,2))]; %head over gate, remove negative head
fin=[starttime:endtime;US_POOL_REG_FLOW_VALi{:,2}(starttime:endtime)]'; % flow over gate

%Offtake data
foff=[starttime:endtime;OFF_FLOW_VALi{:,2}(starttime:endtime)]'; % total offtake in Pool

%Change time axis. Convert the first data point corresponds to time 0.

usout(:,1)=usout(:,1)-usout(1,1);
usin(:,1)=usin(:,1)-usin(1,1);
gout(:,1)=gout(:,1)-gout(1,1);
gin(:,1)=gin(:,1)-gin(1,1);
hout(:,1)=hout(:,1)-hout(1,1);
hin(:,1)=hin(:,1)-hin(1,1);
fin(:,1)=fin(:,1)-fin(1,1);
foff(:,1)=foff(:,1)-foff(1,1);

% %% Compute cin & cout using flow=c.h^3/2
%% hin(:,2)=max(0,hin(:,2)); %remove negative h
% 
% % convert Flow from ML/day to m^3/s (1 m^3/s = 86.4 ML/day)
% 
% cin=(fin(:,2)/86.4)./(hin(:,2).^(3/2));
% 
% cin1=cin(~isnan(cin));

plotdata=1; % plot 4 subplots including offtakes
% plotdata=2; % plot 4 subplots Without offtakes
% plotdata=3; % plot 4 subplots with offtakes u/s level, Without offtakes

linewidth=2;

if plotdata==1 % plot 5 subplots including offtakes
    %All relevant data for Pool
    figure
    subplot(411)
    plot(usout(:,1),usout(:,2),'LineWidth',linewidth)
    title('Upstream water level of Outlet')
    xlabel('Minutes')
    ylabel('Meters')
    grid
    subplot(412)
    plot(gout(:,1),gout(:,2),'LineWidth',linewidth)
    title('Position of Outlet')
    xlabel('Minutes')
    ylabel('Meters')
    grid
    subplot(413)
    plot(hin(:,1),hin(:,2),'LineWidth',linewidth)
    title('Upstream head over gate')
    xlabel('Minutes')
    ylabel('Meters')
    grid
    subplot(414)
    plot(hout(:,1),hout(:,2),'LineWidth',linewidth)
    title('Upstream head over outlet')
    % plot(hout(:,1),hout(:,2),dshout(:,1),dshout(:,2))
    % title('Upstream and downstream head over gate ')
    xlabel('Minutes')
    ylabel('Meters')
    grid
    
% plot x-axis with real date/time, 4 subplots
    %All relevant data for Pool
    figure
    subplot(411)
    plot(DS_POOL_REG_USL_VALi{:,1}(starttime:endtime),usout(:,2),'LineWidth',linewidth)
    title('Upstream water level of Outlet')
    xlabel('Time')
    ylabel('Meters')
    grid
    subplot(412)
    plot(DS_POOL_REG_GATE_ELEVATIONi{:,1}(starttime:endtime),gout(:,2),'LineWidth',linewidth)
    title('Position of Outlet')
    xlabel('Time')
    ylabel('Meters')
    grid
    subplot(413)
    plot(US_POOL_REG_USL_VALi{:,1}(starttime:endtime),hin(:,2),'LineWidth',linewidth)
    title('Upstream head over gate')
    % plot(hin(:,1),hin(:,2),dshin(:,1),dshin(:,2))
    % title('Upstream and downstream head over gate')
    xlabel('Time')
    ylabel('Meters')
    grid
    subplot(414)
    plot(US_POOL_REG_GATE_ELEVATIONi{:,1}(starttime:endtime),hout(:,2),'LineWidth',linewidth)
    title('Upstream head over gate Outlet')
    xlabel('Time')
    ylabel('Meters')
    grid
end %if plotdata

if plotdata==2 % plot 4 subplots without offtakes
    %All relevant data for Pool
    figure
    subplot(411)
    plot(usout(:,1),usout(:,2))
    title('Upstream water level of gate')
    xlabel('Minutes')
    ylabel('Meters')
    grid
    subplot(412)
    plot(gout(:,1),gout(:,2))
    title('Position of gate')
    xlabel('Minutes')
    ylabel('Meters')
    grid
    subplot(413)
    plot(hin(:,1),hin(:,2))
    title('Upstream head over gate')
    % plot(hin(:,1),hin(:,2),dshin(:,1),dshin(:,2))
    % title('Upstream and downstream head over gate')
    xlabel('Minutes')
    ylabel('Meters')
    grid
    subplot(414)
    plot(hout(:,1),hout(:,2))
    title('Upstream head over gate')
    % plot(hout(:,1),hout(:,2),dshout(:,1),dshout(:,2))
    % title('Upstream and downstream head over gate ')
    xlabel('Minutes')
    ylabel('Meters')
    grid
end %if plotdata==2

if plotdata==3 % plot 4 subplots with offakes u/s levels
    %All relevant data for Pool
    figure
    subplot(411)
    plot(usout(:,1),usout(:,2))
    title('Upstream water levels')
    xlabel('Minutes')
    ylabel('Meters')

    subplot(412)
    plot(gout(:,1),gout(:,2))
    title('Position of gate')
    xlabel('Minutes')
    ylabel('Meters')
    grid
    subplot(413)
    plot(hin(:,1),hin(:,2))
    title('Upstream head over gate')
    % plot(hin(:,1),hin(:,2),dshin(:,1),dshin(:,2))
    % title('Upstream and downstream head over gate')
    xlabel('Minutes')
    ylabel('Meters')
    grid
    subplot(414)
    plot(hout(:,1),hout(:,2))
    title('Upstream head over gate')
    % plot(hout(:,1),hout(:,2),dshout(:,1),dshout(:,2))
    % title('Upstream and downstream head over gate ')
    xlabel('Minutes')
    ylabel('Meters')
    grid
end %if plotdata==3


run=1;
if run
%%
%detection of "Positive leak" in Pool using water level upstream of gate outlet
delay=4;
n=length(usout(:,2));
a=zeros([1 n]);

c=0.01 % smaller--> slower detection


for i=1+delay:n-1
    a(i+1)=usout(i+1,2)-usout(i,2)-c*(hin(i-delay,2)^1.5-hout(i,2)^1.5);
end; %for 

%%
drift=0.0000;
%threshold=0.03
% threshold=0.015
% threshold=0.01
threshold=0.005

%%
alarmtime=[]; detecttime=[];
g(1)=0;
predetect=1; %% added, else undefined in line 116

%% Detect "Positive" leak
for i=2:n
    g(i)=g(i-1)+a(i)+drift;
    if g(i)<0
        g(i)=0;
        predetect=i;
    end %if g(i)<0
    if g(i)>threshold
        alarmtime=[alarmtime i];
        detecttime=[detecttime predetect];
        g(i)=0;
        predetect=i;
    end %if g(i)>threshold
end %for i=2:n

ming=min(g); maxg=max(g);
figure
clf
plot(g)
hold on
for i=1:length(alarmtime)
    plot([alarmtime(i) alarmtime(i)], [ming maxg],'r-')
end;
plot([detecttime(1) detecttime(1)],[ming maxg],'g--')
          
title('Pool. Cusum algorithm with alarms (solid) and  reset time (dashed)')
xlabel('Minutes')
ylabel('m')
hold off

end % end run
