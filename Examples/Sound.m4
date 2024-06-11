// ~/ffalh/ffref/Examples/Sound.m4
// ===============================
// 
// Originally from https://doc.freefem.org/tutorials/acoustics.html
// Adapted by Antoine Le Hyaric ([[http://www.ljll.fr/lehyaric]])
// 
// [[elisp:(progn (org-link-minor-mode) (setq org-link-descriptive nil) (org-toggle-link-display))][hide links]] [[elisp:(progn (org-link-minor-mode) (setq org-link-descriptive t) (org-toggle-link-display))][show links]] [[elisp:(alh-1dex-open)][open 1dex]] [[elisp:(alh-1dex-update)][update 1dex]]
// [[elisp:(alh-set-keywords)][set keywords]] ([[file:~/alh/bin/headeralh][headeralh]])
// emacs-keywords adapted edp nofaces origin=https://doc.freefem.org/tutorials/acoustics.html start=08/10/21 update=10/06/24

// Parameters
real kc2 = 1.;
func g = y*(1.-y);

// Mesh
border a0(t=0., 1.){x=5.; y=1.+2.*t;}
border a1(t=0., 1.){x=5.-2.*t; y=3.;}
border a2(t=0., 1.){x=3.-2.*t; y=3.-2.*t;}
border a3(t=0., 1.){x=1.-t; y=1.;}
border a4(t=0., 1.){x=0.; y=1.-t;}
border a5(t=0., 1.){x=t; y=0.;}
border a6(t=0., 1.){x=1.+4.*t; y=t;}

mesh Th = buildmesh(a0(20) + a1(20) + a2(20)
	+ a3(20) + a4(20) + a5(20) + a6(20));

// Fespace
fespace Vh(Th, P1);
Vh u, v;

// Solve
solve sound(u, v)
	= int2d(Th)(
		  u*v * kc2
		- dx(u)*dx(v)
		- dy(u)*dy(v)
	)
	- int1d(Th, a4)(
		  g * v
	)
	;

// Plot
plot(u, wait=1, ps="test_Sound.eps");

// [[elisp:(compile "cd .. && ./history -default -run -db Examples/Sound")]] => [[file:Sound.default.out]]
// [[elisp:(compile "cd .. && ./history -ffjs -run -db Examples/Sound")]] => [[file:Sound.ffjs_dev.out]]
// [[file:../history.db::Examples/Sound]]
// [[elisp:(compile "FreeFem++ Sound.edp")]]

real ref=int2d(Th)(u);
CHECKREFREL(ref,0.166667,1e-3);
VERSION(v3);
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
