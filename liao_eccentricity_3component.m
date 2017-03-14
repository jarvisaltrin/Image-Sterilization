Im=double(imread('stego_fall.bmp')); %read image
[row,colm]=size(Im); %find size of image
Im_copy=Im; %copy image
Red=Im(:,:,1);
Green=Im(:,:,2);
Blue=Im(:,:,3);
col=colm/3;
IM_R=zeros(row+2,col+2); %used for padding
IM_G=zeros(row+2,col+2); %used for padding
IM_B=zeros(row+2,col+2); %used for padding
%Adding and extra row and column on each side and filling it with zeros.
for i=2:row+1
    for j=2:col+1
        IM_R(i,j)=Red(i-1,j-1);
    end
end
%I=[1 0 1;1 1 1;0 0 1];
sum=0;
m11=0; %1st order moment
m10=0; %1st order moment
m01=0; %1st order moment
m20=0; %2nd order moment
m02=0; %2nd order moment
%Moment calculation for the whole image
for i=1:row+2
    for j=1:col+2
        sum=(sum+IM_R(i,j));
       % display(sum);
        m10=double(m10+(i*IM_R(i,j))); 
        m01=double(m01+(j*IM_R(i,j)));
        m00=sum; %0 order moment
        m11=double(m11+(i*j*IM_R(i,j)));
        m20=double(m20+(i*i*IM_R(i,j)));
        m02=double(m02+(j*j*IM_R(i,j)));
    end
end
xc=double(m10/sum); %X_c of centroid
yc=double(m01/sum); %Y_c of centroid
x_dash=double(m10/m00);
y_dash=double(m01/m00);
% display(xc);
% display(yc);
% display(x_dash);
% display(y_dash);

eccentricity_red=zeros(row,col); %store eccentricity values
for x=2:row+1
    for y=2:col+1
        central_moments02=0; %central moment02
        central_moments20=0; %central moment20
        central_moments11=0; %central moment11
        %Taking a 3x3 block and finding the central moments of each block
        %and then the eccentricity of each individual pixel.
        for l=x-1:x+1
            for m=y-1:y+1
                %central moment calculation
               central_moments11=double(central_moments11+(power((l-x_dash),1)*power((m-y_dash),1)*IM_R(l,m))); 
               %lamda=double((l+m)/2)+1;
               %normalized_central_moments(i,j)=double(normalized_central_moments(i,j)+(central_moments(i,j)/power(sum,lamda)));
               central_moments02=double(central_moments02+(power((m-y_dash),2)*IM_R(l,m)));
               central_moments20=double(central_moments20+(power((l-x_dash),2)*IM_R(l,m)));
            end
        end
        %theta=0.5*(atand(2*central_moments11/(central_moments20-central_moments02)));%atand is Inverse tangent in degrees
        %display(theta);
        eccentricity_red(x-1,y-1)=double((power((central_moments20-central_moments02),2)+(4*power(central_moments11,2)))/sum); %eccentricity calculation
        %display(eccentricity);
    end
end
display('Program completed!!! Excel writing in progress ');

indx=1; %index
linar=0; %linear
xcord=0; %x coordinate
ycord=0; %y coordinate
%Store eccentricity values in a linear array
for i=1:row
    for j=1:col
         linar(indx,1)=eccentricity_red(i,j); 
         xcord(indx,1)=i;
         ycord(indx,1)=j; 
         indx=indx+1;
    end
end
indx=indx-1;
 %Store the eccentricity, x coordinate and y coordinate in an excel file
stin=num2str(indx);
str=strcat('A1:A',stin);
xlswrite('eccentricity_red.xlsx',linar,str);
 
str=strcat('B1:B',stin);
xlswrite('eccentricity_red.xlsx',xcord,str);
 
str=strcat('C1:C',stin);
xlswrite('eccentricity_red.xlsx',ycord,str);

display('Red Completed!!!');

%**********************************************************************
%Green Component

%Adding and extra row and column on each side and filling it with zeros.
for i=2:row+1
    for j=2:col+1
        IM_G(i,j)=Green(i-1,j-1);
    end
end
%I=[1 0 1;1 1 1;0 0 1];
sum=0;
m11=0; %1st order moment
m10=0; %1st order moment
m01=0; %1st order moment
m20=0; %2nd order moment
m02=0; %2nd order moment
%Moment calculation for the whole image
for i=1:row+2
    for j=1:col+2
        sum=(sum+IM_G(i,j));
       % display(sum);
        m10=double(m10+(i*IM_G(i,j))); 
        m01=double(m01+(j*IM_G(i,j)));
        m00=sum; %0 order moment
        m11=double(m11+(i*j*IM_G(i,j)));
        m20=double(m20+(i*i*IM_G(i,j)));
        m02=double(m02+(j*j*IM_G(i,j)));
    end
end
xc=double(m10/sum); %X_c of centroid
yc=double(m01/sum); %Y_c of centroid
x_dash=double(m10/m00);
y_dash=double(m01/m00);
% display(xc);
% display(yc);
% display(x_dash);
% display(y_dash);

