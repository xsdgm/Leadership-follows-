clc;
clear all;
N=4;
stepsize=0.02;
%梯度
syms x1 x2 x3;
% f=[3*x1^2+3;exp(x2)+x2^2-5*x2-1;x3^2-2*x3-3];
% %f=[x1^4;(x2-2)^2*log(1+x2^2);5*exp(0.2*x3)];
% % f=[x1^4;5*exp(0.2*x2);(x3-3)^2*log(3+x3^2)];
% for i = 1:length(f)
% g(i,1)=diff(f(i))
% end

%初始化
 
%L=[1,-1,0;-1,2,-1;0,-1,1];
L1=[2,-1,0;-1,1,-1;-1,0,1];
L2=[1,-1,0;-1,2,-1;-1,0,1];
%L=[1,-0.3,-0.4;-0.2,1,-0.6;-0.8,-0.7,1];
xl=zeros(3,N/stepsize);
u=zeros(3,N/stepsize);
z=zeros(3,N/stepsize);
w=zeros(3,N/stepsize);
y=zeros(3,N/stepsize);
v=zeros(3,N/stepsize);
xl(1:2,1)=[3;-1];
xl(3,1)=0;
z(1:2,1)=[0;0];
z(3,1)=3;
y(:,1)=[1;1;1];
%参数选择
k1=1;
k2=1;
%触发参数

t2=2;
t4=10;
%算法
% for i=1:N-1
%      [x1,x2,x3]=deal(xl(1,i),xl(2,i),xl(3,i));
%     a=subs(g);
%     y(:,i+1)=y(:,i)-L*y(:,i);
%       xl(:,i+1)=xl(:,i)-k2*a;
%       xl(:,i+1)=xl(:,i+1)-0.1*L*xl(:,i+1)-z(:,i);
%        z(:,i+1)=z(:,i)+k1*k2*L*xl(:,i+1);
%        
%          for j=1:3
%       v(j,i+1)= xl(j,i+1)/y(j,i+1);
%      end
%         x=xl(:,i+1)-xl(:,i); if(norm(x)<0.1*norm(xl(:,i)))
%              xl(:,i+1)=xl(:,i)
%        end
% end
for i=1:N/stepsize
  
%      [x1,x2,x3]=deal(xl(1,i),xl(2,i),xl(3,i));
%     a=subs(g);
      xl(:,i+1)=xl(:,i)-stepsize*L1*L2*(xl(:,i));
%            w(:,i+1)=w(:,i)-stepsize*L*w(:,i)+z(:,i)+stepsize*v(:,i);
%        v(:,i+1)=v(:,i)-stepsize*L1*v(:,i)-w(:,i+1)+w(:,i); 
          
      
 end
     
   
     
     
     
     
%作图


t=0:stepsize:N;
figure;
% plot(t,xl(1,1:end),'b');
% hold on;
% plot(t,xl(2,1:end),'g');
% hold on;
% plot(t,xl(3,1:end),'r');
 stairs(t,xl(1,1:end),'b'); 
hold on; 
stairs(t,xl(2,1:end),'g');
hold on;
stairs(t,xl(3,1:end),'r');
legend('x_1','x_2','x_3');

xlabel('time/s'); 
ylabel('x_i'); 
