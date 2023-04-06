close all
clear
clc

img=imread("bongo_cat.png");
img=imresize(img,.7);
%img=img*255;
%img=flipdim(img ,2);           
img_bw=img>200;



%imshow(uint8(img_bw*255))
figure
subplot(2,1,1);
imshow(img)
title('Image originale')
axis image


%% make 1d bw image and edge
subplot(2,1,2);
img_1d=img_bw(:,:,1);
imshow(uint8(img_1d*255))
title('Image Binaire')
axis image

% img_edge=edge(img_1d);
% imshow(uint8(img_edge*255))
img_1d=rot90(img_1d);
% img_edge=rot90(img_edge);
% img_edge=rot90(img_edge);
%% find each line
figure
[h,w]=size(img_1d);
counter_line=1;
line_vector=zeros(1000,1);

% offset
x_offset=10;
y_offset=230;
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

            %encode
          %  if(abs(x-x2))
                line_vector(counter_line)=bitshift(1,43)+bitshift(1,42)+bitshift(y2+y_offset,30)+bitshift(x2+x_offset,20)+bitshift(y+y_offset,10)+x+x_offset;

                % decode
                decoded_x=bitand(line_vector(counter_line),uint64(0x3FF))-x_offset;
                decoded_y=bitand(bitshift(line_vector(counter_line),-10),uint64(0x3FF))-y_offset;
                decoded_x2=bitand(bitshift(line_vector(counter_line),-20),uint64(0x3FF))-x_offset;
                decoded_y2=bitand(bitshift(line_vector(counter_line),-30),uint64(0x3FF))-y_offset;
                if(decoded_x~=x)||(decoded_x2~=x2)||(decoded_y~=y)||(decoded_y2~=y)
                    fprintf("NOT THE SAME AS ENCODED\n x:%d x2:%d || y2:%d \n======================\n",decoded_x,decoded_x2,decoded_y2)
                end

                %raz
                counter_line=counter_line+1;
                hold on
                plot([x+x_offset x2+x_offset],[y+y_offset y2+y_offset])
            %end
        end
        j=j+1;
    end
end
title('Image vectorisée')
axis image
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
%% encode phrase
phrase="en217 processeur 32bits pour le calcul de nombres premiers";
x=240;
y=10;
resultat_vector=zeros(100,1);
lettres=double(char(phrase));
for i=1:strlength(phrase)
    %fprintf("i%d\n",i)
    lettre=lettres(i);
    resultat_vector(i)=bitshift(1,38+6)+bitshift(char2glyph(lettre),20)+bitshift(y,10)+(x+i*6);
end
fileID = fopen('data_text.txt','w');
fprintf(fileID,"x""%012lx"",\n",nonzeros(resultat_vector));
fclose(fileID);
