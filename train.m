load('twohundredthousand.mat');

N = length(labels);
accuracy = zeros(1,10);

for k=1:10
    k
    test_data = presample_data(:, (k-1)*N/10+1:k*N/10).';
    test_labels = labels((k-1)*N/10+1:k*N/10).';
    train_data = presample_data.';
    train_data((k-1)*N/10+1:k*N/10, :) = [];
    train_labels = labels.';
    train_labels((k-1)*N/10+1:k*N/10) = [];

    cl = fitcsvm(train_data, train_labels, 'KernelFunction', 'rbf', 'BoxConstraint', Inf, 'ClassNames', [0, 1]);

    pred = predict(cl, test_data);
    accuracy(k) = sum(pred & test_labels)/sum(test_labels);
end
% save 'SVM200k.mat' cl
saveCompactModel(cl, 'SVM_200k');
