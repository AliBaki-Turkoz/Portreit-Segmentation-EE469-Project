%% Son Kod
clear all
close all
clc

% Kodunuzun başlangıcı
images = imageDatastore("C:\Users\AliBakiTURKOZ\OneDrive\Masaüstü\ee469_project_deneme\rgb_images_for_semantic");
imds = images;
classNames = ["background", "foreground"];
labelIDs = [0, 255];  % Masks kodlanırken kullanılan değerlere göre ayarlayın
labelFolder = "C:\Users\AliBakiTURKOZ\OneDrive\Masaüstü\ee469_project_deneme\segmented_images";
pxds = pixelLabelDatastore(labelFolder, classNames, labelIDs);

imageSize = [256, 256]; % Dilediğiniz boyuta göre değiştirin


layers = [
    imageInputLayer([256 256 3])
    convolution2dLayer(3, 64, 'Padding', 'same')
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2, 'Stride', 2)
    transposedConv2dLayer(4, 64, 'Stride', 2, 'Cropping', 'same')
    batchNormalizationLayer
    reluLayer
    convolution2dLayer(1, 2, 'Padding', 'same')
    softmaxLayer
    pixelClassificationLayer];

options = trainingOptions('sgdm', ...
    'InitialLearnRate', 1e-3, ...
    'MaxEpochs', 40, ...
    'MiniBatchSize', 1, ...
    'Shuffle', 'every-epoch', ...
    'Plots', 'training-progress', ...
    'VerboseFrequency', 10  );

ds = combine(imds, pxds);
net = trainNetwork(ds, layers, options);


outputFolder = 'C:\Users\AliBakiTURKOZ\OneDrive\Masaüstü\ee469_project_deneme\output_images_semantic'; % Sonuçların kaydedileceği klasörü belirtin

% Sonuçları kaydetme işlemi (gri seviyeye dönüştürme ve ikili formata çevirme)
for i = 1:numel(imds.Files)
    img = readimage(imds, i); % Test görüntüsünü al

    % Ağı kullanarak segmentasyon yap
    predictedLabels = semanticseg(img, net);

    % Görüntüyü işleme (örneğin, renklendirme)
    predictedRGB = label2rgb(predictedLabels);

    % Görüntüyü gri seviyeye dönüştürme
    grayImage = rgb2gray(predictedRGB);

    % İkili formata çevirme
    threshold = graythresh(grayImage);
    binaryImage = imbinarize(grayImage, threshold);

    % Görüntüyü kaydetme
    [~, filename, ext] = fileparts(imds.Files{i});
    outputFilename = fullfile(outputFolder, [filename '_result_binary.png']); % İkili formatta kaydet
    imwrite(binaryImage, outputFilename,'png');
end
