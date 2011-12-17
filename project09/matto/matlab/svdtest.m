% Testing SVD to understand it more

clear train_matrix u s v

m = 1;
b = 1;

counter = 1;
for train_index = -10:2:10
    train_matrix(1,counter) =  train_index;
    train_matrix(2,counter) =  m*train_index + b;
    counter = counter + 1;
end

counter = 1;
for validate_index = -9:2:9
    validate_matrix(1,counter) =  validate_index;
    validate_matrix(2,counter) =  m*validate_index + b;
    counter = counter + 1;
end


[u1, s1, v1] = svds(train_matrix,6)
%[U,V,X,C,S] = gsvd(train_matrix,validate_matrix,0)
%sigma = gsvd(train_matrix,validate_matrix)
%validate_matrix(:,1)*v1(1,:)
%validate_matrix

%[u2, s2, v2] = svd(validate_matrix,0)

%[L1,U1] = lu(train_matrix)
%[L2,U2] = lu(validate_matrix)
