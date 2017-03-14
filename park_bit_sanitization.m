IM_Red=Red;
IM_Green=Green;
IM_Blue=Blue;
eccentricity2=xlsread('eccentricity_red.xlsx'); %read excel file
max1=eccentricity2(1,1); %find max eccentricity value
min1=eccentricity2(row*col,1); %find minimum eccentricity value

%Segment the eccentricity value into 4 halves
seg_arr=zeros(4);
seg_arr(1)=double((max1-min1)/4);
seg_arr(2)=double((max1-min1)/2);
seg_arr(3)=double((max1-min1)*3/4);
seg_arr(4)=double(max1);
%display(seg_arr);

visited=zeros(row,col); %store number of bits sanitized
index_array=zeros; %array to store index of pixels falling in a particular segemnt half
j=1; %counter
for count=1:row*col %extract those indexes which fall in 1st segment
    if (seg_arr(4)>=eccentricity2(count,1) && eccentricity2(count,1)>seg_arr(3))
        index_array(j,1)=eccentricity2(count,2);
        index_array(j,2)=eccentricity2(count,3);
        j=j+1;
    end
end

%4 bit maniulation
if j>2
for i=1:2:length(index_array)-1
    num1=Red(index_array(i,1),index_array(i,2)); %pixel value
%     if bit_man(index_array(i,1),index_array(i,2)) < 4
%         bit_man(index_array(i,1),index_array(i,2))=4;
%     end
    num2=Red(index_array(i+1,1),index_array(i+1,2)); %2nd pixel value
%     if bit_man(index_array(i+1,1),index_array(i+1,2)) < 4
%         bit_man(index_array(i+1,1),index_array(i+1,2))=4;
%     end
    %set visited as 4
    visited(index_array(i,1),index_array(i,2))=4; 
    visited(index_array(i+1,1),index_array(i+1,2))=4;
    %find binary equivalent
    num1_bin=dec2bin(num1);
    num2_bin=dec2bin(num2);
    %store individual bits from LSB
    temp1=num1_bin(numel(num1_bin));
    temp2=num1_bin(numel(num1_bin)-1);
    temp3=num1_bin(numel(num1_bin)-2);
    temp4=num1_bin(numel(num1_bin)-3);
    temp5=num2_bin(numel(num2_bin));
    temp6=num2_bin(numel(num2_bin)-1);
    temp7=num2_bin(numel(num2_bin)-2);
    temp8=num2_bin(numel(num2_bin)-3);
    %Rearrange according to algorithm
    num1_bin(numel(num1_bin))=temp6;
    num1_bin(numel(num1_bin)-1)=temp7;
    num1_bin(numel(num1_bin)-2)=temp8;
    num1_bin(numel(num1_bin)-3)=temp5;
    num2_bin(numel(num2_bin))=temp2;
    num2_bin(numel(num2_bin)-1)=temp3;
    num2_bin(numel(num2_bin)-2)=temp4;
    num2_bin(numel(num2_bin)-3)=temp1;
    %save them back in decimal form
    IM_Red(index_array(i,1),index_array(i,2))=bin2dec(num1_bin);
    IM_Red(index_array(i+1,1),index_array(i+1,2))=bin2dec(num2_bin);
end
end
display('1st done');
%2nd Segment
index_array=zeros;
j=1;
for count=1:row*col %indexes falling in 2nd segment
    if (eccentricity2(count,1)>seg_arr(2) && eccentricity2(count,1)<=seg_arr(3))
        index_array(j,1)=eccentricity2(count,2);
        index_array(j,2)=eccentricity2(count,3);
        j=j+1;
    end
end
%3 bit manipulation
if j>2
for i=1:2:length(index_array)-1
    num1=Red(index_array(i,1),index_array(i,2));
%     if bit_man(index_array(i,1),index_array(i,2)) < 3
%         bit_man(index_array(i,1),index_array(i,2))=3;
%     end
    num2=Red(index_array(i+1,1),index_array(i+1,2));
