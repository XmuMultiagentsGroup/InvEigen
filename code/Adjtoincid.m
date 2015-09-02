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

function mInc = Adjtoincid(mAdj,varargin)
%full(mAdj)
if (~(issparse(mAdj)&& islogical(mAdj)))
    %warning('adj2inc:sparseExpected','Adjacency matrix should be sparse and contain only {0,1}');
    mAdj = sparse(logical(mAdj));  
end
%full(mAdj)

vM = size(mAdj);

iN_nodes  = vM(1);

if (iN_nodes < 2)
    error('adj2inc:notEnoughNodes','Graph must contain at least 2 nodes (and one edge)!');
end

if (iN_nodes ~= vM(2))
    error('adj2inc:wrongInput','Input matrix must be square!');
end

if (nnz(diag(mAdj)))
    error('adj2inc:selfLoops','No self-loops are allowed!');
end

if (nargin>2)
    error('adj2inc:wrongInput','Too many input parameters!');
end

if isempty(varargin)                
    bDir = isequal(mAdj,mAdj.');    %if the matrix is symmetric, graph is undirected
else
    bDir = logical(varargin{1});    %don't check the symmetricity,but decide according to the input parameter
end

if (bDir)         % undirected graph
    
    [vNodes1,vNodes2] = find(triu(mAdj));     
    iN_edges = length(vNodes1);

    vEdgesidx = 1:iN_edges;
           
    mInc = sparse([vEdgesidx, vEdgesidx]',... 
               [vNodes1; vNodes2],... 
               true,...                 %logical matrix
               iN_edges,iN_nodes);      
        
else              % directed graph       
    
    [vNodes1,vNodes2] = find(mAdj');     
    iN_edges = length(vNodes1);

    vOnes = ones(iN_edges,1); 
    vEdgesidx = 1:iN_edges;
    
    mInc = sparse([vEdgesidx, vEdgesidx]',... 
               [vNodes1; vNodes2],... 
               [-vOnes; vOnes],... 
               iN_edges,iN_nodes); 
  
end

end
