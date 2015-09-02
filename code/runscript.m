%{

  Copyright (c) 2015, Vatche Ishakian, Benjamin Lubin, Jesse Shore

  This file is part of the InvEigen Project.

  InvEigen is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, version 3 of the License.

  Foobar is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with InvEigen.  If not, see <http://www.gnu.org/licenses/>.

%}

restarts = 200;
Matrixsize = 8;
lmax = 10;
lRange = 8;
l = 3;
%wgraphv1(Matrixsize, 0.2, lmax, l, restarts, 0.01);
%wgraphv1(Matrixsize, 0.1, lmax, l, restarts, 0.01);
wgraphv1(Matrixsize, 0.3, lmax, l, restarts, 0.01);

wgraphv1(Matrixsize, 0.2, lmax, l, restarts, 0.025);
wgraphv1(Matrixsize, 0.1, lmax, l, restarts, 0.025);
wgraphv1(Matrixsize, 0.3, lmax, l, restarts, 0.025);