%     if bit_man(index_array(i+1,1),index_array(i+1,2)) < 3
%         bit_man(index_array(i+1,1),index_array(i+1,2))=3;
%     end
    visited(index_array(i,1),index_array(i,2))=3;
    visited(index_array(i+1,1),index_array(i+1,2))=3;
    num1_bin=dec2bin(num1);
    num2_bin=dec2bin(num2);
    temp1=num1_bin(numel(num1_bin));
    temp2=num1_bin(numel(num1_bin)-1);
    temp3=num1_bin(numel(num1_bin)-2);
    temp4=num2_bin(numel(num2_bin));
    temp5=num2_bin(numel(num2_bin)-1);
    temp6=num2_bin(numel(num2_bin)-2);
    num1_bin(numel(num1_bin))=temp5;
    num1_bin(numel(num1_bin)-1)=temp6;
    num1_bin(numel(num1_bin)-2)=temp1;
    num2_bin(numel(num2_bin))=temp2;
    num2_bin(numel(num2_bin)-1)=temp3;
    num2_bin(numel(num2_bin)-2)=temp4;
    IM_Red(index_array(i,1),index_array(i,2))=bin2dec(num1_bin);
    IM_Red(index_array(i+1,1),index_array(i+1,2))=bin2dec(num2_bin);
end
end
display('2nd done');
%3rd Segment
index_array=zeros;
j=1;
for count=1:row*col %those indexes falling in 3rd segment
    if (eccentricity2(count,1)>seg_arr(1) && eccentricity2(count,1)<=seg_arr(2))
        index_array(j,1)=eccentricity2(count,2);
        index_array(j,2)=eccentricity2(count,3);
        j=j+1;
    end
end
%2 bit manipulation
if j>2
for i=1:2:length(index_array)-1
    num1=Red(index_array(i,1),index_array(i,2));
%     if bit_man(index_array(i,1),index_array(i,2)) < 2
%         bit_man(index_array(i,1),index_array(i,2))=2;
%     end
    num2=Red(index_array(i+1,1),index_array(i+1,2));
%     if bit_man(index_array(i+1,1),index_array(i+1,2)) < 2
%         bit_man(index_array(i+1,1),index_array(i+1,2))=2;
%     end
    visited(index_array(i,1),index_array(i,2))=2;
    visited(index_array(i+1,1),index_array(i+1,2))=2;
    num1_bin=dec2bin(num1);
    num2_bin=dec2bin(num2);
    if num1>1 && num2>1
    temp1=num1_bin(numel(num1_bin));
    temp2=num1_bin(numel(num1_bin)-1);
    temp3=num2_bin(numel(num2_bin));
    temp4=num2_bin(numel(num2_bin)-1);
    num1_bin(numel(num1_bin))=temp4;
    num1_bin(numel(num1_bin)-1)=temp3;
    num2_bin(numel(num2_bin))=temp2;
    num2_bin(numel(num2_bin)-1)=temp1;
    IM_Red(index_array(i,1),index_array(i,2))=bin2dec(num1_bin);
    IM_Red(index_array(i+1,1),index_array(i+1,2))=bin2dec(num2_bin);
    end
end
end
display('3rd done');
%4th Segment
index_array=zeros;
j=1;
for count=1:row*col %those falling in last segment
    if (eccentricity2(count,1)<=seg_arr(1) && eccentricity2(count,1)>=min1)
        index_array(j,1)=eccentricity2(count,2);
        index_array(j,2)=eccentricity2(count,3);
        j=j+1;
    end
end
%LSB manipulation
if j>2
for i=1:2:length(index_array)-1
    num1=Red(index_array(i,1),index_array(i,2));
    visited(index_array(i,1),index_array(i,2))=1;
    visited(index_array(i+1,1),index_array(i+1,2))=1;
    num2=Red(index_array(i+1,1),index_array(i+1,2));
    num1_bin=dec2bin(num1);
    num2_bin=dec2bin(num2);
    temp1=num1_bin(numel(num1_bin));
    temp2=num2_bin(numel(num2_bin));
    num1_bin(numel(num1_bin))=temp2;
    num2_bin(numel(num2_bin))=temp1;
    IM_Red(index_array(i,1),index_array(i,2))=bin2dec(num1_bin);
    IM_Red(index_array(i+1,1),index_array(i+1,2))=bin2dec(num2_bin);
end
end
IM_Red=uint8(IM_Red); %convert it to integer in the range of [0,255]
%dif=double(Im)-double(IM_Red);
%figure,imshow(IM_Red);
display('Red Done!!');

