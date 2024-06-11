// ~/ffalh/ffref/Examples/RotatingHill3.m4
// =======================================
// 
// Originally from [[https://doc.freefem.org/tutorials/rotatingHill.html]]
// Adapted by Antoine Le Hyaric ([[http://www.ljll.fr/lehyaric]])
// 
// Sorbonne Université, CNRS, Laboratoire Jacques-Louis Lions, F-75005, Paris, France
// 
// [[elisp:(progn (org-link-minor-mode) (setq org-link-descriptive nil) (org-toggle-link-display))][hide links]] [[elisp:(progn (org-link-minor-mode) (setq org-link-descriptive t) (org-toggle-link-display))][show links]] [[elisp:(alh-1dex-open)][open 1dex]] [[elisp:(alh-1dex-update)][update 1dex]]
// [[elisp:(alh-set-keywords)][set keywords]] ([[file:~/alh/bin/headeralh][headeralh]])
// emacs-keywords adapted edp nofaces origin=[[https://doc.freefem.org/tutorials/rotatingHill.html]] start=08/10/21 univ update=10/06/24

// Mesh
border C(t=0., 2.*pi) {x=cos(t); y=sin(t);};
mesh Th = buildmesh(C(100));

fespace Vh(Th,P1);//P1,P2,P0,P1dc,P2dc, uncond stable

Vh vh,vo,u1 = y, u2 = -x, v = exp(-10*((x-0.3)^2 +(y-0.3)^2));
real dt = 0.03,t=0, tmax=2*pi, al=0.5, alp=200;

problem  A(v,vh) = int2d(Th)(v*vh/dt-v*(u1*dx(vh)+u2*dy(vh)))
  + intalledges(Th)(vh*(mean(v)*(N.x*u1+N.y*u2)
                   +alp*jump(v)*abs(N.x*u1+N.y*u2)))
  + int1d(Th,1)(((N.x*u1+N.y*u2)>0)*(N.x*u1+N.y*u2)*v*vh)
  - int2d(Th)(vo*vh/dt);

varf  Adual(v,vh) = int2d(Th)((v/dt+(u1*dx(v)+u2*dy(v)))*vh)
  + intalledges(Th)((1-nTonEdge)*vh*(al*abs(N.x*u1+N.y*u2)
                             -(N.x*u1+N.y*u2)/2)*jump(v));

varf rhs(vo,vh)= int2d(Th)(vo*vh/dt);

real[int] viso=[-0.1,0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1,1.1];

matrix AA=Adual(Vh,Vh,solver=GMRES);
matrix BB=rhs(Vh,Vh);

for ( t=0; t< tmax ; t+=dt)
{
   vo[]=v[];
   vh[]=BB*vo[];
   v[]=AA^-1*vh[];
   plot(v,fill=0,viso=viso,cmm=" t="+t + ", min=" + v[].min + ", max=" +  v[].max);
};

// [[elisp:(compile "cd .. && ./history -default -run -db Examples/RotatingHill3")]] => [[file:RotatingHill3.default.out]]
// [[elisp:(compile "cd .. && ./history -ffjs -run -db Examples/RotatingHill3")]] => [[file:RotatingHill3.ffjs_dev.out]]
// [[file:../history.db::Examples/RotatingHill3]]
// [[elisp:(compile "FreeFem++ RotatingHill3.edp")]]

real ref=int2d(Th)(v);
CHECKREFREL(ref,0.311389,1e-3);
VERSION(v3);
TESTLEVEL(+);

// Local Variables:
// mode:ff++
// c-basic-offset:2
// eval:(visual-line-mode t)
// coding:utf-8
// eval:(flyspell-prog-mode)
// eval:(outline-minor-mode)
// eval:(org-link-minor-mode)
// End:
// LocalWords: emacs
