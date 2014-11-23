function [] = extract(inp)
grey_image = rgb2gray(imread(inp));
strel_square = strel('square', 3);    % Creates structuring element 3-by-3 square
q = grey_image;
r = grey_image;
for p = 1:100;
    q = imerode(q,strel_square);
    r = imdilate(r,strel_square);
end
for p = 1:100;
    q = imdilate(q,strel_square);
    r = imerode(r,strel_square);
end
imModified = imsubtract(imadd(grey_image,imsubtract(grey_image,q)), imsubtract(r,grey_image));
high_pass_filter = [0 1 0;1 -4 1;0 1 0]; % High Pass Filter
imModified_doub = imsubtract(imModified,imfilter(imModified, high_pass_filter));
[x,y,z] = size(grey_image);
for ipo = 1:x;
    for jpo = 1:y-1;
        if imModified_doub(ipo,jpo)>110
            imModified_doub(ipo,jpo) = 255;
        end
    end
end
imComp = imcomplement(imModified);
ieopen = imModified;
ieclostrel_square = imComp;
for kk = 1:10;
    ieopen = imerode(ieopen,strel_square);
    ieclostrel_square = imerode(ieclostrel_square,strel_square);
end

iclostrel_squarenotfinal = imreconstruct(ieclostrel_square,imComp);
iclostrel_squarefinal = imcomplement(iclostrel_squarenotfinal);
ibothat = imsubtract(iclostrel_squarefinal,imModified);
strel_squarehr = strel('rectangle',[1,3]);
xclostrel_square = ibothat;
for k = 1:20;
    xclostrel_square = imdilate(xclostrel_square,strel_squarehr);
end
for k = 1:20;
    xclostrel_square = imerode(xclostrel_square,strel_squarehr);
end
for k = 1:25;
    xclostrel_square = imerode(xclostrel_square,strel_squarehr);
end
for k = 1:25;
    xclostrel_square = imdilate(xclostrel_square,strel_squarehr);
end
strel_squarerect = strel('rectangle',[9,15]);

erodeDilate = imdilate(im2bw(xclostrel_square,0.7),strel_squarerect);   % Increase the threshold if the number plate is more whitish
numberPlate = zeros(x, y);
imMultiplied = immultiply(erodeDilate,grey_image);
imDouble = im2double(imMultiplied);
grey_image = im2double(rgb2gray(imread(inp)));
for ipo = 1:x;
    for jpo = 1:y;
        if imDouble(ipo,jpo)==0.0
            numberPlate(ipo,jpo) = 1.0;
        else
            numberPlate(ipo,jpo) = grey_image(ipo,jpo);
        end
    end
end
figure(1), imshow(numberPlate);
multipliedBinary = im2bw(imMultiplied,0.5);
figure(2), imshow(multipliedBinary);
plate = imadd(imcomplement(erodeDilate),multipliedBinary);
figure(3), imshow(plate);