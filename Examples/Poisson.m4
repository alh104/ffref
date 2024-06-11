// ~/ffalh/ffref/Examples/Poisson.m4
// =================================
// 
// Originally from [[https://doc.freefem.org/tutorials/poisson.html]]
// Adapted by Antoine Le Hyaric ([[http://www.ljll.fr/lehyaric]])
// 
// Sorbonne Université, CNRS, Laboratoire Jacques-Louis Lions, F-75005, Paris, France
// 
// [[elisp:(progn (org-link-minor-mode) (setq org-link-descriptive nil) (org-toggle-link-display))][hide links]] [[elisp:(progn (org-link-minor-mode) (setq org-link-descriptive t) (org-toggle-link-display))][show links]] [[elisp:(alh-1dex-open)][open 1dex]] [[elisp:(alh-1dex-update)][update 1dex]]
// [[elisp:(alh-set-keywords)][set keywords]] ([[file:~/alh/bin/headeralh][headeralh]])
// emacs-keywords adapted edp nofaces origin=[[https://doc.freefem.org/tutorials/poisson.html]] start=08/10/21 univ update=10/06/24

// Define mesh boundary
border C(t=0, 2*pi){x=cos(t); y=sin(t);}

// The triangulated domain Th is on the left side of its boundary
mesh Th = buildmesh(C(50));

// The finite element space defined over Th is called here Vh
fespace Vh(Th, P1);

// Define u and v as piecewise-P1 continuous functions
Vh u, v;

// Define a function f

func f= x*y;

// Get time in seconds

real cpu=clock();

// Define the PDE

solve Poisson(u, v, solver=LU)
	= int2d(Th)(	// The bilinear part
		  dx(u)*dx(v)
		+ dy(u)*dy(v)
	)
	- int2d(Th)(	// The right hand side
		  f*v
	)
	+ on(C, u=0);	// The Dirichlet boundary condition

// Plot the result
plot(u);

// Display total computational time

cout << "CPU time = " << (clock()-cpu) << endl;

// [[elisp:(compile "cd .. && ./history -default -run -db Examples/Poisson")]] => [[file:Poisson.default.out]]
// [[elisp:(compile "cd .. && ./history -ffjs -run -db Examples/Poisson")]] => [[file:Poisson.ffjs_dev.out]]
// [[file:../history.db::Examples/Poisson]]
// [[elisp:(compile "FreeFem++ Poisson.edp")]]

real ref=int2d(Th)(u);
CHECKREFREL(ref,1.90532e-05,1e-3);
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
