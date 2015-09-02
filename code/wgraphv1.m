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

function wgraph1(i_Value, i_lmin, i_lmax, i_lNum, i_kmax,i_k,rank, outname, i_alpha, i_phi)

%Generate an adjacency matrix with the dimensions passed in i_Value
B = ones(i_Value) - eye(i_Value);
size(B);
A = Adjtoincid(B,0);
size(A);
A = full(A');

%Variables
optval = [];
edgeweights = [];
BestOptValue = 0;

%Contraint Values.
lmax = i_lmax;
lmin = i_lmin;
lNum = i_lNum;
kmax = i_kmax;
depsilon = 0.001;
Delimeter = 2000;

DirResults = strcat('results-', int2str(i_Value), '-' , int2str(lNum) , '-',num2str(i_lmin), '-', num2str(i_k), '-', num2str(abs(i_alpha)) , '-', num2str(i_phi), '/');
if exist(DirResults,'dir') == 0
    mkdir(DirResults);
end

disp('This is a MATLAB function m-file')

[n,m] = size(A);
FullWeights = zeros(10,m);
	i = rank;
	rng(i);
	deltaoptval = 10000;
	weight = rand([m,1]);
	weight = weight./repmat(sum(weight), m,1);
	[weight, ObjValue] = run_cvx_const(A, weight , Delimeter , lNum, lmax, lmin , depsilon, i_k, i_alpha, i_phi);
	optval = [optval ObjValue];
	dlmwrite(strcat(DirResults, 'ObjValue', int2str(i)),ObjValue,'\t');
	dlmwrite(strcat(DirResults, 'weight', int2str(i)),weight,'\t');
	dlmwrite(strcat(DirResults, 'rndseed', int2str(i)),int2str(i),'\t');

	%dlmwrite(strcat(outname, 'ObjValue', int2str(i)),ObjValue,'\t');
        %dlmwrite(strcat(outname, 'weight', int2str(i)),weight,'\t');
