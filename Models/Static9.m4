// ~/ffalh/ffref/Models/Static9.m4
// ===============================
// 
// Originally from [[https://doc.freefem.org/models/static-problems.html]]
// Adapted by Antoine Le Hyaric ([[http://www.ljll.fr/lehyaric]])
// 
// [[elisp:(progn (org-link-minor-mode) (setq org-link-descriptive nil) (org-toggle-link-display))][hide links]] [[elisp:(progn (org-link-minor-mode) (setq org-link-descriptive t) (org-toggle-link-display))][show links]] [[elisp:(alh-1dex-open)][open 1dex]] [[elisp:(alh-1dex-update)][update 1dex]]
// [[elisp:(alh-set-keywords)][set keywords]] ([[file:~/alh/bin/headeralh][headeralh]])
// emacs-keywords adapted edp nofaces origin=[[https://doc.freefem.org/models/static-problems.html]] start=08/10/21 update=10/06/24

// Parameters
func f = -2*30*(x^2+y^2); //given function
//the singular term of the solution is K*us (K: constant)
func us = sin(atan2(y,x)/2)*sqrt( sqrt(x^2+y^2) );
real K = 10.;
func ue = K*us + 30*(x^2*y^2);

// Mesh
border N(t=0, 1){x=-1+t; y=0; label=1;};
border D1(t=0, 1){x=t; y=0; label=2;};
border D2(t=0, 1){x=1; y=t; label=2;};
border D3(t=0, 2){x=1-t; y=1; label=2;};
border D4(t=0, 1){x=-1; y=1-t; label=2;};

mesh T0h = buildmesh(N(10) + D1(10) + D2(10) + D3(20) + D4(10));
plot(T0h, wait=true);

// Fespace
fespace V0h(T0h, P1);
V0h u0, v0;

//Problem
solve Poisson0 (u0, v0)
    = int2d(T0h)(
        dx(u0)*dx(v0)
        + dy(u0)*dy(v0)
    )
    - int2d(T0h)(
        f*v0
    )
    + on(2, u0=ue)
    ;

// Mesh adaptation by the singular term
mesh Th = adaptmesh(T0h, us);
for (int i = 0; i < 5; i++)
mesh Th = adaptmesh(Th, us);

// Fespace
fespace Vh(Th, P1);
Vh u, v;

// Problem
solve Poisson (u, v)
    = int2d(Th)(
        dx(u)*dx(v)
        + dy(u)*dy(v)
    )
    - int2d(Th)(
        f*v
    )
    + on(2, u=ue)
    ;

// Plot
plot(Th);
plot(u, wait=true);

// Error in H1 norm
Vh uue = ue;
real H1e = sqrt( int2d(Th)(dx(uue)^2 + dy(uue)^2 + uue^2) );
Vh err0 = u0 - ue;
Vh err = u - ue;
Vh H1err0 = int2d(Th)(dx(err0)^2 + dy(err0)^2 + err0^2);
Vh H1err = int2d(Th)(dx(err)^2 + dy(err)^2 + err^2);
cout << "Relative error in first mesh = "<< int2d(Th)(H1err0)/H1e << endl;
cout << "Relative error in adaptive mesh = "<< int2d(Th)(H1err)/H1e << endl;

real ref=u[]'*u[];
CHECKREFREL(ref,11709.9,1e-5);

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
