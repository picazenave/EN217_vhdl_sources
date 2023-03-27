close all
clear
clc

img=imread("bongo_cat.png");
img_bw=img>10;


imshow(uint8(img_bw*255))
figure
imshow(img)
axis image

%% make 1d bw image and edge
img_1d=img_bw(:,:,1);
imshow(uint8(img_1d*255))

img_edge=edge(img_1d);
imshow(uint8(img_edge*255))


%% find each line
figure
[h,w]=size(img_edge);
found=false;
counter_line=1;
line_vector=zeros(1000,1);
for i=1:w %each y
    for j=1:h %each x

        if(img_edge(j,i)==1)
            if(found==false)
                x=j;
                y=i;
                found=true;
            elseif(j~=x+1)
                x2=j;
                y2=i;
                fprintf("found x:%d y:%d x2:%d y2:%d\n",x,y,x2,y2)
                found=false;
                line_vector(counter_line)=bitshift(1,43)+bitshift(1,42)+bitshift(y2,29)+bitshift(x2,19)+bitshift(y,9)+x;
                counter_line=counter_line+1;
                hold on
                plot([x x2],[y y2])
%                 plot(x,y,"--o");
%                 hold on
%                 plot(x2,y2,"--o");
                %ligne trouvée
            end

        end
    end

    if(found==true)
        %fprintf("ligne orpheline !\n")
        %une ligne à été trouvée
    end

    found=false;
end

%% print all lines
for i=1:size(line_vector)
    if(line_vector(i)==0)
        break;
    end
    fprintf("x""%012lx"",\n",line_vector(i));
end

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