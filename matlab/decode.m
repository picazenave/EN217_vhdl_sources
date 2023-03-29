close all
clear
clc
fileID = fopen('data.txt','r');
line_vector=fscanf(fileID,"x""%012lx"",\n");
fclose(fileID);
%% decode
%=bitshift(1,43)+bitshift(1,42)+bitshift(y2+y_offset,30)+bitshift(x2+x_offset,20)+bitshift(y+y_offset,10)+x+x_offset;
line_decoded_y=zeros(5000,1);
line_decoded_x=zeros(5000,1);
line_decoded_y2=zeros(5000,1);
line_decoded_x2=zeros(5000,1);

for i=1:size(line_vector)
    % bits=bitget(line_vector(i),10);
    line_decoded_x(i)=bitand(line_vector(i),uint64(0x3FF));
    line_decoded_y(i)=bitand(bitshift(line_vector(i),-10),uint64(0x3FF));
    line_decoded_y2(i)=bitand(bitshift(line_vector(i),-20),uint64(0x3FF));
    line_decoded_x2(i)=bitand(bitshift(line_vector(i),-30),uint64(0x3FF));
    fprintf("found x:%d x2:%d || y2:%d\n",line_decoded_x(i),line_decoded_x2(i),line_decoded_y(i))
end
