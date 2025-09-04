clear; clc; close all
%% choose the system to optimise - static map or an ODE system?
Static_map = 0; %Set to 1 if there is a static map, and 0 if an ODE system is used (leaving J empty). 

J = @(u)(25-(5-(u)).^2)/1e1;
u = 0;

%% Extremum Seeking Control
freq = 100.1; % sample frequency
dt = 1/freq;
T = 480; % total period of simulation

if Static_map == true
[~, Xout] = All_ODE(dt,T,[X0_int X0_osc],Static_map);
else 
[~, Xout] = All_bio_ODE(dt,T,[X0_int X0_osc X0_bio], Static_map);
end

%% Time plots in the input-output plot

t_plot = linspace(dt,T,size(Xout,1));
[k1, ~,~] = Para_ES(Static_map);

if Static_map == 1
figure
plot(0:0.1:10,J(0:0.1:10),'LineWidth',1.2)
hold on
plot(k1*Xout(:,3),J(k1*Xout(:,3)),'LineWidth',4) 

for i = 25/dt:25/dt:(500-10)/dt
        arrowh(k1*Xout(i:i+1,3),J(k1*Xout(i:i+1,3)),'k',90);
end

l2=legend('Steady State Manifold','ES Response',Orientation='horizontal');
set(l2,'interpreter','latex','Location','north')
set(l2,'Box','off')
t1 = ylabel('Static Map Output - $h(k_1z_2)$');
set(t1,'interpreter','latex')
t2 = xlabel('ES Input - $k_1z_2$');
set(t2,'interpreter','latex')
axis([-0.05 10 -0.1 2.7])


% create smaller axes in top right, and plot on it
xstart=.3;
xend=.78;
ystart=.2;
yend=.5;


axes('position',[xstart ystart xend-xstart yend-ystart ])
plot(t_plot,Xout(:,3)*k1,'LineWidth',1.2)
hold on
% plot(t_plot(end),Xout(end,3)*K,'k*') 

plot(t_plot,J(k1*Xout(:,3)),'LineWidth',1.2)
l2=legend('ES Input - $k_1z_2$','$\mathbf{y} = (25-(5-k_1z_2)^2)/10$');
set(l2,'interpreter','latex','Location','southeast')
set(l2,'Box','off')
xlabel('Time (hr)')
set(findall(gcf,'-property','FontSize'),'FontSize',20)

annotation('textbox',...
    [0.08 0.825 0.99 0.15],...
    'String',{'A'},...
    'FontSize',40*2/3,...
    'FontName','Arial',...
    'LineStyle','none',...
    'LineWidth',2,...
    'Color','k');

annotation('textbox',...
    [0.3 0.35 0.99 0.15],...
    'String',{'B'},...
    'FontSize',40*2/3,...
    'FontName','Arial',...
    'LineStyle','none',...
    'LineWidth',2,...
    'Color','k');

else 
figure
 load('LD_opt_ecoli.mat','LD_opt_ecoli')
plot(LD_opt_ecoli(1,:),LD_opt_ecoli(3,:),'LineWidth',1.2)
hold on

plot(k1*Xout(:,3),Xout(:,17),'LineWidth',2) 

for i = 10/dt:10/dt:(180)/dt
    if i<=20/dt
        arrowh(k1*Xout(i:i+20,3),Xout(i:i+20,17),'k',90);
    elseif i>=130/dt
        arrowh(k1*Xout(i:i+1,3),Xout(i:i+1,17),'k',90);
    else
        arrowh(k1*Xout(i-20:i+20,3),Xout(i-20:i+20,17),'k',90);
    end
end

l2=legend('Steady State Manifold','ES Response',Orientation='horizontal');
set(l2,'interpreter','latex','Location','north')
set(l2,'Box','off')
t1 = ylabel('ES Output - Resveratrol');
set(t1,'interpreter','latex')
t2 = xlabel('ES Input - $k_{ab}^*$');
set(t2,'interpreter','latex')
axis([0 1.73 0 0.41])


% create smaller axes in top right, and plot on it
xstart=.25;
xend=.75;
ystart=.2;
yend=.5;
axes('position',[xstart ystart xend-xstart yend-ystart ])
plot(t_plot,Xout(:,3)*k1,'LineWidth',1.2)
hold on
plot(t_plot,Xout(:,17),'LineWidth',1.2)
plot(t_plot,(Xout(:,11)./(Xout(:,10)+Xout(:,11))),'LineWidth',1.2)
l2=legend('ES Input - $k_{ab}^*$','ES Output - Resveratrol','Cell Population Ratio - $\frac{N_2}{N_1 + N_2}$');
set(l2,'interpreter','latex','Location','northeast')
set(l2,'Box','off')
t1 = xlabel('Time (hr)');
set(t1,'interpreter','latex')
axis([0 T 0 1.25])


set(findall(gcf,'-property','FontSize'),'FontSize',20)

annotation('textbox',...
    [0.05 0.825 0.99 0.15],...
    'String',{'A'},...
    'FontSize',40*2/3,...
    'FontName','Arial',...
    'LineStyle','none',...
    'LineWidth',2,...
    'Color','k');

annotation('textbox',...
    [0.25 0.35 0.99 0.15],...
    'String',{'B'},...
    'FontSize',40*2/3,...
    'FontName','Arial',...
    'LineStyle','none',...
    'LineWidth',2,...
    'Color','k');

end
