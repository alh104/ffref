// ~/ffalh/ffref/Models/Static4.m4
// ===============================
// 
// Originally from [[https://doc.freefem.org/models/static-problems.html]]
// Adapted by Antoine Le Hyaric ([[http://www.ljll.fr/lehyaric]])
// 
// [[elisp:(progn (org-link-minor-mode) (setq org-link-descriptive nil) (org-toggle-link-display))][hide links]] [[elisp:(progn (org-link-minor-mode) (setq org-link-descriptive t) (org-toggle-link-display))][show links]] [[elisp:(alh-1dex-open)][open 1dex]] [[elisp:(alh-1dex-update)][update 1dex]]
// [[elisp:(alh-set-keywords)][set keywords]] ([[file:~/alh/bin/headeralh][headeralh]])
// emacs-keywords adapted edp nofaces origin=[[https://doc.freefem.org/models/static-problems.html]] start=08/10/21 update=10/06/24

// Parameters
func f = x*y;

//Mesh
mesh Th0 = square(100, 100);

// Fespace
fespace V0h(Th0, P2);
V0h u0, v0;

// Problem
solve Poisson0 (u0, v0)
    = int2d(Th0)(
        dx(u0)*dx(v0)
        + dy(u0)*dy(v0)
    )
    - int2d(Th0)(
        f*v0
    )
    + on(1, 2, 3, 4, u0=0)
    ;
plot(u0);

// Error loop
real[int] errL2(10), errH1(10);
for (int i = 1; i <= 10; i++){
    // Mesh
    mesh Th = square(5+i*3,5+i*3);

    // Fespace
    fespace Vh(Th, P1);
    Vh u, v;
    fespace Ph(Th, P0);
    Ph h = hTriangle; //get the size of all triangles

    // Problem
    solve Poisson (u, v)
        = int2d(Th)(
            dx(u)*dx(v)
            + dy(u)*dy(v)
        )
        - int2d(Th)(
            f*v
        )
        + on(1, 2, 3, 4, u=0)
        ;

    // Error
    V0h uu = u; //interpolate solution on first mesh
    errL2[i-1] = sqrt( int2d(Th0)((uu - u0)^2) )/h[].max^2;
    errH1[i-1] = sqrt( int2d(Th0)(f*(u0 - 2*uu + uu)) )/h[].max;
}

// Display
cout << "C1 = " << errL2.max << "("<<errL2.min<<")" << endl;
cout << "C2 = " << errH1.max << "("<<errH1.min<<")" << endl;

real ref=errL2'*errL2;
CHECKREFREL(ref,0.0031581,1e-5);

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
