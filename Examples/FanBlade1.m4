// ~/ffalh/ffref/Examples/FanBlade1.m4
// ===================================
// 
// Originally from [[https://doc.freefem.org/tutorials/fanBlade.html]]
// Adapted by Antoine Le Hyaric ([[http://www.ljll.fr/lehyaric]])
// 
// [[elisp:(progn (org-link-minor-mode) (setq org-link-descriptive nil) (org-toggle-link-display))][hide links]] [[elisp:(progn (org-link-minor-mode) (setq org-link-descriptive t) (org-toggle-link-display))][show links]] [[elisp:(alh-1dex-open)][open 1dex]] [[elisp:(alh-1dex-update)][update 1dex]]
// [[elisp:(alh-set-keywords)][set keywords]] ([[file:~/alh/bin/headeralh][headeralh]])
// emacs-keywords adapted edp nofaces origin=[[https://doc.freefem.org/tutorials/fanBlade.html]] start=08/10/21 update=10/06/24

// Parameters
int  S = 99;// wing label
// u infty
real theta = 8*pi/180;// // 1 degree on incidence =>  lift
real lift = theta*0.151952/0.0872665; //  lift approximation formula
real  uinfty1= cos(theta), uinfty2= sin(theta);
// Mesh
func naca12 = 0.17735*sqrt(x) - 0.075597*x - 0.212836*(x^2) + 0.17363*(x^3) - 0.06254*(x^4);
border C(t=0., 2.*pi){x=5.*cos(t); y=5.*sin(t);}
border Splus(t=0., 1.){x=t; y=naca12; label=S;}
border Sminus(t=1., 0.){x=t; y=-naca12; label=S;}
mesh Th = buildmesh(C(50) + Splus(70) + Sminus(70));

// Fespace
fespace Xh(Th, P2);
Xh psi, w;
macro grad(u) [dx(u),dy(u)]// def of grad operator
// Solve
solve potential(psi, w)
   = int2d(Th)(
        grad(psi)'*grad(w) //  scalar product
   )
   + on(C, psi = [uinfty1,uinfty2]'*[y,-x])
   + on(S, psi=-lift) // to get a correct value
   ;

plot(psi, wait=1);

// [[elisp:(compile "cd .. && ./history -default -run -db Examples/FanBlade1")]] => [[file:FanBlade1.default.out]]
// [[elisp:(compile "cd .. && ./history -ffjs -run -db Examples/FanBlade1")]] => [[file:FanBlade1.ffjs_dev.out]]
// [[file:../history.db::Examples/FanBlade1]]
// [[elisp:(compile "FreeFem++ FanBlade1.edp")]]

real ref=int2d(Th)(abs(psi));
CHECKREFREL(ref,165.9,1e-3);
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
