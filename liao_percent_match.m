%I=imread('cyclone-laila.bmp');
%Im=imread('final_cyclone-laila.bmp');
[row,colm]=size(I); %find the size of image
Red=I(:,:,1);
Green=I(:,:,2);
Blue=I(:,:,3);
col=colm/3;
Red_Im=X(:,:,1);
Green_Im=X(:,:,2);
Blue_Im=X(:,:,3);

one_change=0;%lsb chaange
two_change=0;%2nd bit change
three_change=0;%3rd bit change
four_change=0;%4th bit change
two_total=0;%total no of 2nd bit compared
three_total=0;%total no of 3rd bit compared
four_total=0;%total no of 4th bit compared
out=zeros(3,13);
% diff=zeros(row,col);
% diff=double(I)-double(Im_copy);%difference between cover and sterilized image

for i=1:row
    for j=1:col
        num1_bin=dec2bin(Red(i,j));%binary equivaleent of cover pixel
        num2_bin=dec2bin(Red_Im(i,j));%binary equivaleent of stego pixel
        temp1=num1_bin(numel(num1_bin));
        temp2=num2_bin(numel(num2_bin));
        if temp1~=temp2 %LSB comparison; if not same, increment one_change by 1
                one_change = one_change + 1;
        end
        if Red(i,j)>1 && Red_Im(i,j)>1 %for pixels with value greater than 1, 2nd last bit is compared
        temp3=num1_bin(numel(num1_bin)-1); %2nd last bit of cover
        temp4=num2_bin(numel(num2_bin)-1); %2nd last bit of stego
        if temp3~=temp4 %bit comparison
                two_change = two_change + 1; %if not match increment two_change
        end
        two_total=two_total+1; %increase two_total by 1
        end
        if Red(i,j)>3 && Red_Im(i,j)>3 %for pixel values greater than 3, 3rd last bit is compared
        temp5=num1_bin(numel(num1_bin)-2); 
        temp6=num2_bin(numel(num2_bin)-2);
        if temp5~=temp6
                three_change = three_change + 1; %if not match increment three_change
        end
        three_total=three_total+1; %increase three_total by 1
        end
        if Red(i,j)>7 && Red_Im(i,j)>7 %for pixel values greater than 7, 4th last bit is compared
        temp7=num1_bin(numel(num1_bin)-3);
        temp8=num2_bin(numel(num2_bin)-3);    
        if temp7~=temp8
                four_change = four_change + 1; %if not match increment four_change
        end
        four_total=four_total+1;%increase four_total by one
        end
    end
end
%imwrite(Im_copy,'final_image_garfield2.bmp','bmp');
display('LSB');
percent=100-(one_change/(row*col))*100; %LSB match percentage calculation
display(percent);
out(1,1)=percent;
display('2nd last bit');
percent=100-(two_change/two_total)*100; %2nd last bit match percentage calculation
display(percent);
out(1,2)=percent;
display('3rd last bit'); %3rd last bit match percentage calculation
percent=100-(three_change/three_total)*100;
display(percent);
out(1,3)=percent;
display('4th last bit'); %4th last bit match percentage calculation
percent=100-(four_change/four_total)*100;
display(percent);
out(1,4)=percent;
display('Total match');
percent=100-((one_change+two_change+three_change+four_change)/((row*col)+two_total+three_total+four_total))*100; %Last 4 bit together match percent calculation
display(percent);
out(1,5)=percent;
out(1,6)=four_change;
out(1,7)=four_total;
out(1,8)=three_change;
out(1,9)=three_total;
out(1,10)=two_change;
out(1,11)=two_total;
out(1,12)=one_change;
out(1,13)=(row*col);
% out(1,14)=row;
% out(1,15)=col;
%xlswrite('Res.xls',out);

%*************************************************************
one_change=0;%lsb chaange
two_change=0;%2nd bit change
three_change=0;%3rd bit change
four_change=0;%4th bit change
two_total=0;%total no of 2nd bit compared
three_total=0;%total no of 3rd bit compared
four_total=0;%total no of 4th bit compared

% diff=zeros(row,col);
% diff=double(I)-double(Im_copy);%difference between cover and sterilized image

for i=1:row
    for j=1:col
        num1_bin=dec2bin(Green(i,j));%binary equivaleent of cover pixel
        num2_bin=dec2bin(Green_Im(i,j));%binary equivaleent of stego pixel
        temp1=num1_bin(numel(num1_bin));
        temp2=num2_bin(numel(num2_bin));
        if temp1~=temp2 %LSB comparison; if not same, increment one_change by 1
                one_change = one_change + 1;
        end
        if Green(i,j)>1 && Green_Im(i,j)>1 %for pixels with value greater than 1, 2nd last bit is compared
        temp3=num1_bin(numel(num1_bin)-1); %2nd last bit of cover
        temp4=num2_bin(numel(num2_bin)-1); %2nd last bit of stego
        if temp3~=temp4 %bit comparison
                two_change = two_change + 1; %if not match increment two_change
        end
        two_total=two_total+1; %increase two_total by 1
        end
        if Green(i,j)>3 && Green_Im(i,j)>3 %for pixel values greater than 3, 3rd last bit is compared
        temp5=num1_bin(numel(num1_bin)-2);
        temp6=num2_bin(numel(num2_bin)-2);
        if temp5~=temp6
                three_change = three_change + 1; %if not match increment three_change
        end
        three_total=three_total+1; %increase three_total by 1
        end
        if Green(i,j)>7 && Green_Im(i,j)>7 %for pixel values greater than 7, 4th last bit is compared
        temp7=num1_bin(numel(num1_bin)-3);
        temp8=num2_bin(numel(num2_bin)-3);    
        if temp7~=temp8
                four_change = four_change + 1; %if not match increment four_change
        end
        four_total=four_total+1;%increase four_total by one
        end
    end
