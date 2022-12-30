%EE3006.01 ��������ƴ�ʵ��
%������ PB20061256

%constants define
const_m=0.03;
const_g=9.81;
I_x=1.5e-5;
I_y=1.5e-5;
I_z=3e-5;
k_force=4.5e-3;
k_intertia=4.5e-4;
const_zd=2;
const_psid=pi/4;

%variables define
syms t s; %for time domain and freq domain
t_interval=0.1;
t_upper=100;

syms x y z delta_z psi x_dot y_dot z_dot  phi theta delta_psi p q r;
delta_z=z-const_zd;
delta_psi=psi-const_psid;
cond_X=[x y delta_z x_dot y_dot z_dot  phi theta delta_psi p q r]';

syms delta_u1 u1 u2 u3 u4;
delta_u1=u1-const_m*const_g;
input_U=[delta_u1 u2 u3 u4]';

output_Y=[x y delta_z delta_psi]';

%matrix define
%{
    X'=A*X+B*U
    Y=C*X
%}
A=zeros(12);
A(1:3,4:6)=eye(3);
A(4:6,4:6)=eye(3).*(-k_force/const_m);
A(4:5,7:8)=[sin(const_psid) cos(const_psid);-cos(const_psid) sin(const_psid)].*const_g;
A(10:12,7:9)=eye(3);
A(10:12,10:12)=diag([1/I_x 1/I_y 1/I_z]).*(-k_intertia);

B=zeros(12,4);
B(6,1)=1/const_m;
B(10:12,2:4)=diag([1/I_x 1/I_y 1/I_z]);

C=zeros(4,12);
C(1:3,1:3)=eye(3);
C(4,9)=1;

%Question 1
[eigVecMat,eigValMat]= eig(A);
eigVal=diag(eigValMat);



%Question 3
%{
    delta_psi(s)=sys_Gpsi(s)*u4(s)
%}
k1=1.5e-5;
k2=3e-5;
Gpsi_s=k1/(s^2+15*s-1);
Us=[k2  k2/s  k2/(s^2+1)];
Psi_s=Gpsi_s.*Us;
Psi_t=ilaplace(Psi_s);

figure;
hold on;
fplot(Psi_t,[0,t_upper]);
hold off;
grid on;
box on;

%Question 5
numG = [-0.03 59.9 200];
denG = [0.00003 0.03 59.9 200];
sysG = tf(numG, denG);
y = step(sysG)+1;
plot(y);


%Question 6
Td=[1,2,4];
Pi=[1,2,4];
color=['-r','-b','-g'];
sysG_pd=tf(0).*ones(1,3);
sysG_pi=tf(0).*ones(1,3);
for i =1:3
    sysG_pd(i)=tf([Td(i),1],[const_m,0,0]);
    sysG_pi(i)=tf([1,Pi(i)],[const_m,0,0,0]);
end


figure;
hold on;
for i=1:3
    sysG_c_pd(i)=feedback(sysG_pd(i),1);
    sysG_c_pi(i)=feedback(sysG_pi(i),1);
    rlocus(sysG_pd(i),color(i));
end
hold off;

%Question 7

kp=0.03;
Td=4;% swtich for 1,2,4
sysG_pd=tf([kp*Td,kp],[const_m,k_force,0]);
margin(sysG_pd);



