// ~/ffalh/ffref/Examples/RotatingHill1.m4
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

// Parameters
real dt = 0.17;

// Mesh
border C(t=0., 2.*pi) {x=cos(t); y=sin(t);};
mesh Th = buildmesh(C(100));

// Fespace
fespace Uh(Th, P1);
Uh cold, c = exp(-10*((x-0.3)^2 +(y-0.3)^2));
Uh u1 = y, u2 = -x;

// Time loop
real t = 0;
for (int m = 0; m < 2.*pi/dt; m++){
    t += dt;
    cold = c;
    c = convect([u1, u2], -dt, cold);
    plot(c, cmm=" t="+t +", min="+c[].min+", max="+c[].max);
}

// [[elisp:(compile "cd .. && ./history -default -run -db Examples/RotatingHill1")]] => [[file:RotatingHill1.default.out]]
// [[elisp:(compile "cd .. && ./history -ffjs -run -db Examples/RotatingHill1")]] => [[file:RotatingHill1.ffjs_dev.out]]
// [[file:../history.db::Examples/RotatingHill1]]
// [[elisp:(compile "FreeFem++ RotatingHill1.edp")]]

real ref=int2d(Th)(c);
CHECKREFREL(ref,0.194521,2e-2);
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
