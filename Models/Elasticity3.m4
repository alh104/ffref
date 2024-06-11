// ~/ffalh/ffref/Models/Elasticity3.m4
// ===================================
// 
// Originally from [[https://doc.freefem.org/models/elasticity.html]]
// Adapted by Antoine Le Hyaric ([[http://www.ljll.fr/lehyaric]])
// 
// Sorbonne Université, CNRS, Laboratoire Jacques-Louis Lions, F-75005, Paris, France
// 
// [[elisp:(progn (org-link-minor-mode) (setq org-link-descriptive nil) (org-toggle-link-display))][hide links]] [[elisp:(progn (org-link-minor-mode) (setq org-link-descriptive t) (org-toggle-link-display))][show links]] [[elisp:(alh-1dex-open)][open 1dex]] [[elisp:(alh-1dex-update)][update 1dex]]
// [[elisp:(alh-set-keywords)][set keywords]] ([[file:~/alh/bin/headeralh][headeralh]])
// emacs-keywords adapted edp nofaces origin=[[https://doc.freefem.org/models/elasticity.html]] start=08/10/21 univ update=10/06/24

//Parameters
real d = 0.0001; int n = 5; real cb = 1, ca = 1, tip = 0.0;

real E = 21.5;
real sigma = 0.29;

// Mesh
border L1(t=0, ca-d){x=-cb; y=-d-t;}
border L2(t=0, ca-d){x=-cb; y=ca-t;}
border B(t=0, 2){x=cb*(t-1); y=-ca;}
border C1(t=0, 1){x=-ca*(1-t)+(tip-10*d)*t; y=d;}
border C21(t=0, 1){x=(tip-10*d)*(1-t)+tip*t; y=d*(1-t);}
border C22(t=0, 1){x=(tip-10*d)*t+tip*(1-t); y=-d*t;}
border C3(t=0, 1){x=(tip-10*d)*(1-t)-ca*t; y=-d;}
border C4(t=0, 2*d){x=-ca; y=-d+t;}
border R(t=0, 2){x=cb; y=cb*(t-1);}
border T(t=0, 2){x=cb*(1-t); y=ca;}
mesh Th = buildmesh(L1(n/2) + L2(n/2) + B(n)
    + C1(n) + C21(3) + C22(3) + C3(n) + R(n) + T(n));
plot(Th, wait=true);

cb=0.1; ca=0.1;
mesh Zoom = buildmesh(L1(n/2) + L2(n/2) + B(n) + C1(n)
    + C21(3) + C22(3) + C3(n) + R(n) + T(n));
plot(Zoom, wait=true);

// Fespace
fespace Vh(Th, [P2, P2]);
Vh [u, v];
Vh [w, s];

fespace zVh(Zoom, P2);
zVh Sx, Sy, Sxy, N;

// Problem
real mu = E/(2*(1+sigma));
real lambda = E*sigma/((1+sigma)*(1-2*sigma));
solve Problem ([u, v], [w, s])
    = int2d(Th)(
          2*mu*(dx(u)*dx(w) + ((dx(v)+dy(u))*(dx(s)+dy(w)))/4)
        + lambda*(dx(u) + dy(v))*(dx(w) + dy(s))/2
    )
    -int1d(Th, T)(
          0.1*(1-x)*s
    )
    +int1d(Th, B)(
          0.1*(1-x)*s
    )
    +on(R, u=0, v=0)
    ;

// Loop
for (int i = 1; i <= 5; i++){
    mesh Plate = movemesh(Zoom, [x+u, y+v]); //deformation near gamma
    Sx = lambda*(dx(u) + dy(v)) + 2*mu*dx(u);
    Sy = lambda*(dx(u) + dy(v)) + 2*mu*dy(v);
    Sxy = mu*(dy(u) + dx(v));
    N = 0.1*1*sqrt((Sx-Sy)^2 + 4*Sxy^2); //principal stress difference
    if (i == 1){
        plot(Plate, bw=1);
        plot(N, bw=1);
    }
    else if (i == 5){
        plot(Plate, bw=1);
        plot(N, bw=1);
        break;
    }

    // Adaptmesh
    Th = adaptmesh(Th, [u, v]);

    // Solve
    Problem;
}

real ref=int2d(Th)(u);
CHECKREFREL(ref,0.0229212,1e-3);
VERSION(v3);

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
