// ~/ffalh/ffref/Models/Eigenvalues.m4
// ===================================
// 
// Originally from [[https://doc.freefem.org/models/eigen-value-problems.html]]
// Adapted by Antoine Le Hyaric ([[http://www.ljll.fr/lehyaric]])
// 
// Sorbonne Université, CNRS, Laboratoire Jacques-Louis Lions, F-75005, Paris, France
// 
// [[elisp:(progn (org-link-minor-mode) (setq org-link-descriptive nil) (org-toggle-link-display))][hide links]] [[elisp:(progn (org-link-minor-mode) (setq org-link-descriptive t) (org-toggle-link-display))][show links]] [[elisp:(alh-1dex-open)][open 1dex]] [[elisp:(alh-1dex-update)][update 1dex]]
// [[elisp:(alh-set-keywords)][set keywords]] ([[file:~/alh/bin/headeralh][headeralh]])
// emacs-keywords adapted edp nofaces origin=[[https://doc.freefem.org/models/eigen-value-problems.html]] start=08/10/21 univ update=10/06/24

// Parameters
real sigma = 20; //value of the shift
int nev = 20; //number of computed eigen value close to sigma

// Mesh
mesh Th = square(20, 20, [pi*x, pi*y]);

// Fespace
fespace Vh(Th, P2);
Vh u1, u2;

// Problem
// OP = A - sigma B ; // the shifted matrix
varf op (u1, u2)
    = int2d(Th)(
          dx(u1)*dx(u2)
        + dy(u1)*dy(u2)
        - sigma* u1*u2
    )
    + on(1, 2, 3, 4, u1=0)
    ;

varf b ([u1], [u2]) = int2d(Th)(u1*u2); //no boundary condition

matrix OP = op(Vh, Vh, solver=Crout, factorize=1); //crout solver because the matrix in not positive
matrix B = b(Vh, Vh, solver=CG, eps=1e-20);

// important remark:
// the boundary condition is make with exact penalization:
// we put 1e30=tgv on the diagonal term of the lock degree of freedom.
// So take Dirichlet boundary condition just on $a$ variational form
// and not on $b$ variational form.
// because we solve $ w=OP^-1*B*v $

// Solve
real[int] ev(nev); //to store the nev eigenvalue
Vh[int] eV(nev); //to store the nev eigenvector

int k = EigenValue(OP, B, sym=true, sigma=sigma, value=ev, vector=eV,
    tol=1e-10, maxit=0, ncv=0);

// Display & Plot
for (int i = 0; i < k; i++){
    u1 = eV[i];
    real gg = int2d(Th)(dx(u1)*dx(u1) + dy(u1)*dy(u1));
    real mm = int2d(Th)(u1*u1) ;
    cout << "lambda[" << i << "] = " << ev[i] << ", err= " << int2d(Th)(dx(u1)*dx(u1) + dy(u1)*dy(u1) - (ev[i])*u1*u1) << endl;
    plot(eV[i], cmm="Eigen Vector "+i+" value ="+ev[i], wait=true, value=true);
}

CHECKREF(ev[1],ev[1]>8.00073 && ev[1]<8.00075)

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