%********************************************************************
eccentricity2=zeros(row*col,3);
eccentricity2=xlsread('eccentricity_green.xlsx'); %read excel file
max1=eccentricity2(1,1); %find max eccentricity value
min1=eccentricity2(row*col,1); %find minimum eccentricity value

%Segment the eccentricity value into 4 halves
seg_arr=zeros(4);
seg_arr(1)=double((max1-min1)/4);
seg_arr(2)=double((max1-min1)/2);
seg_arr(3)=double((max1-min1)*3/4);
seg_arr(4)=double(max1);
%display(seg_arr);

visited=zeros(row,col); %store number of bits sanitized
index_array=zeros; %array to store index of pixels falling in a particular segemnt half
j=1; %counter
for count=1:row*col %extract those indexes which fall in 1st segment
    if (seg_arr(4)>=eccentricity2(count,1) && eccentricity2(count,1)>seg_arr(3))
        index_array(j,1)=eccentricity2(count,2);
        index_array(j,2)=eccentricity2(count,3);
        j=j+1;
    end
end

%4 bit maniulation
if j>2
for i=1:2:length(index_array)-1
    num1=Green(index_array(i,1),index_array(i,2)); %pixel value
%     if bit_man(index_array(i,1),index_array(i,2)) < 4
%         bit_man(index_array(i,1),index_array(i,2))=4;
%     end
    num2=Green(index_array(i+1,1),index_array(i+1,2)); %2nd pixel value
%     if bit_man(index_array(i+1,1),index_array(i+1,2)) < 4
%         bit_man(index_array(i+1,1),index_array(i+1,2))=4;
%     end
    %set visited as 4
    visited(index_array(i,1),index_array(i,2))=4; 
    visited(index_array(i+1,1),index_array(i+1,2))=4;
    %find binary equivalent
    num1_bin=dec2bin(num1);
    num2_bin=dec2bin(num2);
    %store individual bits from LSB
    temp1=num1_bin(numel(num1_bin));
    temp2=num1_bin(numel(num1_bin)-1);
    temp3=num1_bin(numel(num1_bin)-2);
    temp4=num1_bin(numel(num1_bin)-3);
    temp5=num2_bin(numel(num2_bin));
    temp6=num2_bin(numel(num2_bin)-1);
    temp7=num2_bin(numel(num2_bin)-2);
    temp8=num2_bin(numel(num2_bin)-3);
    %Rearrange according to algorithm
    num1_bin(numel(num1_bin))=temp6;
    num1_bin(numel(num1_bin)-1)=temp7;
    num1_bin(numel(num1_bin)-2)=temp8;
    num1_bin(numel(num1_bin)-3)=temp5;
    num2_bin(numel(num2_bin))=temp2;
    num2_bin(numel(num2_bin)-1)=temp3;
    num2_bin(numel(num2_bin)-2)=temp4;
    num2_bin(numel(num2_bin)-3)=temp1;
    %save them back in decimal form
    IM_Green(index_array(i,1),index_array(i,2))=bin2dec(num1_bin);
    IM_Green(index_array(i+1,1),index_array(i+1,2))=bin2dec(num2_bin);
end
end
display('1st done');
%2nd Segment
index_array=zeros;
j=1;
for count=1:row*col %indexes falling in 2nd segment
    if (eccentricity2(count,1)>seg_arr(2) && eccentricity2(count,1)<=seg_arr(3))
        index_array(j,1)=eccentricity2(count,2);
        index_array(j,2)=eccentricity2(count,3);
        j=j+1;
    end
end
%3 bit manipulation
if j>2
for i=1:2:length(index_array)-1
    num1=Green(index_array(i,1),index_array(i,2));
%     if bit_man(index_array(i,1),index_array(i,2)) < 3
%         bit_man(index_array(i,1),index_array(i,2))=3;
%     end
    num2=Green(index_array(i+1,1),index_array(i+1,2));
