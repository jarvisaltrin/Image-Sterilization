I=imread('forr.bmp'); %Read an image
[row,colm]=size(I); %find the size of image
Red=I(:,:,1);
Green=I(:,:,2);
Blue=I(:,:,3);
col=colm/3;
IM_R=Red;
IM_G=Green;
IM_B=Blue;

fid = fopen('textsteg.txt'); %open text file
text = fscanf(fid,'%s');   %scan the contents of the file
fclose(fid);         %close file
text_bin=dec2bin(text,7);  %converts the contents of file to binary
str=str2num(text_bin);  %make it into an string
len_text_bin=length(str);  %find the length of the string 
arr_x=1; %used as index
arr_y=1; %used as index
flag=0; %used as a flag

i=1;  %counter
j=1;  %index
k1=7;  %counter
%we store the binary value in an array arr where each element consist of an
%0 or 1
while i<=len_text_bin  
     while str(i)>0   %till the last element of the string
         bit=uint8(mod(str(i),10));   %extract one bit
         str(i)=str(i)/10;  %divide by 10
         arr(j,k1)=bit;  %store in arr array
         if k1~=1  %do till 7 bits are extracted then increase row index
            k1=k1-1;
         else
            break;
         end
     end
     i=i+1; %increment
     j=j+1; %increment
     k1=7; %set as 7 again
end
xlswrite('Binary_text.xlsx',arr);
% arr = xlsread('Binary_text.xlsx');
% [len_text_bin j]=size(arr);

for i=2:row
    for j=2:(col-1)
        %window
        wind(1)=Red(i-1,j-1);
        wind(2)=Red(i-1,j);
        wind(3)=Red(i-1,j+1);
        wind(4)=Red(i,j-1);
        g_min=min(wind); %minimum of the window
        g_max=max(wind); %maximum of the window
        d=double(g_max-g_min);  %difference between max and min
        if d>3  %n is the no. of bits to be embedded
            n=ceil(log2(d))-1;
        else
            n=1;
        end
        n_copy=n;
        %display(n);
        %Finding the decimal representation of the hidden message.
        %Extracting the elements to be embedded.
        if arr_x>len_text_bin
            flag=1;
            break;
        end
        b=num2str(arr(arr_x,arr_y)); %decimal equivalent of first bit only
        if arr_y==7
            arr_y=1;
            arr_x=arr_x+1;
        else
            arr_y=arr_y+1;
        end
        if arr_x>len_text_bin
            flag=1;
            break;
        end
        n_copy=n_copy-1;
        %If n_copy >1    
        while n_copy~=0 %till all the bits are extracted, ie copy of n is 0
            if arr_x>len_text_bin
                flag=1;
                break;
            end
            b=strcat(b,num2str(arr(arr_x,arr_y))); %finding decimal equivalent
            if arr_y==7
                arr_y=1;
                arr_x=arr_x+1;
            else
                arr_y=arr_y+1;
            end
            if arr_x>len_text_bin
                flag=1;
                break;
            end
            n_copy=n_copy-1;%decrement by one
        end %end of while
        b=bin2dec(b); %decimal to binary conversion
        t_xy=double(b-(rem(Red(i,j),2^n)));%binary representation minus 2^n
        %display(t_xy);
        %display(b);
        %t_xy Calculation
        if t_xy >= (-(floor(((2^n)-1)/2))) && t_xy <= ceil(((2^n)-1)/2) 
            t_xy=double(t_xy);
        elseif t_xy >= (-(2^n)+1) && t_xy < (-(floor(((2^n)-1)/2)))
            t_xy=double(t_xy + 2^n);
        elseif t_xy > ceil(((2^n)-1)/2) && t_xy < 2^n
            t_xy=double(t_xy - 2^n);
        end
        %display(t_xy);
        g_xy_star=Red(i,j) + t_xy; %G_xy_star calculation
        if g_xy_star < 0 %adjustment if it < 0 or > 255
            g_xy_star = g_xy_star + 2^n;
        elseif g_xy_star > 255
            g_xy_star = g_xy_star - 2^n;
        end
        IM_R(i,j)=g_xy_star;%final value
    end
    %display(i);
end

