close all
clear
clc

img=imread("bongo_small.png");
img_bw=img>200;


%imshow(uint8(img_bw*255))
figure
imshow(img)
axis image


%% make 1d bw image and edge
img_1d=img_bw(:,:,1);
imshow(uint8(img_1d*255))

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
            line_vector(counter_line)=bitshift(1,43)+bitshift(1,42)+bitshift(y2,30)+bitshift(x2,20)+bitshift(y,10)+x;
            counter_line=counter_line+1;
            hold on
            plot([x x2],[y y2])
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
% offset_x=10;
% offset_y=10;
% x=int64(svg_temp(i,1))+offset_x;
% y=int64(svg_temp(i,2))+offset_y;
% x2=int64(svg_temp(i,1))+offset_x;
% y2=int64(svg_temp(i,2))+offset_y;
% resultat=bitshift(1,43)+bitshift(1,42)+bitshift(y2,29)+bitshift(x2,19)+bitshift(y,9)+x;
% fprintf("x""%012lx"",\n",resultat);