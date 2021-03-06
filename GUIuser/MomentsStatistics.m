function [data]=MomentsStatistics(B,L,BW,idx,param)
% Para correr um estrutura com os campos:
% �arvore
% �estrada terra batida
% �estrada alcatr�o
% �mar
% corre o codigo data = struct('arvore',[],'mar',[],'estrada_batida',[],'estrada_alcatrao',[])
%{
A=imread('DSC07713_geotag.JPG');
B=imresize(A,1/4);
[L,N] = superpixels(B,800,'Method','slic','Compactness',5);
adj = cell(N,1);
BW = boundarymask(L);
%Esta parte do algoritm determina qual o valor da intensidade de cada
%superpixel
idx = label2idx(L);
%}
load('data.mat','data');
if ~verifica_entrada(param)
    error('The param value introduced does not existe in the struct data')
end
Bimproved=uint8(ImproveImage(B,1.5,1.05));
imshow(imoverlay(Bimproved,BW,'cyan'));
Igray     = rgb2gray(B);
n         = input(['Insert the number of ' param '\n']);
SupPixTar = zeros(1,n);
xposi     = zeros(1,n);
yposi     = zeros(1,n);
for i=1:n
    imshow(imoverlay(Bimproved,BW,'cyan'));
    [xposi(i),yposi(i)]   = ginput(1);
    SupPixTar(i)          = L(round(yposi(i)),round(xposi(i)));
    BW(idx{SupPixTar(i)}) = 1;
end
var  = zeros(1,n);
skew = zeros(1,n);
Kurt = zeros(1,n);
for i=1:n
    [count,X]      = imhist(Igray(idx{SupPixTar(i)}));
    occurenceVector= createOcurrenceVector(X,count);
    var(i)         = std(occurenceVector);
    skew(i)        = skewness(occurenceVector);
    Kurt(i)        = kurtosis(occurenceVector);
end
resultmatrix      = zeros(4,n);
resultmatrix(1,:) = var;
resultmatrix(2,:) = skew;
resultmatrix(3,:) = Kurt;
data.Objects.(param)= [data.Objects.(param) resultmatrix];
save('GUIuser/data.mat','data')
end
