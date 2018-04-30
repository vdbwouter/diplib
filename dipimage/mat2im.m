%MAT2IM   Converts a matlab array to a dip_image
%
% SYNOPSIS:
%  A = MAT2IM(B,DIM)
%
% DEFAULT:
%  DIM = [];
%
%  Converts the matrix B to a dip_image. DIM is an integer specifying the matrix
%  dimension to use as tensor dimension. If DIM is empty, a scalar image is produced.
%  If a string is given as DIM, it is used as color space name, and the last
%  matrix dimension is considered the color dimension.
%
% EXAMPLES:
%  a = readim('flamingo');
%  b = im2mat(a);
%  c = mat2im(b,'rgb');   % c is identical to a.
%
%  a = readim('chromo3d');
%  a = gradientvector(a);
%  b = im2mat(a);
%  c = mat2im(b,1);       % c is identical to a.
%
% SEE ALSO:
%  im2mat, cell2im, joinchannels, dip_image.dip_image

% (c)2017, Cris Luengo.
% Based on original DIPimage code: (c)1999-2014, Delft University of Technology.
%
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
%
%    http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.

function in = mat2im(in,dim)
if nargin<2
   in = dip_image(in);
else
   if ~isnumeric(in) && ~islogical(in)
      error('Input must be numeric or logical');
   end
   sz = size(in);
   if isnumeric(dim) && isscalar(dim)
      if dim > ndims(in) || dim < 1
         error('Given array dimension do not match matrix dimesions');
      end
      if dim==1
         in = dip_image(in,size(in,1));
      else
         if dim==2
            dim=1;
         end
         in = dip_image(in);
         in = spatialtotensor(in,dim);
      end
   elseif ischar(dim)
      in = joinchannels(dim,in);
   else
      error('Wrong input');
   end
end
