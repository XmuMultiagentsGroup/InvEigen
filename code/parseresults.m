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

function [] = parseresults(i_kmax, i_Value, i_lNum, i_lmin, i_k, i_alpha, i_phi)

B = ones(i_Value) - eye(i_Value);
A = Adjtoincid(B,0);
A = full(A');

BestOptValue = 0.0;
kmax = i_kmax;
optval = [];
edgeweights = [];

[n,m] = size(A);
%DirResults = strcat('results-', int2str(i_Value) , '-', int2str(i_lNum) , '-',num2str(i_lmin),'-', num2str(i_k) ,'/');

DirResults = strcat('results-', int2str(i_Value), '-' , int2str(i_lNum) , '-',num2str(i_lmin), '-', num2str(i_k), '-', num2str(abs(i_alpha)) , '-', num2str(i_phi), '/');


%MainDir = strcat('expalpha' ,num2str(i_alpha));
MainDir = '';

%sortedEigenValuesList = [];
%figure(1); cla; 

for i = 1:kmax
    if exist(strcat(DirResults, 'ObjValue', int2str(i)), 'file')
        %read the file and weights
        fid1 = fopen(strcat(DirResults, 'ObjValue', int2str(i)));
        ObjValue = fscanf(fid1, '%f', 1);
        optval = [optval ObjValue];
        fid2 = fopen(strcat(DirResults, 'weight', int2str(i)));
        weight = fscanf(fid2, '%f', [m , 1]);
        if ObjValue > BestOptValue
            %ObjValue
            edgeweights = horzcat(edgeweights , weight);   
            BestOptValue = ObjValue;
            BestWeight = weight;
        end
        fclose(fid1);
        fclose(fid2);
    end
    
 %   sortedEigenValues = sort(eig(A * diag(weight) * A'), 'descend');
 %   sortedEigenValuesList = [sortedEigenValuesList sortedEigenValues];
 %   figure(1); plot(sortedEigenValuesList, '-d'); hold on; drawnow;
end

 L = A * diag(BestWeight) * A';
 M = eye(size(L)) - L;
 [a,b] = size(edgeweights);
 

 optval = sort(optval,'descend');
 if b > 10
 	dlmwrite('OtherWeights',edgeweights(:, [b-10:b]),'\t');
 else
 	dlmwrite('OtherWeights',edgeweights(:, [1:b]),'\t');
 end


%FinalDirResults = strcat('Finalresults-',int2str(i_Value), '-', int2str(i_lNum) , '-',num2str(i_lmin), '-', num2str(i_k) ,'/');
FinalDirResults = strcat('Finalresults-', int2str(i_Value), '-' , int2str(i_lNum) , '-',num2str(i_lmin), '-', num2str(i_k), '-', num2str(abs(i_alpha)) , '-', num2str(i_phi), '/');

 
if exist(FinalDirResults,'dir') == 0
    mkdir(FinalDirResults);
end

 dlmwrite(strcat(FinalDirResults, 'Laplacian'),L,'\t');
 dlmwrite(strcat(FinalDirResults, 'Adjacency'),M,'\t');
 dlmwrite(strcat(FinalDirResults, 'optval'),optval,'\n');
 save(strcat(FinalDirResults, 'Matrix.dat'), 'M');
