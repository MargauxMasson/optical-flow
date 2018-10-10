clear all;close all; 

%% Video
v=VideoReader('sequence.mpg');
nFrames=v.NumberOfFrames;
for iFrame=1:1:nFrames-1
    m=512; %taille image
    p=512; %taille image
    v=VideoReader('sequence.mpg');
    get(v);
    I1=read(v,iFrame);
    I2=read(v,iFrame+1);
    E1=rgb2gray(I1);
    E2=rgb2gray(I2);
            
    %% Chargement des images
%     E1=imread('noise29.gif');
%     E2=imread('noise30.gif');    
%     E1=imread('cars0001.png');
%     E2=imread('cars0001.png');
%     m=96; %taille image
%     p=96; %taille image
% E1=rgb2gray(imread('cars0001.png'));
% E2=rgb2gray(imread('cars0002.png'));
% m=190; %taille image
% p=256; %taille image

    figure(1);
    subplot(3,2,1);
    imshow(E1);
    title('Image 1');
    subplot(3,2,2);
    imshow(E2);
    title('Image 2');

    %% Initialisation des masques
    D=[-1/4 1/4 0;-1/4 1/4 0; 0 0 0]; %masque de Ex
    D1=[-1/4 -1/4 0;1/4 1/4 0; 0 0 0]; %masque de Ey
    D2=[1/4 1/4 0;1/4 1/4 0;0 0 0];  %masque de Et

    %% Calcul des gradients Ex, Ey et Et
    Ex1=filter2(D,E1,'same'); %Ex pour l'image 1
    Ex2=filter2(D,E2,'same'); %Ex pour l'image 2
    Ex=Ex1+Ex2;

    Ey1=filter2(D1,E1,'same'); %Ey pour l'image 1
    Ey2=filter2(D1,E2,'same'); %Ey pour l'image 2
    Ey=Ey1+Ey2;

    Et=filter2(D2,E2-E1,'same');

    %% Calcul des composantes du flot optique
    um=zeros(m,p); %initialisation u moyennee
    vm=zeros(m,p); %initialisation v moyennee
    n=500; %nombre d'iterations
    alpha=100; %parametre de regularisation
    M=[1/12 1/6 1/12; 1/6 0 1/6; 1/12 1/6 1/12]; %masque median
    for i=1:n
        u= um - (Ex.*(Ex.*um+Ey.*vm+Et)./(alpha.^2+Ex.^2+Ey.^2));
        v= vm - (Ey.*(Ex.*um+Ey.*vm+Et)./(alpha.^2+Ex.^2+Ey.^2));
        um=filter2(M,u,'same'); %u moyennee
        vm=filter2(M,v,'same'); %v moyennee
    end

    %% affichage flot optique 
    % figure(2);
    subplot(3,2,3);
    imshow(u);
    title('composante u du flot optique');
    subplot(3,2,4);
    imshow(v);
    title('composante v du flot optique');
    % figure(3);
    subplot(3,2,5);
    uplot=u(1:8:m,1:8:p);
    vplot=v(1:8:m,1:8:p);
    uplot=flipud(uplot);
    vplot=flipud(-vplot);
    Q=quiver(uplot,vplot);
    title('Champ de vecteurs du deplacement/representation vectorielle du flot');
    %pause();
end