<!-- 
   - ~/ffalh/ffref/README.md
   - =======================
   - 
   - 
   -     ______    ____  _____    _    ____  __  __ _____                 _ 
   -    /     /,  |  _ \| ____|  / \  |  _ \|  \/  | ____|  _ __ ___   __| |
   -   /     //   | |_) |  _|   / _ \ | | | | |\/| |  _|   | '_ ` _ \ / _` |
   -  /_____//    |  _ <| |___ / ___ \| |_| | |  | | |___ _| | | | | | (_| |
   - (_____(/     |_| \_\_____/_/   \_\____/|_|  |_|_____(_)_| |_| |_|\__,_|
   -                                                                        
   - 
   - [[http://www.ljll.fr/lehyaric][Antoine Le Hyaric]]
   - 
   - Sorbonne Université, CNRS, Laboratoire Jacques-Louis Lions, F-75005, Paris, France
   - 
   - ----------------------------
   - This file is part of FreeFEM
   - ----------------------------
   - FreeFEM is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as
   - published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.
   - FreeFEM is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
   - MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for more details.
   - You should have received a copy of the GNU Lesser General Public License along with FreeFEM; if not, write to the Free Software
   - Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
   - 
   - [[elisp:(progn (org-link-minor-mode) (setq org-link-descriptive nil) (org-toggle-link-display))][hide links]] [[elisp:(progn (org-link-minor-mode) (setq org-link-descriptive t) (org-toggle-link-display))][show links]] [[elisp:(alh-1dex-open)][open 1dex]] [[elisp:(alh-1dex-update)][update 1dex]]
   - [[elisp:(alh-set-keywords)][set keywords]] ([[file:~/alh/bin/headeralh][headeralh]])
   - emacs-keywords freefem markdown start=11/06/24 univ update=11/06/24
   -->

<!-- [[https://docs.github.com/fr/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax]] -->

# Set of reference results for the [FreeFEM](https://github.com/FreeFem) documentation

This repository contains scripts from chapters
[Learning by examples](https://doc.freefem.org/tutorials/index.html)
and [Mathematical models](https://doc.freefem.org/models/index.html)
of the [FreeFEM documentation](https://doc.freefem.org/documentation).

Alongside these files, a [database](history.db) lists their numerical results, obtained with various versions of FreeFEM.

This project can be used as a source of working example scripts and as a non-regression testing suite.

The objective is to gather the most meaningful reference values and error estimates for all these scripts. And to improve these values
through mathematical and physical analysis of the simulated models. This is a constant work in progress so some numerical values may vary
depending on the versions of the scripts (version information is stored in the database).

Any question or comment on the [FreeFEM forum](https://community.freefem.org) or directly to @alh104 is welcome.

<!-- 
   - Local Variables:
   - mode:markdown
   - indent-tabs-mode:nil
   - eval:(visual-line-mode t)
   - coding:utf-8
   - eval:(flyspell-mode)
   - eval:(outline-minor-mode)
   - eval:(org-link-minor-mode)
   - End:
   -->
<!-- LocalWords: emacs
   -->
