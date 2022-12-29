%EE3006.01 计算机控制大实验
%刘眭怿 PB20061256

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
t_upper=10;

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

%Question 2
%{
    delta_z=Y(3)=X(3)
    z''=-(3/20)*z'+delta_u1/0.03;
    delta_psi=Y(4)=X(9)
    r=psi_dot=psi'
    psi''=-15*psi'+psi-pi/4+u4/1.5e-5
%}

sys_Gz_t=dsolve('D2y=-(3/20)*Dy+t/0.03','y(0)=0,Dy(0)=0','t');
sys_Gz=laplace(sys_Gz_t,t,s);

sys_Gpsi_t=dsolve('D2y=-(15)*Dy+y-pi/4+t/1.5e-5','y(0)=0,Dy(0)=0','t');
sys_Gpsi=laplace(sys_Gpsi_t,t,s);

%Question 3
%{
    delta_psi(s)=sys_Gpsi(s)*u4(s)
%}

input_u4_t=3e-5 .*[ dirac(t) stepfun(t,0) sin(t)*stepfun(t,0)]';
input_u4_s=laplace(input_u4_t,t,s);
delta_psi_s=sys_Gpsi.*input_u4_s;
delta_psi_t=ilaplace(delta_psi_s,s,t);

figure;
hold on;
fplot(delta_psi_t,[0,t_upper]);
hold off;
grid on;
box on;

%Question 4

