% Solve a Pattern Recognition Problem with a Neural Network
% Script generated by Neural Pattern Recognition app
% Created 05-Apr-2019 15:31:20
%
% This script assumes these variables are defined:
%
%   dataset - input data.
%   target - target data.
clc; clear all;
load 'trainset.mat';
load 'testset.mat';
k=1;
akurasi=zeros(4,1)
for i=k:4;

    x = trainset{i}(1:end-1,:);
    t = ubahbentuktarget(trainset{i}(end,:));

    % Choose a Training Function
    % For a list of all training functions type: help nntrain
    % 'trainlm' is usually fastest.
    % 'trainbr' takes longer but may be better for challenging problems.
    % 'trainscg' uses less memory. Suitable in low memory situations.
    trainFcn = 'trainscg';  % Scaled conjugate gradient backpropagation.

    % Create a Pattern Recognition Network
    hiddenLayerSize = 10;
    net = patternnet(hiddenLayerSize, trainFcn);

    % Choose Input and Output Pre/Post-Processing Functions
    % For a list of all processing functions type: help nnprocess
    net.input.processFcns = {'removeconstantrows','mapminmax'};

    % Setup Division of Data for Training, Validation, Testing
    % For a list of all data division functions type: help nndivision
    net.divideFcn = 'dividerand';  % Divide data randomly
    net.divideMode = 'sample';  % Divide up every sample
    net.divideParam.trainRatio = 100/100;
    net.divideParam.valRatio = 0/100;
    net.divideParam.testRatio = 0/100;



    % Choose a Performance Function
    % For a list of all performance functions type: help nnperformance
    net.performFcn = 'crossentropy';  % Cross-Entropy

    % Choose Plot Functions
    % For a list of all plot functions type: help nnplot
    net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
        'plotconfusion', 'plotroc'};

    % Train the Network
    [net,tr] = train(net,x,t);

    % Test the Network
    t2=ubahbentuktarget(testset{i}(end,:));
    x2=testset{i}(1:end-1,:);
    y = net(x2);
    e = gsubtract(t2,y);

    [A, CM, IND, PER] = hitungakurasi(t2,y);
    akurasi(k:k+1,:)=A;
    k=i+1;
    % View the Network
    view(net)
    close all;

    % Plots
    % Uncomment these lines to enable various plots.
    %figure, plotperform(tr)
    %figure, plottrainstate(tr)
    %figure, ploterrhist(e)
    figure, plotconfusion(t2,y)
    %figure, plotroc(t,y)

    % Deployment
    % Change the (false) values to (true) to enable the following code blocks.
    % See the help for each generation function for more information.
    if (false)
        % Generate MATLAB function for neural network for application
        % deployment in MATLAB scripts or with MATLAB Compiler and Builder
        % tools, or simply to examine the calculations your trained neural
        % network performs.
        genFunction(net,'myNeuralNetworkFunction');
        y = myNeuralNetworkFunction(x);
    end
    if (false)
        % Generate a matrix-only MATLAB function for neural network code
        % generation with MATLAB Coder tools.
        genFunction(net,'myNeuralNetworkFunction','MatrixOnly','yes');
        y = myNeuralNetworkFunction(x);
    end
    if (false)
        % Generate a Simulink diagram for simulation or deployment with.
        % Simulink Coder tools.
        gensim(net);
    end
end
