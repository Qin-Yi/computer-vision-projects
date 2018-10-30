function output = my_imfilter(image, filter)
% This function is intended to behave like the built in function imfilter()
% when operating in convolution mode. See 'help imfilter'. 
% While "correlation" and "convolution" are both called filtering, 
% there is a difference. From 'help filter2':
%    2-D correlation is related to 2-D convolution by a 180 degree rotation
%    of the filter matrix.

% Your function should meet the requirements laid out on the project webpage.

% Boundary handling can be tricky as the filter can't be centered on pixels
% at the image boundary without parts of the filter being out of bounds. If
% we look at 'help imfilter', we see that there are several options to deal 
% with boundaries. 
% Please recreate the default behavior of imfilter:
% to pad the input image with zeros, and return a filtered image which matches 
% the input image resolution. 
% A better approach is to mirror or reflect the image content in the padding.

% Uncomment to call imfilter to see the desired behavior.
%  output = imfilter(image, filter, 'conv');

%%%%%%%%%%%%%%%%
% Your code here
%%%%%%%%%%%%%%%%
% Return an error message for even filters.
[m,n] = size(filter);
if mod(m*n,2)==0
    error('Error: even filters');
    return
end

% FFT-based convolution.
fft_image = fft2(image);
[a,b,c] = size(fft_image);

% Pad the input image with zeros.
padding = zeros(a,b);
mm = round(m/2);
nn = round(n/2);
padding(1:mm,1:nn) = filter(m-mm+1:m,n-nn+1:n);
padding(1:mm,b-(n-nn)+1:b) = filter(m-mm+1:m,1:n-nn);
padding(a-(m-mm)+1:a,1:nn) = filter(1:m-mm,n-nn+1:n);
padding(a-(m-mm)+1:a,b-(n-nn)+1:b) = filter(1:m-mm,1:n-nn);
fft_filter = fft2(padding);

fft_output = fft_image .* fft_filter;
output = ifft2(fft_output);








