%% ================== 0. 环境初始化 ==================
clc; clear;
T_end   = 4;          % 总仿真时间 (s)
dt      = 0.02;       % 步长
N_step  = T_end/dt;
t_vec   = 0:dt:T_end; % 时间序列

%% ================== 1. 基础拓扑矩阵 ==================
% ★ 星型（Leader→所有跟随者）基础拉普拉斯
L_star_base = [0  0  0 ;
              -1  1  0 ;
              -1  0  1 ];

% ★ 链式（Leader→F1→F2）基础拉普拉斯
L_chain_base = [0  0  0 ;
               -1  1  0 ;
                0 -1  1 ];

%% ================== 2. 障碍物干扰设置 ==================
% 障碍物生效时间窗
obstacleWindow = [1, 2];   % 单位：秒

% ——(a) 星型：阻断 Leader→x3 这条边
blockedEdges_star  = [3,1];   % (受阻节点, 信息来源)

% ——(b) 链式：阻断 x2→x3 这条边
blockedEdges_chain = [3,2];

%% ================== 3. 主函数：根据时间返回当前L ==================
getL = @(t, L_base, blockedEdge) ...
    ( t>=obstacleWindow(1) && t<=obstacleWindow(2) ) ...
      * removeEdge(L_base, blockedEdge) + ...
    ( t< obstacleWindow(1) || t> obstacleWindow(2) ) ...
      * L_base;

% ——工具：删边的拉普拉斯更新
function L_new = removeEdge(L_old, edge)
    i = edge(1); j = edge(2);
    if L_old(i,j)==0            % 若本就无边，则保持不变
        L_new = L_old;
    else
        L_new       = L_old;
        L_new(i,j)  = 0;
        L_new(j,i)  = 0;        % 对称图
        L_new(i,i)  = L_new(i,i) + 1;
        L_new(j,j)  = L_new(j,j) - 1;
    end
end
%% ================== 4. 统一仿真函数 ==================
% 输入：基础L、障碍边、拓扑名称
function xHist = simulateConsensus(L_base, blockedEdge, topoName)
    global getL dt N_step t_vec
    xHist        = zeros(3, N_step+1);
    xHist(:,1)   = [3; -1; 0];       % 初始状态
    for k = 1:N_step
        t  = t_vec(k);
        Lk = getL(t, L_base, blockedEdge);      % 当前拓扑
        xHist(:,k+1) = xHist(:,k) - dt * Lk * xHist(:,k);
        xHist(1,k+1) = xHist(1,1);              % 领导者固定
    end
    fprintf('%s 拓扑仿真完成。\n', topoName);
end

%% ================== 5. 执行仿真 ==================
global getL dt N_step t_vec    % 使匿名函数可见
x_star  = simulateConsensus(L_star_base,  blockedEdges_star,  '星型-受阻');
x_chain = simulateConsensus(L_chain_base, blockedEdges_chain, '链式-受阻');

%% ================== 6. 结果绘图（中文） ==================
figure;

subplot(2,1,1);
stairs(t_vec, x_star(1,:), 'LineWidth',1.2); hold on;
stairs(t_vec, x_star(2,:), 'LineWidth',1.2);
stairs(t_vec, x_star(3,:), 'LineWidth',1.2);
xlabel('时间 / 秒'); ylabel('状态值');
title('领导-跟随一致性（星型拓扑-障碍物干扰）');
legend('x_1（领导者）','x_2（跟随者1）','x_3（跟随者2）','Location','best'); grid on;

subplot(2,1,2);
stairs(t_vec, x_chain(1,:), 'LineWidth',1.2); hold on;
stairs(t_vec, x_chain(2,:), 'LineWidth',1.2);
stairs(t_vec, x_chain(3,:), 'LineWidth',1.2);
xlabel('时间 / 秒'); ylabel('状态值');
title('领导-跟随一致性（链式拓扑-障碍物干扰）');
legend('x_1（领导者）','x_2（跟随者1）','x_3（跟随者2）','Location','best'); grid on;
