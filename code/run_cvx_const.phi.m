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

function [BestWeight, BestOptValue] = run_cvx_const(A, weight, Delimeter , lNum, lmax, lmin , depsilon, i_k, i_alpha, i_phi)

BestOptValue = 0;
TrueOptValue = 0;
[n,m] = size(A);
LoopCounter = 0;
c= 0.20 - 0.01;
k = i_k;
expalpha = i_alpha;
PHI = i_phi;

while true
	%Calculate the lambda sum small of the Current Laplacian Matrix
    	LCurrent = A * diag(weight) * A';
	LambdaDifference = lambda_sum_largest(LCurrent, lNum) -  lambda_sum_smallest(LCurrent, n - lNum);
	vgradient = gradientVectorv1(LCurrent, lNum);
   	ObjFunc =  '((lambda_sum_smallest(L, n-lNum-1) - lambda_sum_largest(L, lNum -1)  + (LambdaDifference + (dot(vgradient, vec(L - LCurrent))))) ';
	for i = 1:m
	        StrWeight = num2str(ThethaEdgeWeight(weight(i,1),k,expalpha));
	        derivative = num2str((exp( expalpha * weight(i,1)) * ( exp(expalpha * weight(i,1)) + exp(expalpha * k) * (1 + weight(i,1) * expalpha - expalpha * k)) / power((exp( expalpha * weight(i,1)) + exp( expalpha * k)),2)));
		ObjFunc = strcat(ObjFunc, ' - PHI * (norm(Gamma(', num2str(i) , ',1) - (' , StrWeight, ' + ', derivative, ' * (w(', num2str(i) ,',1) - ', num2str(weight(i,1)),'))))' );
	end

    	ObjFunc = strcat(ObjFunc, ')'); 
	%ObjFunc
	cvx_begin sdp
		cvx_quiet(true);
    		variable w(m,1);
    		variable L(n,n) symmetric;
                variable Gamma(m,1);
		maximize(ObjFunc)
    		subject to
        		L == A * diag(w) * A';
        		w >= 0;
			Gamma >= 0;
			diag(L) == 1        %Makes sure that there are no self loops.
                	lambda_max(L) <= lmax;
                	lambda_sum_smallest(L, 2) >= lmin;
			for i = 1:m
                    		pos(-w(i,1) + c) <= 1 - Gamma(i,1);
                	end
	cvx_end
	%disp(cvx_status);
	weight = w;
	GammaWeight = Gamma;
	%Calculate True optval
	LCurrent = A * diag(weight) * A';
	TrueOptValue = (lambda_sum_largest(LCurrent, lNum) - lambda_sum_smallest(LCurrent , n-lNum)) - (lambda_sum_largest(LCurrent, lNum-1) - lambda_sum_smallest(LCurrent, n-lNum - 1));
        NormValue = 0;
        for i = 1:m
                NormValue = NormValue + PHI * (norm(GammaWeight(i,1) - ThethaEdgeWeight(weight(i,1),k,expalpha)));
        end
	
	ActualObjValue = TrueOptValue -  NormValue;	
	if TrueOptValue > BestOptValue
		%Save Best So Far.
		BestOptValue = TrueOptValue;
		BestWeight = weight;
		LoopCounter = 0;		%Designed just to exit the loop.
	end
	LoopCounter = LoopCounter + 1;
	if ((abs(cvx_optval - ActualObjValue) < depsilon) || (LoopCounter > Delimeter)) break; end		%Exit Condition.
end

