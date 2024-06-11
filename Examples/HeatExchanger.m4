// ~/ffalh/ffref/Examples/HeatExchanger.m4
// =======================================
// 
// Originally from https://doc.freefem.org/tutorials/heatExchanger.html
// Adapted by Antoine Le Hyaric ([[http://www.ljll.fr/lehyaric]])
// 
// [[elisp:(progn (org-link-minor-mode) (setq org-link-descriptive nil) (org-toggle-link-display))][hide links]] [[elisp:(progn (org-link-minor-mode) (setq org-link-descriptive t) (org-toggle-link-display))][show links]] [[elisp:(alh-1dex-open)][open 1dex]] [[elisp:(alh-1dex-update)][update 1dex]]
// [[elisp:(alh-set-keywords)][set keywords]] ([[file:~/alh/bin/headeralh][headeralh]])
// emacs-keywords adapted edp nofaces origin=https://doc.freefem.org/tutorials/heatExchanger.html start=08/10/21 update=10/06/24

// Parameters
int C1=99;
int C2=98; //could be anything such that !=0 and C1!=C2

// Mesh
border C0(t=0., 2.*pi){x=5.*cos(t); y=5.*sin(t);}

border C11(t=0., 1.){x=1.+t; y=3.; label=C1;}
border C12(t=0., 1.){x=2.; y=3.-6.*t; label=C1;}
border C13(t=0., 1.){x=2.-t; y=-3.; label=C1;}
border C14(t=0., 1.){x=1.; y=-3.+6.*t; label=C1;}

border C21(t=0., 1.){x=-2.+t; y=3.; label=C2;}
border C22(t=0., 1.){x=-1.; y=3.-6.*t; label=C2;}
border C23(t=0., 1.){x=-1.-t; y=-3.; label=C2;}
border C24(t=0., 1.){x=-2.; y=-3.+6.*t; label=C2;}

plot(C0(50)	//to see the border of the domain
	+ C11(5)+C12(20)+C13(5)+C14(20)
	+ C21(-5)+C22(-20)+C23(-5)+C24(-20),
	wait=true, ps="test_heatexb.eps");

mesh Th=buildmesh(C0(50)
	+ C11(5)+C12(20)+C13(5)+C14(20)
	+ C21(-5)+C22(-20)+C23(-5)+C24(-20));

plot(Th,wait=1);

// Fespace
fespace Vh(Th, P1);
Vh u, v;
Vh kappa=1 + 2*(x<-1)*(x>-2)*(y<3)*(y>-3);

// Solve
solve a(u, v)
	= int2d(Th)(
		  kappa*(
			  dx(u)*dx(v)
			+ dy(u)*dy(v)
		)
	)
	+on(C0, u=20)
	+on(C1, u=60)
	;

// Plot
plot(u, wait=true, value=true, fill=true, ps="test_HeatExchanger.eps");

// [[elisp:(compile "cd .. && ./history -default -run -db Examples/HeatExchanger")]] => [[file:HeatExchanger.default.out]]
// [[elisp:(compile "cd .. && ./history -ffjs -run -db Examples/HeatExchanger")]] => [[file:HeatExchanger.ffjs_dev.out]]
// [[file:../history.db::Examples/HeatExchanger]]

real ref=int2d(Th)(u);
CHECKREFREL(ref,2476.7,1e-3);
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
