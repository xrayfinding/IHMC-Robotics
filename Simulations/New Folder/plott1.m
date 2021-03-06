clc, clear all, close all;
kp=300;kd=20;
vmax=200;
Km=[kp kd];
ksys=39.478;
bsys=6.283;

Asys=[0 1;-ksys -bsys];Aa=[Asys,[0;ksys];zeros(1,3)];Bsysa=[0;0;1];Bsys=[0;ksys];
nbar=Km*(Asys-Bsys*Km);

ecr1=[nbar;nbar*(Asys-Bsys*Km)]^-1*[vmax;0];
ecr2=[nbar;nbar*(Asys-Bsys*Km)]^-1*[-vmax;0];
ecr=[ecr1 ecr2];Fcr=-Km*ecr;


emax=1000;Ne1=2;
e1v=linspace(-0.02,0.02,Ne1);
e2v=(vmax-nbar(1)*e1v)/nbar(2);
% e1v=10^3*[-0.000099787228270   0.000378816629381  ];
% e2v=10^3*[0.001309165048770  -0.005965350304023];
for inp=1:Ne1
e1=e1v(inp);
e2=e2v(inp);
e0=[e1;e2];
xa0=[e0;-Km*e0];
Opt=odeset('RelTol',1e-6,'AbsTol',1e-7,'Events',@(t,x)EOutvpi(t,x,emax));
[t,X]=ode45(@(t,x) massforclim(t,x),[0 1],xa0,Opt);


Xa=X';
figure(2)
plot3(Xa(1,:),Xa(2,:),Xa(3,:)), hold on, grid on
plot3(Xa(1,1),Xa(2,1),Xa(3,1),'or')
plot3(Xa(1,end),Xa(2,end),Xa(3,end),'ok')

%plot3(ecr(1,:),ecr(2,:),Fcr,'x');

pause(eps)
end

%[xx,yy]=ndgrid(linspace(min(Xa(1,:)),max(Xa(1,:)),2),linspace(min(Xa(2,:)),max(Xa(2,:)),2));
[xx,yy]=ndgrid(linspace(min(e1v),max(e1v),2),linspace(min(e2v),max(e2v),2));
zz=(-Km(1)*xx-Km(2)*yy);
%xpl=[min(Xa(1,:)) max(Xa(1,:))];%xpl=[ecr2(1) ecr1(1)];
xpl=[min(e1v) max(e1v)]
ypl1=(vmax-nbar(1)*xpl)/nbar(2);
ypl2=(-vmax-nbar(1)*xpl)/nbar(2);
zpl1=(-Km(1)*xpl-Km(2)*ypl1);zpl2=(-Km(1)*xpl-Km(2)*ypl2);
plot3(xpl,ypl1,zpl1);plot3(xpl,ypl2,zpl2)
surf(xx,yy,zz)

xlabel('e')
ylabel('de')
zlabel('F')