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

%Here calls the function for each question to plot target graph
%for example : Q5(50,30);
%Q9(0.1,1,0.1);
Q8(2e-12,10,0.1);

%Question 1
function [eigVal]=Q1()
    [eigVecMat,eigValMat]= eig(A);
    eigVal=diag(eigValMat);
end

%Question 3
%{
    delta_psi(s)=sys_Gpsi(s)*u4(s)
%}
function []=Q3(order,t_upper)
    syms t s;
    k1=(1/3)*10^5;
    k2=3e-5;
    Gpsi_s=k1/(s^2+15*s);
    Us=[k2  k2/s  k2/(s^2+1)];
    Psi_s=Gpsi_s.*Us;
    Psi_t=ilaplace(Psi_s,s,t);

    figure;
    hold on;
    fplot(Psi_t(order),[0,t_upper]);
    hold off;
    grid on;
    box on;
end

%Question 4
function Q4()
    syms t y;
    eq=dsolve('D2y+0.15*Dy+0.005*y=0','y(0)=1,Dy(0)=0','t');
    fplot(eq,[0 100]);

end

%Question 5
function Q5(kp,kd)
    T=1e-3;
    m=0.03;
    num=[-T,2];
    z0=1;
    den=[m*T, 2*m-T*kd, 2*kd-kp*T, 2*kp];
    sysG=tf(num,den);
    z_t=step(sysG)+z0;
    plot(z_t);
end

%Question 6
function Q6(order)
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
        %sysG_c_pi(i)=feedback(sysG_pi(i),1);
        rlocus(sysG_pd(order),color(i));
    end
    hold off;
end
%Question 7
function Q7(order)
    kp=0.03;
    Td=[1,2,4];
    sysG_pd=tf([kp*Td(order),kp],[const_m,k_force,0]);

    [Gm,Pm]=margin(sysG_pd);
end

%Question 8
function Q8(k,T,alpha)
    if(~exist('k','var'))
        k=2e-5;
        T=20;
        alpha=0.1;
    end
    num=9.81*k.*[T,1];
    den=conv([1,0.15,0,0],[alpha*T,1]);
    sysGo=tf(num,den);
    sysGc=feedback(sysGo,1);
    [Gm,Pm,Wcg,Wcp]=margin(sysGc);
    flag=(Pm>40 );
    fprintf('Pm=%f,Wcg=%f,If satisfy=%d\n',Pm,Wcg,flag);
    z_t=step(sysGc);
    plot(z_t);
end

%Question 9
function Q9(k,T,alpha)
    if(~exist('k','var')
	k=0.1;
	T=1;
	alpha=0.1;
    end
    num=49.05*k.*[T,1];
    den=conv([1,0.15,0],conv([1,5],[alpha*T,1]));
    sysGo=tf(num,den);
    sysGc=feedback(sysGo,1);
    [Gm,Pm,Wcg,Wcp]=margin(sysGc);
    finalvalue=1;
    [y,t]=step(sysGc);
    plot(t,y);
    [Ymax,k]=max(y);
    timetopeak=t(k);
    percentovershoot=100*(Ymax-finalvalue)/finalvalue;
    fprintf('Wcg=%f,tP=%f,percOS=%f\n',Wcg,timetopeak,percentovershoot);
end