end
%imwrite(Im_copy,'final_image_garfield2.bmp','bmp');
display('LSB');
percent=100-(one_change/(row*col))*100; %LSB match percentage calculation
display(percent);
out(2,1)=percent;
display('2nd last bit');
percent=100-(two_change/two_total)*100; %2nd last bit match percentage calculation
display(percent);
out(2,2)=percent;
display('3rd last bit'); %3rd last bit match percentage calculation
percent=100-(three_change/three_total)*100;
display(percent);
out(2,3)=percent;
display('4th last bit'); %4th last bit match percentage calculation
percent=100-(four_change/four_total)*100;
display(percent);
out(2,4)=percent;
display('Total match');
percent=100-((one_change+two_change+three_change+four_change)/((row*col)+two_total+three_total+four_total))*100; %Last 4 bit together match percent calculation
display(percent);
out(2,5)=percent;
out(2,6)=four_change;
out(2,7)=four_total;
out(2,8)=three_change;
out(2,9)=three_total;
out(2,10)=two_change;
out(2,11)=two_total;
out(2,12)=one_change;
out(2,13)=(row*col);

%*****************************************************************

one_change=0;%lsb chaange
two_change=0;%2nd bit change
three_change=0;%3rd bit change
four_change=0;%4th bit change
two_total=0;%total no of 2nd bit compared
three_total=0;%total no of 3rd bit compared
four_total=0;%total no of 4th bit compared

% diff=zeros(row,col);
% diff=double(I)-double(Im_copy);%difference between cover and sterilized image

for i=1:row
    for j=1:col
        num1_bin=dec2bin(Blue(i,j));%binary equivaleent of cover pixel
        num2_bin=dec2bin(Blue_Im(i,j));%binary equivaleent of stego pixel
        temp1=num1_bin(numel(num1_bin));
        temp2=num2_bin(numel(num2_bin));
        if temp1~=temp2 %LSB comparison; if not same, increment one_change by 1
                one_change = one_change + 1;
        end
        if Blue(i,j)>1 && Blue_Im(i,j)>1 %for pixels with value greater than 1, 2nd last bit is compared
        temp3=num1_bin(numel(num1_bin)-1); %2nd last bit of cover
        temp4=num2_bin(numel(num2_bin)-1); %2nd last bit of stego
        if temp3~=temp4 %bit comparison
                two_change = two_change + 1; %if not match increment two_change
        end
        two_total=two_total+1; %increase two_total by 1
        end
        if Blue(i,j)>3 && Blue_Im(i,j)>3 %for pixel values greater than 3, 3rd last bit is compared
        temp5=num1_bin(numel(num1_bin)-2);
        temp6=num2_bin(numel(num2_bin)-2);
        if temp5~=temp6
                three_change = three_change + 1; %if not match increment three_change
        end
        three_total=three_total+1; %increase three_total by 1
        end
        if Blue(i,j)>7 && Blue_Im(i,j)>7 %for pixel values greater than 7, 4th last bit is compared
        temp7=num1_bin(numel(num1_bin)-3);
        temp8=num2_bin(numel(num2_bin)-3);    
        if temp7~=temp8
                four_change = four_change + 1; %if not match increment four_change
        end
        four_total=four_total+1;%increase four_total by one
        end
    end
end
%imwrite(Im_copy,'final_image_garfield2.bmp','bmp');
display('LSB');
percent=100-(one_change/(row*col))*100; %LSB match percentage calculation
display(percent);
out(3,1)=percent;
display('2nd last bit');
percent=100-(two_change/two_total)*100; %2nd last bit match percentage calculation
display(percent);
out(3,2)=percent;
display('3rd last bit'); %3rd last bit match percentage calculation
percent=100-(three_change/three_total)*100;
display(percent);
out(3,3)=percent;
display('4th last bit'); %4th last bit match percentage calculation
percent=100-(four_change/four_total)*100;
display(percent);
out(3,4)=percent;
display('Total match');
percent=100-((one_change+two_change+three_change+four_change)/((row*col)+two_total+three_total+four_total))*100; %Last 4 bit together match percent calculation
display(percent);
out(3,5)=percent;
out(3,6)=four_change;
out(3,7)=four_total;
out(3,8)=three_change;
out(3,9)=three_total;
out(3,10)=two_change;
out(3,11)=two_total;
out(3,12)=one_change;
out(3,13)=(row*col);