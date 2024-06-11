// ~/ffalh/ffref/Examples/RotatingHill2.m4
// =======================================
// 
// Originally from [[https://doc.freefem.org/tutorials/rotatingHill.html]]
// Adapted by Antoine Le Hyaric ([[http://www.ljll.fr/lehyaric]])
// 
// [[elisp:(progn (org-link-minor-mode) (setq org-link-descriptive nil) (org-toggle-link-display))][hide links]] [[elisp:(progn (org-link-minor-mode) (setq org-link-descriptive t) (org-toggle-link-display))][show links]] [[elisp:(alh-1dex-open)][open 1dex]] [[elisp:(alh-1dex-update)][update 1dex]]
// [[elisp:(alh-set-keywords)][set keywords]] ([[file:~/alh/bin/headeralh][headeralh]])
// emacs-keywords adapted edp nofaces origin=[[https://doc.freefem.org/tutorials/rotatingHill.html]] start=08/10/21 update=10/06/24

// Parameters
real al=0.5;
real dt = 0.05;

// Mesh
border C(t=0., 2.*pi) {x=cos(t); y=sin(t);};
mesh Th = buildmesh(C(100));

// Fespace
fespace Vh(Th,P1dc);
Vh w, ccold, v1 = y, v2 = -x, cc = exp(-10*((x-0.3)^2 +(y-0.3)^2));

// Macro
macro n() (N.x*v1 + N.y*v2) // Macro without parameter

// Problem
problem Adual(cc, w)
    = int2d(Th)(
          (cc/dt+(v1*dx(cc)+v2*dy(cc)))*w
    )
    + intalledges(Th)(
          (1-nTonEdge)*w*(al*abs(n)-n/2)*jump(cc)
    )
    - int2d(Th)(
          ccold*w/dt
    )
    ;

// Time iterations
for (real t = 0.; t < 2.*pi; t += dt){
    ccold = cc;
    Adual;
    plot(cc, fill=1, cmm="t="+t+", min="+cc[].min+", max="+ cc[].max);
}

// Plot
real [int] viso = [-0.2, -0.1, 0., 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1., 1.1];
plot(cc, wait=1, fill=1, ps="test_ConvectCG.eps", viso=viso);
plot(cc, wait=1, fill=1, ps="test_ConvectDG.eps", viso=viso);

// [[elisp:(compile "cd .. && ./history -default -run -db Examples/RotatingHill2")]] => [[file:RotatingHill2.default.out]]
// [[elisp:(compile "cd .. && ./history -ffjs -run -db Examples/RotatingHill2")]] => [[file:RotatingHill2.ffjs_dev.out]]
// [[file:../history.db::Examples/RotatingHill2]]
// [[elisp:(compile "FreeFem++ RotatingHill2.edp")]]

real ref=int2d(Th)(cc);
CHECKREFREL(ref,0.311385,1e-3);
VERSION(v2);
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
