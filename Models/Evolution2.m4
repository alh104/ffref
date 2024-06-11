// ~/ffalh/ffref/Models/Evolution2.m4
// ==================================
// 
// Originally from [[https://doc.freefem.org/models/evolution-problems.html]]
// Adapted by Antoine Le Hyaric ([[http://www.ljll.fr/lehyaric]])
// 
// Sorbonne Université, CNRS, Laboratoire Jacques-Louis Lions, F-75005, Paris, France
// 
// [[elisp:(progn (org-link-minor-mode) (setq org-link-descriptive nil) (org-toggle-link-display))][hide links]] [[elisp:(progn (org-link-minor-mode) (setq org-link-descriptive t) (org-toggle-link-display))][show links]] [[elisp:(alh-1dex-open)][open 1dex]] [[elisp:(alh-1dex-update)][update 1dex]]
// [[elisp:(alh-set-keywords)][set keywords]] ([[file:~/alh/bin/headeralh][headeralh]])
// emacs-keywords adapted edp nofaces origin=[[https://doc.freefem.org/models/evolution-problems.html]] start=08/10/21 univ update=10/06/24

// Parameters
real tau = 0.1; real
theta = 0.;

// Mesh
mesh Th = square(12, 12);

// Fespace
fespace Vh(Th, P1);
Vh u, v, oldU;
Vh f1, f0;

fespace Ph(Th, P0);
Ph h = hTriangle; // mesh sizes for each triangle

// Function
func real f (real t){
    return x^2*(x-1)^2 + t*(-2 + 12*x - 11*x^2 - 2*x^3 + x^4);
}

// File
ofstream out("test_err02.csv"); //file to store calculations
out << "mesh size = " << h[].max << ", time step = " << tau << endl;
for (int n = 0; n < 5/tau; n++)
    out << n*tau << ",";
out << endl;

// Problem
problem aTau (u, v)
    = int2d(Th)(
          u*v
        + theta*tau*(dx(u)*dx(v) + dy(u)*dy(v) + u*v)
    )
    - int2d(Th)(
          oldU*v
        - (1-theta)*tau*(dx(oldU)*dx(v) + dy(oldU)*dy(v) + oldU*v)
    )
    - int2d(Th)(
          tau*(theta*f1 + (1-theta)*f0)*v
    )
    ;

// Theta loop
while (theta <= 1.0){
    real t = 0;
    real T = 3;
    oldU = 0;
    out << theta << ",";
    for (int n = 0; n < T/tau; n++){
        // Update
        t = t + tau;
        f0 = f(n*tau);
        f1 = f((n+1)*tau);

        // Solve
        aTau;
        oldU = u;

        // Plot
        plot(u);

        // Error
        Vh uex = t*x^2*(1-x)^2; //exact solution = tx^2(1-x)^2
        Vh err = u - uex; // err = FE-sol - exact
        out << abs(err[].max)/abs(uex[].max) << ",";
    }
    out << endl;
    theta = theta + 0.1;
}

real ref=u[]'*u[];
CHECKREFREL(ref,1.4753,1e-6);

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
