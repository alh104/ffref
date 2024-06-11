// ~/ffalh/ffref/Examples/Elasticity.m4
// ====================================
// 
// Originally from [[https://doc.freefem.org/tutorials/elasticity.html]]
// Adapted by Antoine Le Hyaric ([[http://www.ljll.fr/lehyaric]])
// 
// Sorbonne Université, CNRS, Laboratoire Jacques-Louis Lions, F-75005, Paris, France
// 
// [[elisp:(progn (org-link-minor-mode) (setq org-link-descriptive nil) (org-toggle-link-display))][hide links]] [[elisp:(progn (org-link-minor-mode) (setq org-link-descriptive t) (org-toggle-link-display))][show links]] [[elisp:(alh-1dex-open)][open 1dex]] [[elisp:(alh-1dex-update)][update 1dex]]
// [[elisp:(alh-set-keywords)][set keywords]] ([[file:~/alh/bin/headeralh][headeralh]])
// emacs-keywords adapted edp nofaces origin=[[https://doc.freefem.org/tutorials/elasticity.html]] start=08/10/21 univ update=11/06/24

// Parameters
real E = 21e5;
real nu = 0.28;

real f = -1;

// Mesh
mesh Th = square(10, 10, [20*x,2*y-1]);

// Fespace
fespace Vh(Th, P2);
Vh u, v;
Vh uu, vv;

// Macro
real sqrt2=sqrt(2.);
macro epsilon(u1,u2) [dx(u1),dy(u2),(dy(u1)+dx(u2))/sqrt2] //
// The sqrt2 is because we want: epsilon(u1,u2)'* epsilon(v1,v2) = epsilon(u): epsilon(v)
macro div(u,v) ( dx(u)+dy(v) ) //

// Problem
real mu= E/(2*(1+nu));
real lambda = E*nu/((1+nu)*(1-2*nu));

solve lame([u, v], [uu, vv])
   = int2d(Th)(
        lambda * div(u, v) * div(uu, vv)
      + 2.*mu * ( epsilon(u,v)' * epsilon(uu,vv) )
   )
   - int2d(Th)(
        f*vv
   )
   + on(4, u=0, v=0)
   ;

// Plot
real coef=100;
plot([u, v], wait=1, ps="test_lamevect.eps", coef=coef);

// Move mesh
mesh th1 = movemesh(Th, [x+u*coef, y+v*coef]);
plot(th1,wait=1,ps="test_lamedeform.eps");

// Output
real dxmin = u[].min;
real dymin = v[].min;

cout << " - dep. max x = "<< dxmin << " y=" << dymin << endl;
cout << "   dep. (20, 0) = " << u(20, 0) << " " << v(20, 0) << endl;

// [[elisp:(compile "cd .. && ./history -default -run -db Examples/Elasticity")]] => [[file:Elasticity.default.out]]
// [[elisp:(compile "cd .. && ./history -ffjs -run -db Examples/Elasticity")]] => [[file:Elasticity.ffjs_dev.out]]
// [[file:../history.db::Examples/Elasticity]]
// [[elisp:(compile "FreeFem++ Elasticity.edp")]]

real ref=int2d(Th)(abs(v));
CHECKREFREL(ref,0.422823,1e-3);
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
