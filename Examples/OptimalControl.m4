// ~/ffalh/ffref/Examples/OptimalControl.m4
// ========================================
// 
// Originally from [[https://doc.freefem.org/tutorials/optimalControl.html]]
// Adapted by Antoine Le Hyaric ([[http://www.ljll.fr/lehyaric]])
// 
// Sorbonne Université, CNRS, Laboratoire Jacques-Louis Lions, F-75005, Paris, France
// 
// [[elisp:(progn (org-link-minor-mode) (setq org-link-descriptive nil) (org-toggle-link-display))][hide links]] [[elisp:(progn (org-link-minor-mode) (setq org-link-descriptive t) (org-toggle-link-display))][show links]] [[elisp:(alh-1dex-open)][open 1dex]] [[elisp:(alh-1dex-update)][update 1dex]]
// [[elisp:(alh-set-keywords)][set keywords]] ([[file:~/alh/bin/headeralh][headeralh]])
// emacs-keywords adapted edp nofaces origin=[[https://doc.freefem.org/tutorials/optimalControl.html]] start=08/10/21 univ update=10/06/24

// Mesh
border aa(t=0, 2*pi){x=5*cos(t); y=5*sin(t);};
border bb(t=0, 2*pi){x=cos(t); y=sin(t);};
border cc(t=0, 2*pi){x=-3+cos(t); y=sin(t);};
border dd(t=0, 2*pi){x=cos(t); y =-3+sin(t);};

mesh th = buildmesh(aa(70) + bb(35) + cc(35) + dd(35));

// Fespace
fespace Vh(th, P1);
Vh Ib=((x^2+y^2)<1.0001),
   Ic=(((x+3)^2+ y^2)<1.0001),
   Id=((x^2+(y+3)^2)<1.0001),
   Ie=(((x-1)^2+ y^2)<=4),
   ud, u, uh, du;

// Problem
real[int] z(3);
problem A(u, uh)
   = int2d(th)(
        (1+z[0]*Ib+z[1]*Ic+z[2]*Id)*(dx(u)*dx(uh) + dy(u)*dy(uh))
   )
   + on(aa, u=x^3-y^3)
   ;

// Solve
z[0]=2; z[1]=3; z[2]=4;
A;
ud = u;

ofstream f("test_J.txt");
func real J(real[int] & Z){
   for (int i = 0; i < z.n; i++)
      z[i] =Z[i];
   A;
   real s = int2d(th)(Ie*(u-ud)^2);
   f << s << " ";
   return s;
}

// Problem BFGS
real[int] dz(3), dJdz(3);
problem B (du, uh)
   = int2d(th)(
        (1+z[0]*Ib+z[1]*Ic+z[2]*Id)*(dx(du)*dx(uh) + dy(du)*dy(uh))
   )
   + int2d(th)(
        (dz[0]*Ib+dz[1]*Ic+dz[2]*Id)*(dx(u)*dx(uh) + dy(u)*dy(uh))
   )
   +on(aa, du=0)
   ;

func real[int] DJ(real[int] &Z){
   for(int i = 0; i < z.n; i++){
      for(int j = 0; j < dz.n; j++)
         dz[j] = 0;
      dz[i] = 1;
      B;
      dJdz[i] = 2*int2d(th)(Ie*(u-ud)*du);
   }
   return dJdz;
}

real[int] Z(3);
for(int j = 0; j < z.n; j++)
   Z[j]=1;

BFGS(J, DJ, Z, eps=1.e-6, nbiter=15, nbiterline=20);
cout << "BFGS: J(z) = " << J(Z) << endl;
for(int j = 0; j < z.n; j++)
   cout << z[j] << endl;

// Plot
plot(ud, value=1, ps="test_u.eps");

// [[elisp:(compile "cd .. && ./history -default -run -db Examples/OptimalControl")]] => [[file:OptimalControl.default.out]]
// [[elisp:(compile "cd .. && ./history -ffjs -run -db Examples/OptimalControl")]] => [[file:OptimalControl.ffjs_dev.out]]
// [[file:../history.db::Examples/OptimalControl]]
// [[elisp:(compile "FreeFem++ OptimalControl.edp")]]

real ref=int2d(th)(abs(ud));
CHECKREFREL(ref,4558.25,1e-3);
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
