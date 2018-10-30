A = double(imread('bird_large.tiff'));
[M, N, V] = size(A);

numIter = 50;  
K = 16;       
samples = M*N; 

% reshape to X, cluster
cluster = zeros(samples,1);        
X = reshape(A, M*N, V); 

% choose 16 sample randomly
center = X(randperm(M*N, K), :);

% k-means
for t = 1:numIter
    sum = zeros(K, 3);
    count = zeros(K, 1);
    
    % choose center
    for i = 1:samples
        min_d = sqrt((X(i,1)-center(1,1))^2+(X(i,2)-center(1,2))^2+(X(i,3)-center(1,3))^2);
        min_k = 1;
        
        for j=2:K
            d = sqrt((X(i,1)-center(j,1))^2+(X(i,2)-center(j,2))^2+(X(i,3)-center(j,3))^2);
            if d < min_d
                min_d = d;
                min_k = j;
            end
        end
        
        count(min_k) = count(min_k) + 1;
        for c = 1 : 3
            sum(min_k, c) = sum(min_k, c) + X(i, c);
        end
        
        cluster(i) = min_k;  % nearest
    end
    
    % update
    for j = 1:K
       center(j, :) = round(sum(j, :) / count(j));
    end
end

% quantify
Z = X;
for i = 1:samples
    Z(i, :) = center(cluster(i), :);
end

B = reshape(Z, M, N, V);
imshow(uint8(round(B)));