// ~/ffalh/ffref/Models/Static3.m4
// ===============================
// 
// Originally from [[https://doc.freefem.org/models/static-problems.html]]
// Adapted by Antoine Le Hyaric ([[http://www.ljll.fr/lehyaric]])
// 
// [[elisp:(progn (org-link-minor-mode) (setq org-link-descriptive nil) (org-toggle-link-display))][hide links]] [[elisp:(progn (org-link-minor-mode) (setq org-link-descriptive t) (org-toggle-link-display))][show links]] [[elisp:(alh-1dex-open)][open 1dex]] [[elisp:(alh-1dex-update)][update 1dex]]
// [[elisp:(alh-set-keywords)][set keywords]] ([[file:~/alh/bin/headeralh][headeralh]])
// emacs-keywords adapted edp nofaces origin=[[https://doc.freefem.org/models/static-problems.html]] start=08/10/21 update=10/06/24

// Mesh
border a(t=0, 2*pi){x=5*cos(t); y=5*sin(t);}
border upper(t=0, 1) {
    x=t;
    y=0.17735*sqrt(t)-0.075597*t - 0.212836*(t^2) + 0.17363*(t^3) - 0.06254*(t^4);
}
border lower(t=1, 0) {
    x=t;
    y=-(0.17735*sqrt(t) - 0.075597*t - 0.212836*(t^2) + 0.17363*(t^3) - 0.06254*(t^4));
}
border c(t=0, 2*pi){x=0.8*cos(t)+0.5; y=0.8*sin(t);}

mesh Zoom = buildmesh(c(30) + upper(35) + lower(35));
mesh Th = buildmesh(a(30) + upper(35) + lower(35));

// Fespace
fespace Vh(Th, P2);
Vh psi0, psi1, vh;

fespace ZVh(Zoom, P2);

// Problem
solve Joukowski0(psi0, vh)
    = int2d(Th)(
        dx(psi0)*dx(vh)
        + dy(psi0)*dy(vh)
    )
    + on(a, psi0=y-0.1*x)
    + on(upper, lower, psi0=0)
    ;

plot(psi0);

solve Joukowski1(psi1,vh)
    = int2d(Th)(
        dx(psi1)*dx(vh)
        + dy(psi1)*dy(vh)
    )
    + on(a, psi1=0)
    + on(upper, lower, psi1=1);

plot(psi1);

//continuity of pressure at trailing edge
real beta = psi0(0.99,0.01) + psi0(0.99,-0.01);
beta = -beta / (psi1(0.99,0.01) + psi1(0.99,-0.01)-2);

Vh psi = beta*psi1 + psi0;
plot(psi);

ZVh Zpsi = psi;
plot(Zpsi, bw=true);

ZVh cp = -dx(psi)^2 - dy(psi)^2;
plot(cp);

ZVh Zcp = cp;
plot(Zcp, nbiso=40);

real ref=psi[]'*psi[];
CHECKREFREL(ref,4111.7,1e-5);

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
