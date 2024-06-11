// ~/ffalh/ffref/Examples/Stokes.m4
// ================================
// 
// Originally from [[https://doc.freefem.org/tutorials/stokes.html]]
// Adapted by Antoine Le Hyaric ([[http://www.ljll.fr/lehyaric]])
// 
// [[elisp:(progn (org-link-minor-mode) (setq org-link-descriptive nil) (org-toggle-link-display))][hide links]] [[elisp:(progn (org-link-minor-mode) (setq org-link-descriptive t) (org-toggle-link-display))][show links]] [[elisp:(alh-1dex-open)][open 1dex]] [[elisp:(alh-1dex-update)][update 1dex]]
// [[elisp:(alh-set-keywords)][set keywords]] ([[file:~/alh/bin/headeralh][headeralh]])
// emacs-keywords adapted edp nofaces origin=[[https://doc.freefem.org/tutorials/stokes.html]] start=08/10/21 update=10/06/24

// Parameters
int nn = 30;

// Mesh
mesh Th = square(nn, nn);

// Fespace
fespace Uh(Th, P1b);
Uh u, v;
Uh uu, vv;

fespace Ph(Th, P1);
Ph p, pp;

// Problem
solve stokes ([u, v, p], [uu, vv, pp])
    = int2d(Th)(
          dx(u)*dx(uu)
        + dy(u)*dy(uu)
        + dx(v)*dx(vv)
        + dy(v)*dy(vv)
        + dx(p)*uu
        + dy(p)*vv
        + pp*(dx(u) + dy(v))
        - 1e-10*p*pp
    )
    + on(1, 2, 4, u=0, v=0)
    + on(3, u=1, v=0)
    ;

// Plot
plot([u, v], p, wait=1);

// [[elisp:(compile "cd .. && ./history -default -run -db Examples/Stokes")]] => [[file:Stokes.default.out]]
// [[elisp:(compile "cd .. && ./history -ffjs -run -db Examples/Stokes")]] => [[file:Stokes.ffjs_dev.out]]
// [[file:../history.db::Examples/Stokes]]
// [[elisp:(compile "FreeFem++ Stokes.edp")]]

real ref=int2d(Th)(u);
CHECKREFREL(ref, 0.0166667,1e-5);
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