%     if bit_man(index_array(i+1,1),index_array(i+1,2)) < 3
%         bit_man(index_array(i+1,1),index_array(i+1,2))=3;
%     end
    visited(index_array(i,1),index_array(i,2))=3;
    visited(index_array(i+1,1),index_array(i+1,2))=3;
    num1_bin=dec2bin(num1);
    num2_bin=dec2bin(num2);
    temp1=num1_bin(numel(num1_bin));
    temp2=num1_bin(numel(num1_bin)-1);
    temp3=num1_bin(numel(num1_bin)-2);
    temp4=num2_bin(numel(num2_bin));
    temp5=num2_bin(numel(num2_bin)-1);
    temp6=num2_bin(numel(num2_bin)-2);
    num1_bin(numel(num1_bin))=temp5;
    num1_bin(numel(num1_bin)-1)=temp6;
    num1_bin(numel(num1_bin)-2)=temp1;
    num2_bin(numel(num2_bin))=temp2;
    num2_bin(numel(num2_bin)-1)=temp3;
    num2_bin(numel(num2_bin)-2)=temp4;
    IM_Green(index_array(i,1),index_array(i,2))=bin2dec(num1_bin);
    IM_Green(index_array(i+1,1),index_array(i+1,2))=bin2dec(num2_bin);
end
end
display('2nd done');
%3rd Segment
index_array=zeros;
j=1;
for count=1:row*col %those indexes falling in 3rd segment
    if (eccentricity2(count,1)>seg_arr(1) && eccentricity2(count,1)<=seg_arr(2))
        index_array(j,1)=eccentricity2(count,2);
        index_array(j,2)=eccentricity2(count,3);
        j=j+1;
    end
end
%2 bit manipulation
if j>2
for i=1:2:length(index_array)-1
    num1=Green(index_array(i,1),index_array(i,2));
%     if bit_man(index_array(i,1),index_array(i,2)) < 2
%         bit_man(index_array(i,1),index_array(i,2))=2;
%     end
    num2=Green(index_array(i+1,1),index_array(i+1,2));
%     if bit_man(index_array(i+1,1),index_array(i+1,2)) < 2
%         bit_man(index_array(i+1,1),index_array(i+1,2))=2;
%     end
    visited(index_array(i,1),index_array(i,2))=2;
    visited(index_array(i+1,1),index_array(i+1,2))=2;
    num1_bin=dec2bin(num1);
    num2_bin=dec2bin(num2);
    if num1>1 && num2>1
    temp1=num1_bin(numel(num1_bin));
    temp2=num1_bin(numel(num1_bin)-1);
    temp3=num2_bin(numel(num2_bin));
    temp4=num2_bin(numel(num2_bin)-1);
    num1_bin(numel(num1_bin))=temp4;
    num1_bin(numel(num1_bin)-1)=temp3;
    num2_bin(numel(num2_bin))=temp2;
    num2_bin(numel(num2_bin)-1)=temp1;
    IM_Green(index_array(i,1),index_array(i,2))=bin2dec(num1_bin);
    IM_Green(index_array(i+1,1),index_array(i+1,2))=bin2dec(num2_bin);
    end
end
end
display('3rd done');
%4th Segment
index_array=zeros;
j=1;
for count=1:row*col %those falling in last segment
    if (eccentricity2(count,1)<=seg_arr(1) && eccentricity2(count,1)>=min1)
        index_array(j,1)=eccentricity2(count,2);
        index_array(j,2)=eccentricity2(count,3);
        j=j+1;
    end
end
%LSB manipulation
if j>2
for i=1:2:length(index_array)-1
    num1=Green(index_array(i,1),index_array(i,2));
    visited(index_array(i,1),index_array(i,2))=1;
    visited(index_array(i+1,1),index_array(i+1,2))=1;
    num2=Green(index_array(i+1,1),index_array(i+1,2));
    num1_bin=dec2bin(num1);
    num2_bin=dec2bin(num2);
    temp1=num1_bin(numel(num1_bin));
    temp2=num2_bin(numel(num2_bin));
    num1_bin(numel(num1_bin))=temp2;
    num2_bin(numel(num2_bin))=temp1;
    IM_Green(index_array(i,1),index_array(i,2))=bin2dec(num1_bin);
    IM_Green(index_array(i+1,1),index_array(i+1,2))=bin2dec(num2_bin);
end
end
IM_Green=uint8(IM_Green); %convert it to integer in the range of [0,255]
%dif=double(Im)-double(IM_Green);
%figure,imshow(IM_Green);
display('Green Done!!');

%**********************************************************************
eccentricity2=zeros(row*col,3);
eccentricity2=xlsread('eccentricity_blue.xlsx'); %read excel file
max1=eccentricity2(1,1); %find max eccentricity value
min1=eccentricity2(row*col,1); %find minimum eccentricity value

