I=imread('fall.bmp'); %Read an image
[row,colm]=size(I); %find the size of image
Red=I(:,:,1);
Green=I(:,:,2);
Blue=I(:,:,3);
col=colm/3;
IM_R=Red;
IM_G=Green;
IM_B=Blue;
%bit_man=zeros(row,col); %assign zeros to bit_man which stores the number of bits manipulated in each pixel

thv=5; %set threshold as 5
kl=2;  %lower level kl is set as 2
kh=3;  %higher level kh is set as 3
flag=0;  %flag is set to 0


fid = fopen('textsteg.txt'); %open text file
text = fscanf(fid,'%s');   %scan the contents of the file
fclose(fid);         %close file
text_bin=dec2bin(text,7);  %converts the contents of file to binary
str=str2num(text_bin);  %make it into an string
len_text_bin=length(str);  %find the length of the string
arr_x=1;   %used as index
arr_y=1;   %used as index

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
display('Text conversion completed');
for i=1:2:row-1  %run loop from 1 to row-1 with 2 increment
    for j=1:2:col-1  %run loop from 1 to row-1 with 2 increment
        window=Red(i:i+1,j:j+1); %store the 4 pixels in the window array
        min_val=min(min(window));  %find the minimum among them
        max_val=max(max(window));  %find the maximum amomg them
        d=((window(1,1)-min_val)+(window(1,2)-min_val)+(window(2,1)-min_val)+(window(2,2)-min_val))/3; %4 pixel differencing
        if d<=thv %check with threshold value
           k=kl; %set k=kl i.e. 2
        else
           k=kh;  %set k=kh i.e. 3
        end
        %assign no. of bits to be manipulated as k
%         bit_man(i,j)=k;
%         bit_man(i,j+1)=k;
%         bit_man(i+1,j)=k;
%         bit_man(i+1,j+1)=k;
        %Error block check
        if d<=thv && (max_val-min_val)>(2*thv+2)
            continue;
        else
            arr_c=zeros(4,1); %used to store new pixel value after all process
            m=1; %counter of above array
            l=round(-1+(rand(1,4)*2)); %generate random number between {-1,0,1}
            l_ind=1; %index of l
            %embedding process, where each bit is embedded into the pixels
            for x=1:2
                for y=1:2
                    pix=window(x,y);
                    pix_bin_str=dec2bin(pix);
                    if k==2 && pix > 1 %for 2 bit embedding
                       if arr_x>len_text_bin
                           flag=1;
                           break;
                       end
                       pix_bin_str(numel(pix_bin_str)-1)=dec2bin(arr(arr_x,arr_y)); %2nd last bit embedding
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
                       pix_bin_str(numel(pix_bin_str))=dec2bin(arr(arr_x,arr_y)); %lsb embedding
                       if arr_y==7
                           arr_y=1;
                           arr_x=arr_x+1;
                       else
                           arr_y=arr_y+1;
                       end                       
                    elseif k==3 && pix > 3 %for 3 bit embedding
                       if arr_x>len_text_bin
                           flag=1;
                           break;
                       end
                       pix_bin_str(numel(pix_bin_str)-2)=dec2bin(arr(arr_x,arr_y)); %3rd last bit embedding
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
                       pix_bin_str(numel(pix_bin_str)-1)=dec2bin(arr(arr_x,arr_y)); %2nd last bit embedding
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
                       pix_bin_str(numel(pix_bin_str))=dec2bin(arr(arr_x,arr_y)); %lsb embedding
                       if arr_y==7
                           arr_y=1;
                           arr_x=arr_x+1;
                       else
                           arr_y=arr_y+1;
                       end
                    end
                    pix1=bin2dec(pix_bin_str); %binary to decimal conversion after embedding
                    %Adjustment procedure
                    if pix-pix1<=-5  
                        pix1=pix1-8;
                    elseif pix-pix1>=5
                        pix1=pix1+8;
                    end
                    pix1_c=pix1+l(l_ind)*(2^k); %new pixel value after re-adjustment procedure
                    l_ind=l_ind+1; %increment by 1
                    arr_c(m)=pix1_c; %store new value here
                    m=m+1;
                end
                if flag==1        %break if end of embedding string reached
                    break;
                end
           end
           min_val_c=min(arr_c); %find minimum
           max_val_c=max(arr_c); %find maximum
           d_c=((arr_c(1)-min_val_c)+(arr_c(2)-min_val_c)+(arr_c(3)-min_val_c)+(arr_c(4)-min_val_c))/3; %4 pixel differencing
           if d_c<=thv && (max_val_c-min_val_c)>(2*thv+2) %check if it belongs in error block
               continue;
           end
           %assign the final value to the new array for storing output
           IM_R(i,j)=arr_c(1);
           IM_R(i,j+1)=arr_c(2);
           IM_R(i+1,j)=arr_c(3);
           IM_R(i+1,j+1)=arr_c(4);
        end
        if flag==1
            break;
        end
    end
    if flag==1
        break;
    end
