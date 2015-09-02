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

function [V] = gradientVectorv1(i_Matrix, i_Num)

depsilon = 0.001;
[n,m] = size(i_Matrix);
LambdaSumLargest = lambda_sum_largest(i_Matrix,i_Num);
LambdaSumSmallest =  lambda_sum_smallest (i_Matrix,n - i_Num);
Delta = zeros(size(i_Matrix));
for i=1:n
	for j=1:i
		t = i_Matrix;
		t(i,j) = t(i,j) + depsilon;
		t(j,i) = t(j,i) + depsilon;

%		sortedEigenValues = sort(eig(t), 'descend')
%		SumLargest = sum(sortedEigenValues(1:i_Num))
%		SumSmallest = sum(sortedEigenValues(i_Num:n))
		LambdaPrime = (((lambda_sum_largest(t,i_Num) - lambda_sum_smallest (t,n - i_Num)) - (LambdaSumLargest - LambdaSumSmallest))/depsilon);

		%LambdaPrime = ((lambda_sum_largest(t,i_Num) - LambdaSumLargest) - (lambda_sum_smallest (t,n - i_Num) - LambdaSumSmallest)) / depsilon
%		LambdaPrime = (((SumLargest - SumSmallest) - (LambdaSumLargest - LambdaSumSmallest))/depsilon);
		Delta(i,j) = LambdaPrime;
		Delta(j,i) = LambdaPrime;
	end
end

V = vec(Delta);