%*********************************************************************
for i=2:row
    for j=2:(col-1)
        %window
        wind(1)=Green(i-1,j-1);
        wind(2)=Green(i-1,j);
        wind(3)=Green(i-1,j+1);
        wind(4)=Green(i,j-1);
        g_min=min(wind);
        g_max=max(wind);
        d=double(g_max-g_min);
        if d>3
            n=ceil(log2(d))-1;
        else
            n=1;
        end
        n_copy=n;
        %display(n);
        %Finding the decimal representation of the hidden message.
        %Extracting the elements to be embedded.
        if arr_x>len_text_bin
            flag=1;
            break;
        end
        b=num2str(arr(arr_x,arr_y));
        if arr_y==7
            arr_y=1;
            arr_x=arr_x+1;
        else
            arr_y=arr_y+1;
        end
        if arr_x>len_text_bin
            flag=1;
            break;
        end
        n_copy=n_copy-1;
        %If n_copy >1    
        while n_copy~=0
            if arr_x>len_text_bin
                flag=1;
                break;
            end
            b=strcat(b,num2str(arr(arr_x,arr_y)));
            if arr_y==7
                arr_y=1;
                arr_x=arr_x+1;
            else
                arr_y=arr_y+1;
            end
            if arr_x>len_text_bin
                flag=1;
                break;
            end
            n_copy=n_copy-1;
        end
        b=bin2dec(b);
        t_xy=double(b-(rem(Green(i,j),2^n)));
        %display(t_xy);
        %display(b);
        if t_xy >= (-(floor(((2^n)-1)/2))) && t_xy <= ceil(((2^n)-1)/2)
            t_xy=double(t_xy);
        elseif t_xy >= (-(2^n)+1) && t_xy < (-(floor(((2^n)-1)/2)))
            t_xy=double(t_xy + 2^n);
        elseif t_xy > ceil(((2^n)-1)/2) && t_xy < 2^n
            t_xy=double(t_xy - 2^n);
        end
        %display(t_xy);
        g_xy_star=Green(i,j) + t_xy;
        if g_xy_star < 0
            g_xy_star = g_xy_star + 2^n;
        elseif g_xy_star > 255
            g_xy_star = g_xy_star - 2^n;
        end
        IM_G(i,j)=g_xy_star;
    end
    %display(i);
end
%******************************************************************

for i=2:row
    for j=2:(col-1)
        %window
        wind(1)=Blue(i-1,j-1);
        wind(2)=Blue(i-1,j);
        wind(3)=Blue(i-1,j+1);
        wind(4)=Blue(i,j-1);
        g_min=min(wind);
        g_max=max(wind);
        d=double(g_max-g_min);
        if d>3
            n=ceil(log2(d))-1;
        else
            n=1;
        end
        n_copy=n;
        %display(n);
        %Finding the decimal representation of the hidden message.
        %Extracting the elements to be embedded.
        if arr_x>len_text_bin
            flag=1;
            break;
        end
        b=num2str(arr(arr_x,arr_y));
        if arr_y==7
            arr_y=1;
            arr_x=arr_x+1;
        else
            arr_y=arr_y+1;
        end
        if arr_x>len_text_bin
            flag=1;
            break;
        end
        n_copy=n_copy-1;
        %If n_copy >1    
        while n_copy~=0
            if arr_x>len_text_bin
                flag=1;
                break;
            end
            b=strcat(b,num2str(arr(arr_x,arr_y)));
            if arr_y==7
                arr_y=1;
                arr_x=arr_x+1;
            else
                arr_y=arr_y+1;
            end
            if arr_x>len_text_bin
                flag=1;
                break;
            end
            n_copy=n_copy-1;
        end
        b=bin2dec(b);
        t_xy=double(b-(rem(Blue(i,j),2^n)));
        %display(t_xy);
        %display(b);
        if t_xy >= (-(floor(((2^n)-1)/2))) && t_xy <= ceil(((2^n)-1)/2)
            t_xy=double(t_xy);
        elseif t_xy >= (-(2^n)+1) && t_xy < (-(floor(((2^n)-1)/2)))
            t_xy=double(t_xy + 2^n);
        elseif t_xy > ceil(((2^n)-1)/2) && t_xy < 2^n
            t_xy=double(t_xy - 2^n);
        end
        %display(t_xy);
        g_xy_star=Blue(i,j) + t_xy;
        if g_xy_star < 0
            g_xy_star = g_xy_star + 2^n;
        elseif g_xy_star > 255
            g_xy_star = g_xy_star - 2^n;
        end
        IM_B(i,j)=g_xy_star;
    end
    %display(i);
end

X(:,:,1)=IM_R;
X(:,:,2)=IM_G;
X(:,:,3)=IM_B;

figure,imshow(X);
figure,imshow(I);
%diff=double(IMG)-double(Ima);
imwrite(X,'stego_forr.bmp','bmp');