end
display('Red');
display(arr_x);
display(arr_y);
%*************************************************
for i=1:2:row-1  %run loop from 1 to row-1 with 2 increment
    for j=1:2:col-1  %run loop from 1 to row-1 with 2 increment
        window=Green(i:i+1,j:j+1); %store the 4 pixels in the window array
        min_val=min(min(window));  %find the minimum among them
        max_val=max(max(window));  %find the maximum amomg them
        d=((window(1,1)-min_val)+(window(1,2)-min_val)+(window(2,1)-min_val)+(window(2,2)-min_val))/3; %4 pixel differencing
        if d<=thv %check with threshold value
           k=kl; %set k=kl i.e. 2
        else
           k=kh;  %set k=kh i.e. 3
        end
        %assign no. of bits to be manipulated as k
%         bit_man(i,j)=k;
%         bit_man(i,j+1)=k;
%         bit_man(i+1,j)=k;
%         bit_man(i+1,j+1)=k;
        %Error block check
        if d<=thv && (max_val-min_val)>(2*thv+2)
            continue;
        else
            arr_c=zeros(4,1); %used to store new pixel value after all process
            m=1; %counter of above array
            l=round(-1+(rand(1,4)*2)); %generate random number between {-1,0,1}
            l_ind=1; %index of l
            %embedding process, where each bit is embedded into the pixels
            for x=1:2
                for y=1:2
                    pix=window(x,y);
                    pix_bin_str=dec2bin(pix);
                    if k==2 && pix > 1 %for 2 bit embedding
                       if arr_x>len_text_bin
                           flag=1;
                           break;
                       end
                       pix_bin_str(numel(pix_bin_str)-1)=dec2bin(arr(arr_x,arr_y)); %2nd last bit embedding
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
                       pix_bin_str(numel(pix_bin_str))=dec2bin(arr(arr_x,arr_y)); %lsb embedding
                       if arr_y==7
                           arr_y=1;
                           arr_x=arr_x+1;
                       else
                           arr_y=arr_y+1;
                       end                       
                    elseif k==3 && pix > 3 %for 3 bit embedding
                       if arr_x>len_text_bin
                           flag=1;
                           break;
                       end
                       pix_bin_str(numel(pix_bin_str)-2)=dec2bin(arr(arr_x,arr_y)); %3rd last bit embedding
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
                       pix_bin_str(numel(pix_bin_str)-1)=dec2bin(arr(arr_x,arr_y)); %2nd last bit embedding
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
                       pix_bin_str(numel(pix_bin_str))=dec2bin(arr(arr_x,arr_y)); %lsb embedding
                       if arr_y==7
                           arr_y=1;
                           arr_x=arr_x+1;
                       else
                           arr_y=arr_y+1;
                       end
                    end
                    pix1=bin2dec(pix_bin_str); %binary to decimal conversion after embedding
                    %Adjustment procedure
                    if pix-pix1<=-5  
                        pix1=pix1-8;
                    elseif pix-pix1>=5
                        pix1=pix1+8;
                    end
                    pix1_c=pix1+l(l_ind)*(2^k); %new pixel value after re-adjustment procedure
                    l_ind=l_ind+1; %increment by 1
                    arr_c(m)=pix1_c; %store new value here
                    m=m+1;
                end
                if flag==1        %break if end of embedding string reached
                    break;
                end
           end
           min_val_c=min(arr_c); %find minimum
           max_val_c=max(arr_c); %find maximum
           d_c=((arr_c(1)-min_val_c)+(arr_c(2)-min_val_c)+(arr_c(3)-min_val_c)+(arr_c(4)-min_val_c))/3; %4 pixel differencing
           if d_c<=thv && (max_val_c-min_val_c)>(2*thv+2) %check if it belongs in error block
               continue;
           end
           %assign the final value to the new array for storing output
           IM_G(i,j)=arr_c(1);
           IM_G(i,j+1)=arr_c(2);
           IM_G(i+1,j)=arr_c(3);
           IM_G(i+1,j+1)=arr_c(4);
        end
        if flag==1
            break;
        end
    end
    if flag==1
        break;
    end
