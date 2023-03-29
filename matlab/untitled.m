close all
clear
clc

img=imread("qr.png");
img_bw=img>200;


%imshow(uint8(img_bw*255))
figure
subplot(2,1,1);
imshow(img)
axis image


%% make 1d bw image and edge
subplot(2,1,2);
img_1d=img_bw(:,:,1);
imshow(uint8(img_1d*255))
axis image

% img_edge=edge(img_1d);
% imshow(uint8(img_edge*255))
img_1d=rot90(img_1d);
% img_edge=rot90(img_edge);
% img_edge=rot90(img_edge);
%% find each line
figure
[h,w]=size(img_1d);
found=false;
counter_line=1;
line_vector=zeros(1000,1);
x=int32(0);
y=int32(0);
x2=int32(0);
y2=int32(0);
found=false;
% offset
x_offset=200;
y_offset=100;
% aaaaaa
for i=1:w %each y
    j=1;
    while(j<h)%while we havent looked at alle pixels in line
        if(img_1d(j,i)==1)
            x=j;
            y=i;
            while(j<h && img_1d(j,i)==1)
                j=j+1;
            end
            x2=j;
            y2=i;
            fprintf("found x:%d x2:%d || y2:%d counter_line:%d\n",x,x2,y2,counter_line)
            found=false;
            line_vector(counter_line)=bitshift(1,43)+bitshift(1,42)+bitshift(y2+y_offset,30)+bitshift(x2+x_offset,20)+bitshift(y+y_offset,10)+x+x_offset;
            counter_line=counter_line+1;
            hold on
            plot([x+x_offset x2+x_offset],[y+y_offset y2+y_offset])
        end
        j=j+1;
    end
end

%% print all lines
% for i=1:size(line_vector)
%     if(line_vector(i)==0)
%         break;
%     end
%     fprintf("x""%012lx"",\n",line_vector(i));
% end

fileID = fopen('data.txt','w');
fprintf(fileID,"x""%012lx"",\n",nonzeros(line_vector));
fclose(fileID);
%plot(line_vector)
%%
phrase="cberthelot t bo";
x=200;
y=250;
resultat_vector=zeros(100,1);
lettres=double(char(phrase));
for i=1:strlength(phrase)
lettre=lettres(i);
resultat_vector(i)=bitshift(1,38+6)+bitshift(char2glyph(lettre),20)+bitshift(y,10)+(x+i*6);
end
fileID = fopen('data_text.txt','w');
fprintf(fileID,"x""%012lx"",\n",nonzeros(resultat_vector));
fclose(fileID);