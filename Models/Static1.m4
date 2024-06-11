// ~/ffalh/ffref/Models/Static1.m4
// ===============================
// 
// Originally from [[https://doc.freefem.org/models/static-problems.html]]
// Adapted by Antoine Le Hyaric ([[http://www.ljll.fr/lehyaric]])
// 
// Sorbonne Université, CNRS, Laboratoire Jacques-Louis Lions, F-75005, Paris, France
// 
// [[elisp:(progn (org-link-minor-mode) (setq org-link-descriptive nil) (org-toggle-link-display))][hide links]] [[elisp:(progn (org-link-minor-mode) (setq org-link-descriptive t) (org-toggle-link-display))][show links]] [[elisp:(alh-1dex-open)][open 1dex]] [[elisp:(alh-1dex-update)][update 1dex]]
// [[elisp:(alh-set-keywords)][set keywords]] ([[file:~/alh/bin/headeralh][headeralh]])
// emacs-keywords adapted edp nofaces origin=[[https://doc.freefem.org/models/static-problems.html]] start=08/10/21 univ update=10/06/24

// Parameters
int nn = 50;
func f = -1;
func ue = (x^2+y^2-1)/4; //ue: exact solution

// Mesh
border a(t=0, 2*pi){x=cos(t); y=sin(t); label=1;}
mesh disk = buildmesh(a(nn));
plot(disk);

// Fespace
fespace femp1(disk, P1);
femp1 u, v;

// Problem
problem laplace (u, v)
    = int2d(disk)( //bilinear form
        dx(u)*dx(v)
        + dy(u)*dy(v)
    )
    - int2d(disk)( //linear form
        f*v
    )
    + on(1, u=0) //boundary condition
    ;

// Solve
laplace;

// Plot
plot (u, value=true, wait=true);

// Error
femp1 err = u - ue;
plot(err, value=true, wait=true);

cout << "error L2 = " << sqrt( int2d(disk)(err^2) )<< endl;
cout << "error H10 = " << sqrt( int2d(disk)((dx(u)-x/2)^2) + int2d(disk)((dy(u)-y/2)^2) )<< endl;

// Re-run with a mesh adaptation

// Mesh adaptation
disk = adaptmesh(disk, u, err=0.01);
plot(disk, wait=true);

// Solve
laplace;
plot (u, value=true, wait=true);

// Error
err = u - ue; //become FE-function on adapted mesh
plot(err, value=true, wait=true);

cout << "error L2 = " << sqrt( int2d(disk)(err^2) )<< endl;
cout << "error H10 = " << sqrt( int2d(disk)((dx(u)-x/2)^2) + int2d(disk)((dy(u)-y/2)^2) )<< endl;

real ref=u[]'*u[];
CHECKREFREL(ref,16.3804,1e-5);

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
