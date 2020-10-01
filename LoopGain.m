C = 0.000100;
L = 0.000150;
r = 0.000003;
R = 4;
sys_1 = idtf(48.6 * [r*C 1], [L*C*((r/R) +1) ((L/R)+C*r) 1]);
sys = sys_1;
tf(sys)
f = 75000;
w = 2*pi*f;
s = 1i*w;
[mag,phase] = bode(sys, w)
magdb = mag2db(mag)
bode(sys)