%% ========================== 通信丢失一致性仿真 ==========================
% 目标：在“星型”与“链式”两种拓扑下，引入随机丢包机制（Bernoulli 失边），
%       评估多智能体系统一致性性能的鲁棒性。
% 作者：————
% MATLAB 版本：R2021a
% =======================================================================

clc; clear; rng(2025);                    % 固定随机种子便于复现
T_end  = 4;  dt = 0.02;  N = T_end/dt;    % 仿真步长与总步数
t_vec  = 0:dt:T_end;

%% ---------- 1. 拓扑基矩阵与对应可丢失边列表 ---------------------------
L_star_base  = [0  0  0 ;                 % 星型：Leader→所有跟随者
               -1  1  0 ;
               -1  0  1 ];
edgeList_star  = [2 1 ; 3 1];             % 可丢失无向边(节点i,节点j)

L_chain_base = [0  0  0 ;                 % 链式：Leader→F1→F2
               -1  1  0 ;
                0 -1  1 ];
edgeList_chain = [2 1 ; 3 2];

%% ---------- 2. 丢包概率设置 -------------------------------------------
p_loss = 0.10;          % 单条边单步丢失概率，可自行修改

%% ---------- 3. 去边工具 -------------------------------------------------
removeEdge = @(L,i,j) ...                % 删除(i,j)双向边，并修正对角线
    (L(i,j)==0).*L + (L(i,j)~=0).*( ...
        (L - sparse([i j],[j i],[L(i,j) L(j,i)],3,3)) + ...
        sparse([i j],[i j],[L(i,j) L(j,i)],3,3) );

%% ---------- 4. 仿真函数 -------------------------------------------------
function X = runConsensus(L0, edgeList, name, p_loss, dt, N, t_vec, removeEdge)
    X          = zeros(3,N+1);  X(:,1) = [3;-1;0];
    for k = 1:N
        L = L0;
        % --- 随机丢包：对 edgeList 中每条边做 Bernoulli 试验 ---
        for e = 1:size(edgeList,1)
            i = edgeList(e,1); j = edgeList(e,2);
            if rand < p_loss
                L = removeEdge(L,i,j);    % 本步失去该边
            end
        end
        % --- 一致性迭代 ---
        X(:,k+1) = X(:,k) - dt*L*X(:,k);
        X(1,k+1) = X(1,1);               % Leader 状态恒定
    end
    fprintf('%s 拓扑仿真完成（丢包率 %.2f）。\n', name, p_loss);
end

%% ---------- 5. 执行两种拓扑的仿真 -------------------------------------
X_star  = runConsensus(L_star_base,  edgeList_star,  '星型', p_loss, dt, N, t_vec, removeEdge);
X_chain = runConsensus(L_chain_base, edgeList_chain, '链式', p_loss, dt, N, t_vec, removeEdge);

%% ---------- 6. 绘图 -----------------------------------------------------
figure;
subplot(2,1,1);
stairs(t_vec, X_star(1,:), 'LineWidth',1.1); hold on;
stairs(t_vec, X_star(2,:), 'LineWidth',1.1);
stairs(t_vec, X_star(3,:), 'LineWidth',1.1);
title(sprintf('星型拓扑（丢包率 %.0f%%）',p_loss*100));
xlabel('时间 / 秒'); ylabel('状态值'); grid on;
legend('x_1（领导者）','x_2','x_3','Location','best');

subplot(2,1,2);
stairs(t_vec, X_chain(1,:), 'LineWidth',1.1); hold on;
stairs(t_vec, X_chain(2,:), 'LineWidth',1.1);
stairs(t_vec, X_chain(3,:), 'LineWidth',1.1);
title(sprintf('链式拓扑（丢包率 %.0f%%）',p_loss*100));
xlabel('时间 / 秒'); ylabel('状态值'); grid on;
legend('x_1（领导者）','x_2','x_3','Location','best');
