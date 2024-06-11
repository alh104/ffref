// ~/ffalh/ffref/Models/NavierStokes2.m4
// =====================================
// 
// Originally from [[https://doc.freefem.org/models/navier-stokes-equations.html]]
// Adapted by Antoine Le Hyaric ([[http://www.ljll.fr/lehyaric]])
// 
// [[elisp:(progn (org-link-minor-mode) (setq org-link-descriptive nil) (org-toggle-link-display))][hide links]] [[elisp:(progn (org-link-minor-mode) (setq org-link-descriptive t) (org-toggle-link-display))][show links]] [[elisp:(alh-1dex-open)][open 1dex]] [[elisp:(alh-1dex-update)][update 1dex]]
// [[elisp:(alh-set-keywords)][set keywords]] ([[file:~/alh/bin/headeralh][headeralh]])
// emacs-keywords adapted edp nofaces origin=[[https://doc.freefem.org/models/navier-stokes-equations.html]] start=08/10/21 update=10/06/24

// Mesh
mesh Th = square(10, 10);

// Fespace
fespace Xh(Th, P2);
Xh u1, u2;
Xh bc1, bc2;
Xh b;

fespace Mh(Th, P1);
Mh p;
Mh ppp; //ppp is a working pressure

// Problem
varf bx (u1, q) = int2d(Th)(-(dx(u1)*q));
varf by (u1, q) = int2d(Th)(-(dy(u1)*q));
varf a (u1, u2)
= int2d(Th)(
          dx(u1)*dx(u2)
        + dy(u1)*dy(u2)
    )
    + on(3, u1=1)
    + on(1, 2, 4, u1=0) ;
//remark: put the on(3,u1=1) before on(1,2,4,u1=0)
//because we want zero on intersection

matrix A = a(Xh, Xh, solver=CG);
matrix Bx = bx(Xh, Mh); //B=(Bx, By)
matrix By = by(Xh, Mh);

bc1[] = a(0,Xh); //boundary condition contribution on u1
bc2 = 0; //no boundary condition contribution on u2

//p_h^n -> B A^-1 - B^* p_h^n = -div u_h
//is realized as the function divup
func real[int] divup (real[int] & pp){
    //compute u1(pp)
    b[] = Bx'*pp;
    b[] *= -1;
    b[] += bc1[];
    u1[] = A^-1*b[];
    //compute u2(pp)
    b[] = By'*pp;
    b[] *= -1;
    b[] += bc2[];
    u2[] = A^-1*b[];
    //u^n = (A^-1 Bx^T p^n, By^T p^n)^T
    ppp[] = Bx*u1[]; //ppp = Bx u_1
    ppp[] += By*u2[]; //+ By u_2

    return ppp[] ;
}

// Initialization
p=0; //p_h^0 = 0
LinearCG(divup, p[], eps=1.e-6, nbiter=50); //p_h^{n+1} = p_h^n + B u_h^n
// if n> 50 or |p_h^{n+1} - p_h^n| <= 10^-6, then the loop end
divup(p[]); //compute the final solution

plot([u1, u2], p, wait=1, value=true, coef=0.1);

real ref=p[]'*p[];
CHECKREFREL(ref,58411.8,1e-6);

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