end
display('Green');
display(arr_x);
display(arr_y);
%***********************************************************
for i=1:2:row-1  %run loop from 1 to row-1 with 2 increment
    for j=1:2:col-1  %run loop from 1 to row-1 with 2 increment
        window=Blue(i:i+1,j:j+1); %store the 4 pixels in the window array
        min_val=min(min(window));  %find the minimum among them
        max_val=max(max(window));  %find the maximum amomg them
        d=((window(1,1)-min_val)+(window(1,2)-min_val)+(window(2,1)-min_val)+(window(2,2)-min_val))/3; %4 pixel differencing
        if d<=thv %check with threshold value
           k=kl; %set k=kl i.e. 2
        else
           k=kh;  %set k=kh i.e. 3
        end
        %assign no. of bits to be manipulated as k
%         bit_man(i,j)=k;
%         bit_man(i,j+1)=k;
%         bit_man(i+1,j)=k;
%         bit_man(i+1,j+1)=k;
        %Error block check
        if d<=thv && (max_val-min_val)>(2*thv+2)
            continue;
        else
            arr_c=zeros(4,1); %used to store new pixel value after all process
            m=1; %counter of above array
            l=round(-1+(rand(1,4)*2)); %generate random number between {-1,0,1}
            l_ind=1; %index of l
            %embedding process, where each bit is embedded into the pixels
            for x=1:2
                for y=1:2
                    pix=window(x,y);
                    pix_bin_str=dec2bin(pix);
                    if k==2 && pix > 1 %for 2 bit embedding
                       if arr_x>len_text_bin
                           flag=1;
                           break;
                       end
                       pix_bin_str(numel(pix_bin_str)-1)=dec2bin(arr(arr_x,arr_y)); %2nd last bit embedding
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
                       pix_bin_str(numel(pix_bin_str))=dec2bin(arr(arr_x,arr_y)); %lsb embedding
                       if arr_y==7
                           arr_y=1;
                           arr_x=arr_x+1;
                       else
                           arr_y=arr_y+1;
                       end                       
                    elseif k==3 && pix > 3 %for 3 bit embedding
                       if arr_x>len_text_bin
                           flag=1;
                           break;
                       end
                       pix_bin_str(numel(pix_bin_str)-2)=dec2bin(arr(arr_x,arr_y)); %3rd last bit embedding
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
                       pix_bin_str(numel(pix_bin_str)-1)=dec2bin(arr(arr_x,arr_y)); %2nd last bit embedding
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
                       pix_bin_str(numel(pix_bin_str))=dec2bin(arr(arr_x,arr_y)); %lsb embedding
                       if arr_y==7
                           arr_y=1;
                           arr_x=arr_x+1;
                       else
                           arr_y=arr_y+1;
                       end
                    end
                    pix1=bin2dec(pix_bin_str); %binary to decimal conversion after embedding
                    %Adjustment procedure
                    if pix-pix1<=-5  
                        pix1=pix1-8;
                    elseif pix-pix1>=5
                        pix1=pix1+8;
                    end
                    pix1_c=pix1+l(l_ind)*(2^k); %new pixel value after re-adjustment procedure
                    l_ind=l_ind+1; %increment by 1
                    arr_c(m)=pix1_c; %store new value here
                    m=m+1;
                end
                if flag==1        %break if end of embedding string reached
                    break;
                end
           end
           min_val_c=min(arr_c); %find minimum
           max_val_c=max(arr_c); %find maximum
           d_c=((arr_c(1)-min_val_c)+(arr_c(2)-min_val_c)+(arr_c(3)-min_val_c)+(arr_c(4)-min_val_c))/3; %4 pixel differencing
           if d_c<=thv && (max_val_c-min_val_c)>(2*thv+2) %check if it belongs in error block
               continue;
           end
           %assign the final value to the new array for storing output
           IM_B(i,j)=arr_c(1);
           IM_B(i,j+1)=arr_c(2);
           IM_B(i+1,j)=arr_c(3);
           IM_B(i+1,j+1)=arr_c(4);
        end
        if flag==1
            break;
        end
    end
    if flag==1
        break;
    end
end
display('Blue');
display(arr_x);
display(arr_y);

X(:,:,1)=IM_R;
X(:,:,2)=IM_G;
X(:,:,3)=IM_B;
%diff=double(I)-double(IMG);
imwrite(X,'stego_fall.bmp','bmp'); %write the final output
%diff=double(I)-double(IMG);
figure,imshow(X);
figure,imshow(I);