%Segment the eccentricity value into 4 halves
seg_arr=zeros(4);
seg_arr(1)=double((max1-min1)/4);
seg_arr(2)=double((max1-min1)/2);
seg_arr(3)=double((max1-min1)*3/4);
seg_arr(4)=double(max1);
%display(seg_arr);

visited=zeros(row,col); %store number of bits sanitized
index_array=zeros; %array to store index of pixels falling in a particular segemnt half
j=1; %counter
for count=1:row*col %extract those indexes which fall in 1st segment
    if (seg_arr(4)>=eccentricity2(count,1) && eccentricity2(count,1)>seg_arr(3))
        index_array(j,1)=eccentricity2(count,2);
        index_array(j,2)=eccentricity2(count,3);
        j=j+1;
    end
end

%4 bit maniulation
if j>2
for i=1:2:length(index_array)-1
    num1=Blue(index_array(i,1),index_array(i,2)); %pixel value
%     if bit_man(index_array(i,1),index_array(i,2)) < 4
%         bit_man(index_array(i,1),index_array(i,2))=4;
%     end
    num2=Blue(index_array(i+1,1),index_array(i+1,2)); %2nd pixel value
%     if bit_man(index_array(i+1,1),index_array(i+1,2)) < 4
%         bit_man(index_array(i+1,1),index_array(i+1,2))=4;
%     end
    %set visited as 4
    visited(index_array(i,1),index_array(i,2))=4; 
    visited(index_array(i+1,1),index_array(i+1,2))=4;
    %find binary equivalent
    num1_bin=dec2bin(num1);
    num2_bin=dec2bin(num2);
    %store individual bits from LSB
    temp1=num1_bin(numel(num1_bin));
    temp2=num1_bin(numel(num1_bin)-1);
    temp3=num1_bin(numel(num1_bin)-2);
    temp4=num1_bin(numel(num1_bin)-3);
    temp5=num2_bin(numel(num2_bin));
    temp6=num2_bin(numel(num2_bin)-1);
    temp7=num2_bin(numel(num2_bin)-2);
    temp8=num2_bin(numel(num2_bin)-3);
    %Rearrange according to algorithm
    num1_bin(numel(num1_bin))=temp6;
    num1_bin(numel(num1_bin)-1)=temp7;
    num1_bin(numel(num1_bin)-2)=temp8;
    num1_bin(numel(num1_bin)-3)=temp5;
    num2_bin(numel(num2_bin))=temp2;
    num2_bin(numel(num2_bin)-1)=temp3;
    num2_bin(numel(num2_bin)-2)=temp4;
    num2_bin(numel(num2_bin)-3)=temp1;
    %save them back in decimal form
    IM_Blue(index_array(i,1),index_array(i,2))=bin2dec(num1_bin);
    IM_Blue(index_array(i+1,1),index_array(i+1,2))=bin2dec(num2_bin);
end
end
display('1st done');
%2nd Segment
index_array=zeros;
j=1;
for count=1:row*col %indexes falling in 2nd segment
    if (eccentricity2(count,1)>seg_arr(2) && eccentricity2(count,1)<=seg_arr(3))
        index_array(j,1)=eccentricity2(count,2);
        index_array(j,2)=eccentricity2(count,3);
        j=j+1;
    end
end
%3 bit manipulation
if j>2
for i=1:2:length(index_array)-1
    num1=Blue(index_array(i,1),index_array(i,2));
%     if bit_man(index_array(i,1),index_array(i,2)) < 3
%         bit_man(index_array(i,1),index_array(i,2))=3;
%     end
    num2=Blue(index_array(i+1,1),index_array(i+1,2));
