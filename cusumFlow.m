% Detection using Flow instead of head
% S K Ooi Apr 2024

clear all

%load interpolated data

% Time around blockage occured
starttime=758000; %==23/01/2024 16:41:48
endtime=760000; % ==25/01/2024 02:01:48

% Rename relevant data
usout=[starttime:endtime;DS_POOL_REG_USL_VALi{:,2}(starttime:endtime)]'; %upstream water level of gate DS
gout=[starttime:endtime;DS_POOL_REG_GATE_ELEVATIONi{:,2}(starttime:endtime)]'; %position of gate DS.
hout=[usout(:,1) max(0,usout(:,2)-gout(:,2)) ]; %head over gate DS, remove negative head

fout=[starttime:endtime;DS_POOL_REG_FLOW_VALi{:,2}(starttime:endtime)]'; % flow over gate DS

usin=[starttime:endtime;US_POOL_REG_USL_VALi{:,2}(starttime:endtime)]'; %upstream water level of gate US
gin=[starttime:endtime;US_POOL_REG_GATE_ELEVATION{:,2}(starttime:endtime)]'; %position of gate US.
hin=[usin(:,1) max(0,usin(:,2)-gin(:,2))]; %head over gate US, remove negative head
fin=[starttime:endtime;US_POOL_REG_FLOW_VALi{:,2}(starttime:endtime)]'; % flow over gate US

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

fout(:,1)=fout(:,1)-fout(1,1);

foff(:,1)=foff(:,1)-foff(1,1);

% %% Compute cin & cout using flow=c.h^3/2
%% hin(:,2)=max(0,hin(:,2)); %remove negative h
% 
% % convert Flow from ML/day to m^3/s (1 m^3/s = 86.4 ML/day)
% 
% cin=(fin(:,2)/86.4)./(hin(:,2).^(3/2));
% 
% cin1=cin(~isnan(cin));

plotdata=1;

if plotdata
    %All relevant data for Pool US
    figure
    subplot(511)
    plot(usout(:,1),usout(:,2))
    title('Upstream water level of gate DS')
    xlabel('Minutes')
    ylabel('Meters')
    grid
    subplot(512)
    plot(gout(:,1),gout(:,2))
    title('Position of gate DS')
    xlabel('Minutes')
    ylabel('Meters')
    grid
    subplot(513)
    plot(fin(:,1),fin(:,2))
    title('Flow over gate US')
    xlabel('Minutes')
    ylabel('ML/d')
    grid
    subplot(514)
    plot(fout(:,1),fout(:,2))
    title('Flow over gate DS')
    xlabel('Minutes')
    ylabel('ML/d')
    grid
    subplot(515)
    plot(foff(:,1),foff(:,2))
    title('Flow at offtakes')
    xlabel('Minutes')
    ylabel('ML/day')
    grid
end %if plotdata

%%
%detection of leak in Pool US using water level upstream of gate DS
delay=4;
n=length(usout(:,2));
a=zeros([1 n]);

c=0.00001 %flow c, should be smaller

hd=zeros([1 n]);
for i=1+delay:n-1
    a(i+1)=usout(i+1,2)-usout(i,2)-c*(fin(i-delay,2)-fout(i,2));
end; %for 
drift=0.0000;
%threshold=-0.03;
threshold=-0.015;
threshold=-0.01;
% threshold=-0.005;

alarmtime=[]; detecttime=[];
g(1)=0;
predetect=1; %% added, else undefined in line 116

for i=2:n
    g(i)=g(i-1)+a(i)+drift;
    if g(i)>0
        g(i)=0;
        predetect=i;
    end %if g(i)>0
    if g(i)<threshold
        alarmtime=[alarmtime i];
        detecttime=[detecttime predetect];
        g(i)=0;
        predetect=i;
    end %if g(i)<threshold
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
          
title('Pool Cusum algorithm with alarms (solid) and  reset time (dashed)')
xlabel('Minutes')
ylabel('m')
hold off
