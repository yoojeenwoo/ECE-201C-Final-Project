    %Parameter Pruning using ReliefF
    %%
    data = load('concat_presamples.mat');

    %% Presampling for pruning
    index=find(data.labels_new);
    labels=ones(1,length(index));
    presample_data=data.presample_data_new(:,index);
    presample_data=[presample_data data.presample_data_new(:,1:10000)];
    labels=[labels data.labels_new(1,1:10000)];

    %% Run RELIEFF
    [ranks,weights]=relieff(transpose(presample_data),transpose(labels),100);

    %% Show Predictor Ranks and Weights
    bar(weights(ranks))
    xlabel('Predictor rank')
    ylabel('Predictor importance weight')

    %% Prune
    significant = sum(weights > 0);
    idxs = ranks(1:significant);
    
    save('pruned_indices', 'idxs');
    