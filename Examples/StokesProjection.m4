// ~/ffalh/ffref/Examples/StokesProjection.m4
// ==========================================
// 
// Originally from [[https://doc.freefem.org/tutorials/stokesProjection.html]]
// Adapted by Antoine Le Hyaric ([[http://www.ljll.fr/lehyaric]])
// 
// Sorbonne Université, CNRS, Laboratoire Jacques-Louis Lions, F-75005, Paris, France
// 
// [[elisp:(progn (org-link-minor-mode) (setq org-link-descriptive nil) (org-toggle-link-display))][hide links]] [[elisp:(progn (org-link-minor-mode) (setq org-link-descriptive t) (org-toggle-link-display))][show links]] [[elisp:(alh-1dex-open)][open 1dex]] [[elisp:(alh-1dex-update)][update 1dex]]
// [[elisp:(alh-set-keywords)][set keywords]] ([[file:~/alh/bin/headeralh][headeralh]])
// emacs-keywords adapted edp nofaces origin=[[https://doc.freefem.org/tutorials/stokesProjection.html]] start=08/10/21 univ update=10/06/24

// Parameters
int nn = 1;
real nu = 0.0025;
real dt = 0.2;
real epsv = 1e-6;
real epsu = 1e-6;
real epsp = 1e-6;

// Mesh
border a0(t=1, 0){x=-2; y=t; label=1;}
border a1(t=-2, 0){x=t; y=0; label=2;}
border a2(t=0, -0.5){x=0; y=t; label=2;}
border a3(t=0, 1){x=18*t^1.2; y=-0.5; label=2;}
border a4(t=-0.5, 1){x=18; y=t; label=3;}
border a5(t=1, 0){x=-2+20*t; y=1; label=4;}

mesh Th = buildmesh(a0(3*nn) + a1(20*nn) + a2(10*nn) + a3(150*nn) + a4(5*nn) + a5(100*nn));
plot(Th);

// Fespace
fespace Vh(Th, P1);
Vh w;
Vh u=0, v=0;
Vh p=0;
Vh q=0;

// Definition of Matrix dtMx and dtMy
matrix dtM1x, dtM1y;

// Macro
macro BuildMat()
{   /* for memory managenemt */
    varf vM(unused, v) = int2d(Th)(v);
    varf vdx(u, v) = int2d(Th)(v*dx(u)*dt);
    varf vdy(u, v) = int2d(Th)(v*dy(u)*dt);

    real[int] Mlump = vM(0, Vh);
    real[int] one(Vh.ndof); one = 1;
    real[int] M1 = one ./ Mlump;
    matrix dM1 = M1;
    matrix Mdx = vdx(Vh, Vh);
    matrix Mdy = vdy(Vh, Vh);
    dtM1x = dM1*Mdx;
    dtM1y = dM1*Mdy;
} //

// Build matrices
BuildMat

// Time iterations
real err = 1.;
real outflux = 1.;
for(int n = 0; n < 300; n++){
    // Update
    Vh uold=u, vold=v, pold=p;

    // Solve
    solve pb4u (u, w, init=n, solver=CG, eps=epsu)
        = int2d(Th)(
              u*w/dt
            + nu*(dx(u)*dx(w) + dy(u)*dy(w))
        )
        -int2d(Th)(
                convect([uold, vold], -dt, uold)/dt*w
            - dx(p)*w
        )
        + on(1, u=4*y*(1-y))
        + on(2, 4, u=0)
        ;

    plot(u);

    solve pb4v (v, w, init=n, solver=CG, eps=epsv)
        = int2d(Th)(
              v*w/dt
            + nu*(dx(v)*dx(w) + dy(v)*dy(w))
        )
        -int2d(Th)(
                convect([uold,vold],-dt,vold)/dt*w
            - dy(p)*w
        )
        +on(1, 2, 3, 4, v=0)
        ;

    solve pb4p (q, w, solver=CG, init=n, eps=epsp)
        = int2d(Th)(
              dx(q)*dx(w)+dy(q)*dy(w)
        )
        - int2d(Th)(
              (dx(u)+ dy(v))*w/dt
        )
        + on(3, q=0)
        ;

    //to have absolute epsilon in CG algorithm.
    epsv = -abs(epsv);
    epsu = -abs(epsu);
    epsp = -abs(epsp);

    p = pold-q;
    u[] += dtM1x*q[];
    v[] += dtM1y*q[];

    // Mesh adaptation
    if (n%50 == 49){
      Th = adaptmesh(Th, [u, v], q, err=0.04, nbvx=100000);
      plot(Th, wait=true);
      BuildMat // Rebuild mat.
    }

    // Error & Outflux
    err = sqrt(int2d(Th)(square(u-uold)+square(v-vold))/Th.area);
    outflux = int1d(Th)([u,v]'*[N.x,N.y]);
    cout << " iter " << n << " Err L2 = " << err << " outflux = " << outflux << endl;
    if(err < 1e-3) break;
}

// Verification
assert(abs(outflux)< 2e-3);

// Plot
plot(p, wait=1, ps="test_NSprojP.eps");
plot(u, wait=1, ps="test_NSprojU.eps");

// [[elisp:(compile "cd .. && ./history -default -run -db Examples/StokesProjection")]] => [[file:StokesProjection.default.out]]
// [[elisp:(compile "cd .. && ./history -ffjs -run -db Examples/StokesProjection")]] => [[file:StokesProjection.ffjs_dev.out]]
// [[file:../history.db::Examples/StokesProjection]]
// [[elisp:(compile "FreeFem++ StokesProjection.edp")]]

real ref=int2d(Th)(u);
CHECKREFREL(ref,13.2785,1e-3);
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
