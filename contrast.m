%% 重新定义拓扑名称（中文）
topologySet = {L_star,'星型';     % Leader→所有跟随者
               L_chain,'链式'};   % Leader→F1→F2 级联

figure;
for topoIdx = 1:2
    L         = topologySet{topoIdx,1};
    topoNameC = topologySet{topoIdx,2};         % 中文拓扑名称

    x(:,:) = 0;  x(:,1) = [3;-1;0];             % 初始化
    for k = 1:N_step
        x(:,k+1) = x(:,k) - dt * L * x(:,k);    % 一致性律
        x(1,k+1) = x(1,1);                      % 领导者固定
    end

    %========= 中文绘图 =========%
    t = 0:dt:T_end;
    subplot(2,1,topoIdx);
    stairs(t,x(1,:),'-','LineWidth',1.1); hold on;
    stairs(t,x(2,:),'-','LineWidth',1.1);
    stairs(t,x(3,:),'-','LineWidth',1.1);

    xlabel('时间 / 秒');                 % ← X 轴中文
    ylabel('状态值');                     % ← Y 轴中文
    title(['领导-跟随一致性（', topoNameC, '拓扑）']);

    legend('x_1（领导者）', ...
           'x_2（跟随者1）', ...
           'x_3（跟随者2）', ...
           'Location','best');
    grid on;
end
