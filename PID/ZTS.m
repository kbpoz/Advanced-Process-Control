close all;
clc;

%% Sta³e
c = 6.0;
a = 9;

%% Parametry
%Temperatury [°C]
Tc0 = 19;
Th0 = 81;
Td0 = 42;
%Przep³yw [cm^3/s]
Fcin0 = 31;
Fhin0 = 19;
Fd0 = 14;
%CZASY POZIOM CIECZY [s]
th1 = 1000;
th2= 100;
th3 = 2000;
th4=500;
tend= 8000;
th5=tend -(th1+th2+th3+th4);

%CZASY TEMPERATURA [s]

tt1 = 2000;
tt2= 1000;
tt3 = 2000;
tt4=1000;
tt5=tend -(tt1+tt2+tt3+tt4);

%DANE POCZ¥TKOWE

F0 = Fcin0 + Fhin0 + Fd0;
h0 = (F0/a)^2;
T0 = (Fhin0*Th0 + Fcin0*Tc0 + Fd0*Td0)/(Fhin0 + Fcin0 + Fd0);

%% LINEARYZACJA

A = [ -2/(3* c * h0^3) *( Fhin0 + Fcin0 + Fd0 ) + a /(2* c * h0 ^(2.5)) 0;
    -3/( c * h0 ^ 4) *( Fhin0 *( Th0 - T0 ) + Fcin0 *( Tc0 - T0) +Fd0 *( Td0 - T0 )) -1/( c * h0 ^ 3) *( Fhin0 + Fcin0 + Fd0 )];

B = [1/(3* c * h0 ^ 2) 1/(3* c * h0 ^2) ;
    1/( c * h0 ^3) *( Th0 - T0 ) 1/( c * h0 ^3) *( Tc0 - T0 )];

Bd = [1/(3* c * h0 ^ 2) ; 1/( c* h0 ^ 3) *( Td0 - T0 ) ];

C = eye (2) ;

D = zeros (2 ,3) ;

xd = [B Bd];

%% Równania stanu
sys = ss(A, [B Bd], C, D);

%% Transmitancja
[b1,a1] = ss2tf(A, [B Bd], C, D, 1);
[b2,a2] = ss2tf(A, [B Bd], C, D, 2);
[b3,a3] = ss2tf(A, [B Bd], C, D, 3);

G(1,1)=tf(b1(1,:),a1);
G(2,1)=tf(b1(2,:),a1);
G(1,2)=tf(b2(1,:),a2);
G(2,2)=tf(b2(2,:),a2);
G(1,3)=tf(b3(1,:),a3);
G(2,3)=tf(b3(2,:),a3);

G;

%% Zmiana na model dyskretny
Tp=1; %czas próbkowania
sysd = c2d(sys,Tp);
AD = get(sysd,'A');
BD = get(sysd,'B');
CD = get(sysd,'C');
DD = get(sysd,'D');

[bd1,md1] = ss2tf(AD, BD, CD, DD, 1);
[bd2,md2] = ss2tf(AD, BD, CD, DD, 2);
[bd3,md3] = ss2tf(AD, BD, CD, DD, 3);
Gd(1,1)=tf(bd1(1,:),md1,Tp);
Gd(2,1)=tf(bd1(2,:),md1,Tp);
Gd(1,2)=tf(bd2(1,:),md2,Tp);
Gd(2,2)=tf(bd2(2,:),md2,Tp);
Gd(1,3)=tf(bd3(1,:),md3,Tp);
Gd(2,3)=tf(bd3(2,:),md3,Tp);

Gd;
