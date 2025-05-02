%% ====================== 通信延迟一致性仿真 ============================
% 目标：考察通信时延 τ 对三节点领导-跟随系统一致性性能的影响
%      τ ∈ {0, 0.1, 0.3, 0.5} s，其余参数与领导者轨迹保持不变
% 拓扑：星型（Leader x1 直接广播至 x2、x3），可按需替换成链式
% MATLAB  R2021a
% =====================================================================

clc; clear; rng(2025);
T_end = 4;     dt = 0.02;                 % 总时长与采样步长
N     = T_end/dt;                         % 离散步数
t     = 0:dt:T_end;                       % 时间向量

%% ---------- 1. 星型拓扑拉普拉斯 -------------------------------------
L_star = [0  0  0 ;
          -1 1  0 ;
          -1 0  1];

%% ---------- 2. 时延列表 ---------------------------------------------
tau_list   = [0, 0.1, 0.3, 0.5];          % 单位：秒
delay_step = round(tau_list/dt);          % 换算成离散步

%% ---------- 3. 主仿真函数 -------------------------------------------
function X = simulate_delay(L, d_step, dt, N)
    X          = zeros(3, N+1);           % 3×(N+1) 状态记录
    X(:,1)     = [3; -1; 0];              % 初始状态
    for k = 1:N
        idx_del = max(k-d_step, 0) + 1;   % 被引用的“时延索引”（1 基）
        X(:,k+1) = X(:,k) - dt*L*X(:,idx_del);
        X(1,k+1) = X(1,1);                % 领导者状态恒定
    end
end

%% ---------- 4. 逐 τ 仿真 --------------------------------------------
X_all = cell(length(tau_list),1);
for m = 1:length(tau_list)
    X_all{m} = simulate_delay(L_star, delay_step(m), dt, N);
    fprintf('τ = %.1f s 仿真完成，离散延迟 %d 步。\n', ...
            tau_list(m), delay_step(m));
end

%% ---------- 5. 绘图 ---------------------------------------------------
figure;
for m = 1:length(tau_list)
    subplot(2,2,m);
    plot(t, X_all{m}(2,:), 'LineWidth',1.1); hold on;
    plot(t, X_all{m}(3,:), 'LineWidth',1.1);
    title(sprintf('通信时延 τ = %.1f s', tau_list(m)));
    xlabel('时间 / 秒'); ylabel('状态值');
    grid on; ylim([-1 3.2]);
    legend('x_2（跟随者1）','x_3（跟随者2）','Location','best');
end
sgtitle('星型拓扑下通信时延对一致性性能的影响');