eccentricity_green=zeros(row,col); %store eccentricity values
for x=2:row+1
    for y=2:col+1
        central_moments02=0; %central moment02
        central_moments20=0; %central moment20
        central_moments11=0; %central moment11
        %Taking a 3x3 block and finding the central moments of each block
        %and then the eccentricity of each individual pixel.
        for l=x-1:x+1
            for m=y-1:y+1
                %central moment calculation
               central_moments11=double(central_moments11+(power((l-x_dash),1)*power((m-y_dash),1)*IM_G(l,m))); 
               %lamda=double((l+m)/2)+1;
               %normalized_central_moments(i,j)=double(normalized_central_moments(i,j)+(central_moments(i,j)/power(sum,lamda)));
               central_moments02=double(central_moments02+(power((m-y_dash),2)*IM_G(l,m)));
               central_moments20=double(central_moments20+(power((l-x_dash),2)*IM_G(l,m)));
            end
        end
        %theta=0.5*(atand(2*central_moments11/(central_moments20-central_moments02)));%atand is Inverse tangent in degrees
        %display(theta);
        eccentricity_green(x-1,y-1)=double((power((central_moments20-central_moments02),2)+(4*power(central_moments11,2)))/sum); %eccentricity calculation
        %display(eccentricity);
    end
end
display('Program completed!!! Excel writing in progress ');

indx=1; %index
linar=0; %linear
xcord=0; %x coordinate
ycord=0; %y coordinate
%Store eccentricity values in a linear array
for i=1:row
    for j=1:col
         linar(indx,1)=eccentricity_green(i,j); 
         xcord(indx,1)=i;
         ycord(indx,1)=j; 
         indx=indx+1;
    end
end
indx=indx-1;
 %Store the eccentricity, x coordinate and y coordinate in an excel file
stin=num2str(indx);
str=strcat('A1:A',stin);
xlswrite('eccentricity_green.xlsx',linar,str);
 
str=strcat('B1:B',stin);
xlswrite('eccentricity_green.xlsx',xcord,str);
 
str=strcat('C1:C',stin);
xlswrite('eccentricity_green.xlsx',ycord,str);

display('Green Completed!!!');

%*********************************************************************
%Blue Component

%Adding and extra row and column on each side and filling it with zeros.
for i=2:row+1
    for j=2:col+1
        IM_B(i,j)=Blue(i-1,j-1);
    end
end
%I=[1 0 1;1 1 1;0 0 1];
sum=0;
m11=0; %1st order moment
m10=0; %1st order moment
m01=0; %1st order moment
m20=0; %2nd order moment
m02=0; %2nd order moment
%Moment calculation for the whole image
for i=1:row+2
    for j=1:col+2
        sum=(sum+IM_B(i,j));
       % display(sum);
        m10=double(m10+(i*IM_B(i,j))); 
        m01=double(m01+(j*IM_B(i,j)));
        m00=sum; %0 order moment
        m11=double(m11+(i*j*IM_B(i,j)));
        m20=double(m20+(i*i*IM_B(i,j)));
        m02=double(m02+(j*j*IM_B(i,j)));
    end
end
xc=double(m10/sum); %X_c of centroid
yc=double(m01/sum); %Y_c of centroid
x_dash=double(m10/m00);
y_dash=double(m01/m00);
% display(xc);
% display(yc);
% display(x_dash);
% display(y_dash);

eccentricity_blue=zeros(row,col); %store eccentricity values
for x=2:row+1
    for y=2:col+1
        central_moments02=0; %central moment02
        central_moments20=0; %central moment20
        central_moments11=0; %central moment11
        %Taking a 3x3 block and finding the central moments of each block
        %and then the eccentricity of each individual pixel.
        for l=x-1:x+1
            for m=y-1:y+1
                %central moment calculation
               central_moments11=double(central_moments11+(power((l-x_dash),1)*power((m-y_dash),1)*IM_B(l,m))); 
               %lamda=double((l+m)/2)+1;
               %normalized_central_moments(i,j)=double(normalized_central_moments(i,j)+(central_moments(i,j)/power(sum,lamda)));
               central_moments02=double(central_moments02+(power((m-y_dash),2)*IM_B(l,m)));
               central_moments20=double(central_moments20+(power((l-x_dash),2)*IM_B(l,m)));
            end
        end
        %theta=0.5*(atand(2*central_moments11/(central_moments20-central_moments02)));%atand is Inverse tangent in degrees
        %display(theta);
        eccentricity_blue(x-1,y-1)=double((power((central_moments20-central_moments02),2)+(4*power(central_moments11,2)))/sum); %eccentricity calculation
        %display(eccentricity);
    end
end
display('Program completed!!! Excel writing in progress ');

indx=1; %index
linar=0; %linear
xcord=0; %x coordinate
ycord=0; %y coordinate
%Store eccentricity values in a linear array
for i=1:row
    for j=1:col
         linar(indx,1)=eccentricity_blue(i,j); 
         xcord(indx,1)=i;
         ycord(indx,1)=j; 
         indx=indx+1;
    end
end
indx=indx-1;
 %Store the eccentricity, x coordinate and y coordinate in an excel file
stin=num2str(indx);
str=strcat('A1:A',stin);
xlswrite('eccentricity_blue.xlsx',linar,str);
 
str=strcat('B1:B',stin);
xlswrite('eccentricity_blue.xlsx',xcord,str);
 
str=strcat('C1:C',stin);
xlswrite('eccentricity_blue.xlsx',ycord,str);

display('Blue Completed!!!');