%     if bit_man(index_array(i+1,1),index_array(i+1,2)) < 3
%         bit_man(index_array(i+1,1),index_array(i+1,2))=3;
%     end
    visited(index_array(i,1),index_array(i,2))=3;
    visited(index_array(i+1,1),index_array(i+1,2))=3;
    num1_bin=dec2bin(num1);
    num2_bin=dec2bin(num2);
    temp1=num1_bin(numel(num1_bin));
    temp2=num1_bin(numel(num1_bin)-1);
    temp3=num1_bin(numel(num1_bin)-2);
    temp4=num2_bin(numel(num2_bin));
    temp5=num2_bin(numel(num2_bin)-1);
    temp6=num2_bin(numel(num2_bin)-2);
    num1_bin(numel(num1_bin))=temp5;
    num1_bin(numel(num1_bin)-1)=temp6;
    num1_bin(numel(num1_bin)-2)=temp1;
    num2_bin(numel(num2_bin))=temp2;
    num2_bin(numel(num2_bin)-1)=temp3;
    num2_bin(numel(num2_bin)-2)=temp4;
    IM_Blue(index_array(i,1),index_array(i,2))=bin2dec(num1_bin);
    IM_Blue(index_array(i+1,1),index_array(i+1,2))=bin2dec(num2_bin);
end
end
display('2nd done');
%3rd Segment
index_array=zeros;
j=1;
for count=1:row*col %those indexes falling in 3rd segment
    if (eccentricity2(count,1)>seg_arr(1) && eccentricity2(count,1)<=seg_arr(2))
        index_array(j,1)=eccentricity2(count,2);
        index_array(j,2)=eccentricity2(count,3);
        j=j+1;
    end
end
%2 bit manipulation
if j>2
for i=1:2:length(index_array)-1
    num1=Blue(index_array(i,1),index_array(i,2));
%     if bit_man(index_array(i,1),index_array(i,2)) < 2
%         bit_man(index_array(i,1),index_array(i,2))=2;
%     end
    num2=Blue(index_array(i+1,1),index_array(i+1,2));
%     if bit_man(index_array(i+1,1),index_array(i+1,2)) < 2
%         bit_man(index_array(i+1,1),index_array(i+1,2))=2;
%     end
    if num1>1 && num2>1
    visited(index_array(i,1),index_array(i,2))=2;
    visited(index_array(i+1,1),index_array(i+1,2))=2;
    num1_bin=dec2bin(num1);
    num2_bin=dec2bin(num2);
    temp1=num1_bin(numel(num1_bin));
    temp2=num1_bin(numel(num1_bin)-1);
    temp3=num2_bin(numel(num2_bin));
    temp4=num2_bin(numel(num2_bin)-1);
    num1_bin(numel(num1_bin))=temp4;
    num1_bin(numel(num1_bin)-1)=temp3;
    num2_bin(numel(num2_bin))=temp2;
    num2_bin(numel(num2_bin)-1)=temp1;
    IM_Blue(index_array(i,1),index_array(i,2))=bin2dec(num1_bin);
    IM_Blue(index_array(i+1,1),index_array(i+1,2))=bin2dec(num2_bin);
    end
end
end
display('3rd done');
%4th Segment
index_array=zeros;
j=1;
for count=1:row*col %those falling in last segment
    if (eccentricity2(count,1)<=seg_arr(1) && eccentricity2(count,1)>=min1)
        index_array(j,1)=eccentricity2(count,2);
        index_array(j,2)=eccentricity2(count,3);
        j=j+1;
    end
end
%LSB manipulation
if j>2
for i=1:2:length(index_array)-1
    num1=Blue(index_array(i,1),index_array(i,2));
    visited(index_array(i,1),index_array(i,2))=1;
    visited(index_array(i+1,1),index_array(i+1,2))=1;
    num2=Blue(index_array(i+1,1),index_array(i+1,2));
    num1_bin=dec2bin(num1);
    num2_bin=dec2bin(num2);
    temp1=num1_bin(numel(num1_bin));
    temp2=num2_bin(numel(num2_bin));
    num1_bin(numel(num1_bin))=temp2;
    num2_bin(numel(num2_bin))=temp1;
    IM_Blue(index_array(i,1),index_array(i,2))=bin2dec(num1_bin);
    IM_Blue(index_array(i+1,1),index_array(i+1,2))=bin2dec(num2_bin);
end
end
IM_Blue=uint8(IM_Blue); %convert it to integer in the range of [0,255]
%dif=double(Im)-double(IM_Blue);
%figure,imshow(IM_Blue);
display('Blue Done!!');

X(:,:,1)=IM_Red;
X(:,:,2)=IM_Green;
X(:,:,3)=IM_Blue;
figure,imshow(X);
imwrite(X,'final_forr.bmp','bmp');