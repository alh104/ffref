// ~/ffalh/ffref/Models/Static2.m4
// ===============================
// 
// Originally from [[https://doc.freefem.org/models/static-problems.html]]
// Adapted by Antoine Le Hyaric ([[http://www.ljll.fr/lehyaric]])
// 
// [[elisp:(progn (org-link-minor-mode) (setq org-link-descriptive nil) (org-toggle-link-display))][hide links]] [[elisp:(progn (org-link-minor-mode) (setq org-link-descriptive t) (org-toggle-link-display))][show links]] [[elisp:(alh-1dex-open)][open 1dex]] [[elisp:(alh-1dex-update)][update 1dex]]
// [[elisp:(alh-set-keywords)][set keywords]] ([[file:~/alh/bin/headeralh][headeralh]])
// emacs-keywords adapted edp nofaces origin=[[https://doc.freefem.org/models/static-problems.html]] start=08/10/21 update=10/06/24

// Mesh
border C0(t=0, 2*pi){x=5*cos(t); y=5*sin(t);}
border C1(t=0, 2*pi){x=2+0.3*cos(t); y=3*sin(t);}
border C2(t=0, 2*pi){x=-2+0.3*cos(t); y=3*sin(t);}

mesh Th = buildmesh(C0(60) + C1(-50) + C2(-50));
plot(Th);

// Fespace
fespace Vh(Th, P1);
Vh uh, vh;

// Problem
problem Electro (uh, vh)
    = int2d(Th)( //bilinear
        dx(uh)*dx(vh)
        + dy(uh)*dy(vh)
    )
    + on(C0, uh=0) //boundary condition on C_0
    + on(C1, uh=1) //+1 volt on C_1
    + on(C2, uh=-1) //-1 volt on C_2
    ;

// Solve
Electro;
plot(uh);

real ref=uh[]'*uh[];
CHECKREFREL(ref,281.534,1e-5);

// v2: add a reference value
VERSION(v2);

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
