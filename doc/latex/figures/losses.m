clear; close all;

%% MOSFET LOSSES

Vout = 12; Rds = 4.3e-3; tr = 7.2e-9; tf = 3.1e-9; Fsw = 300e3;

Iout = 0:0.01:2.5;

% buck mode
i = 1;
for Vin = 24:-3:12
    fet_buck  = 0.5*Vin*(tr+tf)*Fsw*Iout + 2*Rds*Iout.^2;
    fet_buck = fet_buck*1e3;

    %plot results
    legendCell{i} = num2str(Vin, 'D=%.1f'); i = i + 1;
    figure(1); hold on; grid on;
    plot(Iout, fet_buck);
    title('Buck mode MOSFET losses');
    xlabel('Output Current (A)');
    ylabel('Power Loss (mW)');
    legend(legendCell)
end

% boost mode
i = 1;
for Vin = 5:1.75:12
    fet_boost = 0.5*Vout*(Iout*Vout/Vin)*(tr+tf)*Fsw.*Iout + 2*Rds*(Iout*Vout/Vin).^2;
    fet_boost = fet_boost*1e3;

    %plot results
    legendCell{i} = num2str(Vin, 'V_{in}=%.1f'); i = i + 1;
    figure(2); hold on; grid on;
    plot(Iout, fet_boost);
    title('Boost mode MOSFET losses');
    xlabel('Output Current (A)');
    ylabel('Power Loss (mW)');
    legend(legendCell)
end

% inductor losses
Rw = 5.70e-3;
i = 1;
for Vin = 5:4.75:24
    inductor_losses = ((Vout*Iout/(0.9*Vin)).^2) .* Rw;
    inductor_losses = inductor_losses*1e3;

    %plot results
    legendCell{i} = num2str(Vin, 'V_{in}=%.1f'); i = i + 1;
    figure(3); hold on; grid on;
    plot(Iout, inductor_losses);
    title('Inductor losses');
    xlabel('Output Current (A)');
    ylabel('Power Loss (mW)');
    legend(legendCell)
end

% output capacitor losses
ESRout = 2e-3;

i=1;
for Vin = 5:1.75:12
    cout_losses = (Iout*sqrt(Vout/Vin-1)).^2 .* ESRout;
    cout_losses = cout_losses*1e3;

    %plot results
    legendCell{i} = num2str(Vin, 'V_{in}=%.1f'); i = i + 1;
    figure(4); hold on; grid on;
    plot(Iout, cout_losses);
    title('Output Capacitor losses');
    xlabel('Output Current (A)');
    ylabel('Power Loss (mW)');
    legend(legendCell)
end


% input capacitor losses
ESRin = 2.13e-3;
i=1;
for D = 0.1:0.1:0.5
    cint_losses = Iout.^2*D*(1-D).* ESRin;
    cint_losses = cint_losses*1e3;

    %plot results
    legendCell{i} = num2str(D, 'D=%.1f'); i = i + 1;
    figure(5); hold on; grid on;
    plot(Iout, cint_losses);
    title('Input Capacitor losses');
    xlabel('Output Current (A)');
    ylabel('Power Loss (mW)');
    legend(legendCell)
end
close all;

% total buck losses
buck_losses = 0.5*24*(tr+tf)*Fsw*Iout + 2*Rds*Iout.^2; % MOSFET
buck_losses = buck_losses + ((Vout*Iout/(0.9*24)).^2) .* Rw; % inductor
buck_losses = buck_losses + Iout.^2*0.5*(1-0.5).* ESRin; % capacitor
buck_losses = buck_losses + 0.178; %rsense

figure(6); hold on; grid on;
plot(Iout, buck_losses);
title('Total buck power losses');
xlabel('Output Current (A)');
ylabel('Power Loss (W)');
legend("V_{in} = 24V")

% total boost losses
boost_losses = 0.5*Vout*(Iout*Vout/5)*(tr+tf)*Fsw.*Iout + 2*Rds*(Iout*Vout/5).^2;  % MOSFETs
boost_losses = boost_losses + ((Vout*Iout/(0.9*5)).^2) .* Rw; %inductor
boost_losses = boost_losses + Iout.^2*0.5*(1-0.5).* ESRin; % capacitor
boost_losses = boost_losses + 530e-3; %rsense

figure(7); hold on; grid on;
plot(Iout, boost_losses);
%title('Total boost power losses');
xlabel('Output Current (A)');
ylabel('Power Loss (W)');
legend("V_{in} = 5V")
