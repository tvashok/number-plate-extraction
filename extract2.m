function [] = extract2(inp,area)
img = imread(inp);

[x,y] = size(rgb2gray(img));
imGraySobel = edge(rgb2gray(img),'sobel');
row=1;
while(row<x)
    coloumn=1;
    while(coloumn<y)
        t=coloumn;
        temp=0;
        while(t<y&&imGraySobel(row,t)==0)
            temp=temp+1;
                t=t+1;       
        end
        if(temp>48)
            coloumn=t+1;
        else
            while(coloumn<=t-1)
                imGraySobel(row,coloumn)=1;
                coloumn=coloumn+1;
            end
            coloumn=t+1;
        end     
    end
    row=row+1;
end
greyCopy=imGraySobel;

row=0;
coloumn=0;
while(row<x)
    coloumn=0;
    while(coloumn<y)
        c=coloumn;
        r=row;
        temp=0;
        for i=1:5
            for j=1:5
                if(r+i<x && c+j<y && greyCopy(r+i,c+j)==1)
                    temp=temp+1;
                end
            end
        end
        if(temp>15)
            for i=1:5
                for j=1:5
                    greyCopy(r+i,c+j)=1;
                end
            end
        else
            for i=1:5
                for j=1:5
                    greyCopy(r+i,c+j)=0;
                end
            end
        end
        coloumn=coloumn+5;
    end
    row=row+5;
end
plate = bwareaopen(imsubtract(greyCopy, bwareaopen(greyCopy, 4800)), 900);
[L, num] = bwlabel(plate, 4);

i=1;
j=1;
while (i<x)
    j=1;
    while (j<y)
        if((L(i,j)==5) || (L(i,j)==6) || (L(i,j)==9))
            plate(i,j)=1;            
        else
            plate(i,j)=0;
        end
        j=j+1;
    end
    i=i+1;
end
%figure,imshow(plate)
plate1=plate;
if (area==1)
    plate = bwareaopen(plate1, 1100);
    plate2=imsubtract(plate1,plate);
    %figure, imshow(plate2);
else    
    CC = bwconncomp(plate);
    numPixels = cellfun(@numel,CC.PixelIdxList);
    [biggest,idx] = max(numPixels);
    plate(CC.PixelIdxList{idx}) = 0;
    plate2=imsubtract(plate1,plate);
    %figure, imshow(plate2);    
end
 
i=1;
while (i<x)
    j=1;
    while (j<y) 
        if(plate2(i,j)==0) 
            img(i,j,1) = 0;
            img(i,j,2) = 0;
            img(i,j,3) = 0;
        end
        j=j+1;
    end;
    i=i+1;
end;

gray=rgb2gray(img);
if (area==1)
    gray = imcomplement(gray);
end;
gray = im2double(gray);
[x,y]=size(gray);
for i1 = 1:x;
    for j1 = 1:y;
        if gray(i1,j1) == 0.0
            gray(i1,j1) = 1.0;
        end
    end
end

for i1 = 1:x
    gray(i1, y) = 1.0;
end;
for j1 = 1:y
    gray(x, j1) = 1.0;
end;


if (area == 1)
    level = 0.6;
end;
if (area == 2)
    level = 0.2;
end;
if (area == 3)
    level = 0.3;
end;
if (area == 4)
    level = 0.6;
end;

imBinary =im2bw(gray,level);
imBinary = imerode(imBinary, strel('rectangle', [2, 1]));
imBinary = imerode(imBinary, strel('rectangle', [1, 3]));



imBinaryComp = imcomplement(imBinary);
figure,imshow(imBinary);
figure,imshow(imBinaryComp);