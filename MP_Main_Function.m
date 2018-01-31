clear
clc
Cover_Image=imread('cover.jpg');
Secret_Message=fileread('secretmessage.txt');
[row_size_cover,column_size_cover]= size(Cover_Image(:,:,3));
Size_Checker= 1; %For checkin the values which are selected by user

while(Size_Checker==1)
    
    Block_size=input('Enter a poitive integer number as a Block Size:\n');% Block_size = 64 is recommended 
    while(fix(Block_size)-Block_size~=0 || Block_size<1)
        display('Warning: Block Size should be a positive integere.');
        Block_size=input('Enter a positive integer number as a Block Size (Block_size = 64 is recommended):\n');
    end
    
    while(floor(row_size_cover/2)<Block_size && floor(column_size_cover/2)<Block_size)
        display('Warning: Selected Block Size is not suitable based on size of Cover Image. Select a smaller Block Size');
        Block_size=input('Enter a positive integer number as a Block Size (Block_size = 64 is recommended):\n');
    end
    
    MP_size_row=input('Enter the Matrix Pattern Row Size:\n');% MP_size_row = 3 is recommended 

    while(fix(MP_size_row)-MP_size_row~=0 || MP_size_row<1)
        display('Warning: Selected input should be a positive integere.');
        MP_size_row=input('Enter a positive integer number as a Matrix Pattern Row size (3 is recommended):\n');
    end

    MP_size_column=input('Enter the Matrix Pattern column Size:\n');% MP_size_column = 2 is recommended 

    while(fix(MP_size_column)-MP_size_column~=0 || MP_size_column<1)
        display('Warning: Selected input should be a positive integere.');
        MP_size_column=input('Enter a positive integer number as a Matrix Pattern column size (2 is recommended):\n');
    end

    Size_Checker=0;

    if((Block_size-MP_size_row+1)*(Block_size-MP_size_column+1)<95 || MP_size_row>Block_size|| MP_size_column>Block_size ||(MP_size_row-1)*(MP_size_column)<3)
        Size_Checker=1;
        display('Warning: Selected sizes are not suitable, Please follow the instruction:');
        display('1) Block size value should be greater than Row and Column sizes');
        display('2) Generating 95 unique Matrix Pattern Based on selected Block size and Matrix Pattern sizes is impossible\n')
        display('Please enter new values');
    end
end


Block_size_orderblocks=64;
MP_size_row_orderblocks=3;
MP_size_column_orderblock=2;
Str_Block_size = num2str(Block_size);
Str_MP_size_row = num2str(MP_size_row);
Str_MP_size_column = num2str(MP_size_column);
Block_size_orderblock=64;
temp_Cover_Image=Cover_Image;
[ww, hh]=Preprocessing_algorithm(Cover_Image,Block_size);
[HH,WW]=size(Cover_Image(:,:,3));
nw=fix(WW/Block_size);
text1=[];
w=[];
h=[];
ww1=[];
hh1=[];
area11=[];
area12=[];
area21=[];
area22=[];
ob=0;
text1=Str_Block_size;
text1=[text1 ']'];
text1=[text1 Str_MP_size_row];
text1=[text1 ']'];
text1=[text1 Str_MP_size_column];
text1_temp=text1;

img_t=Cover_Image;
b_first=img_t(:,:,3);
b1_first=img_t(:,:,3);
img_g=img_t(:,:,2);

[hh_init,ww_init]=size(b_first);

%nh_initial=fix(hh_init/Block_size);
%nw_initial=fix(ww_init/Block_size);

nh_initial=fix(hh_init/Block_size_orderblock);
nw_initial=fix(ww_init/Block_size_orderblock);

hh_initial=[];
ww_initial=[];

for i=1:nh_initial
    for j=1:nw_initial
        hh_initial=[hh_initial i];
        ww_initial=[ww_initial j];
    end
end

for i=1:length(hh)
    text1=[text1 ']'];
    block = nw*(hh(i)-1)+ww(i);  
    text1 =[text1 num2str(block)];
end
text1=[text1 ']'];

blo_num_first=1;

c_b=1; % counter_block
if(isempty(ww)==1)% in this case the valuses that certain the correspondence of the other blocks could not be hidden in the image 
    fprintf('Warning: No message can be hidden in this image. Please change the cover image\n');
else
    while (~isempty(text1) || c_b==0 )
    img=b_first((hh_initial(blo_num_first)-1)*Block_size_orderblocks+1:(hh_initial(blo_num_first)-1)*Block_size_orderblocks+Block_size_orderblocks,(ww_initial(blo_num_first)-1)*Block_size_orderblocks+1:(ww_initial(blo_num_first)-1)*Block_size_orderblocks+Block_size_orderblocks);
    img_g1=img_g((hh_initial(blo_num_first)-1)*Block_size_orderblocks+1:(hh_initial(blo_num_first)-1)*Block_size_orderblocks+Block_size_orderblocks,(ww_initial(blo_num_first)-1)*Block_size_orderblocks+1:(ww_initial(blo_num_first)-1)*Block_size_orderblocks+Block_size_orderblocks);
    [ch1, n]=MP_Generation_for_orderblocks(img_g1);
  
    if (n~=0)
         [img, text1, c_b]=Embedding_orderblocks(ch1,text1,img);
         area11=[area11 (hh_initial(blo_num_first)-1)*Block_size_orderblocks+1];% the location of the beginning row
         area21=[area21 (hh_initial(blo_num_first)-1)*Block_size_orderblocks+Block_size_orderblocks];% the location of the end row
         area12=[area12 (ww_initial(blo_num_first)-1)*Block_size_orderblocks+1]; % the beginning of the first column
         area22=[area22 (ww_initial(blo_num_first)-1)*Block_size_orderblocks+Block_size_orderblocks]; % the location of the end column      
         hh1=[hh1 hh_initial(blo_num_first)]; % if b_s and Block_size_orderblocks become equal we need this value for knowing the location of a block that hidden the thr an del
         ww1=[ww1 ww_initial(blo_num_first)];
         s=img_t((hh_initial(blo_num_first)-1)*Block_size_orderblocks+1:(hh_initial(blo_num_first)-1)*Block_size_orderblocks+Block_size_orderblocks,(ww_initial(blo_num_first)-1)*Block_size_orderblocks+1:(ww_initial(blo_num_first)-1)*Block_size_orderblocks+Block_size_orderblocks,1:2);
         s(:,:,3)=img;
    end
    b1_first((hh_initial(blo_num_first)-1)*Block_size_orderblocks+1:(hh_initial(blo_num_first)-1)*Block_size_orderblocks+Block_size_orderblocks,(ww_initial(blo_num_first)-1)*Block_size_orderblocks+1:(ww_initial(blo_num_first)-1)*Block_size_orderblocks+Block_size_orderblocks)=img;
    blo_num_first=blo_num_first+1;
    end
Cover_Image(:,:,3)=b1_first;
if Block_size==Block_size_orderblocks
    for i=1:length(ww)
        flag=0;
        for j=1:length(ww1)
            if(ww(i)==ww1(j)&& hh1(j)==hh(i))
                flag=1;
                ob=ob+1; %overlap blocks between real "thr" and "del" with "200" and "50" for hidding the "thr" and "del".
                break;
            end
        end
        if(flag==0)
            w=[w ww(i)];
            h=[h hh(i)];
        end
    end
else
    [w, h]= Eliminating_blocks_with_overlap_by_orderblocks(Cover_Image,Block_size,Block_size,Block_size_orderblocks,area11,area21,area12,area22);
end

for i=1:length(h)
    text1_temp=[text1_temp ']'];
    block = nw*(h(i)-1)+w(i);  
    text1_temp =[text1_temp num2str(block)];
end
text1_temp=[text1_temp ']'];

blo_num_first=1;

c_b=1; % counter_block
if(isempty(w)==1)% in this case the valuses that certain the correspondence of the other blocks could not be hidden in the image 
    fprintf('Warning: No message can be hidden in this image. Please change the cover image\n');
else
    while (~isempty(text1_temp) || c_b==0 )
    img=b_first((hh_initial(blo_num_first)-1)*Block_size_orderblocks+1:(hh_initial(blo_num_first)-1)*Block_size_orderblocks+Block_size_orderblocks,(ww_initial(blo_num_first)-1)*Block_size_orderblocks+1:(ww_initial(blo_num_first)-1)*Block_size_orderblocks+Block_size_orderblocks);
    img_g1=img_g((hh_initial(blo_num_first)-1)*Block_size_orderblocks+1:(hh_initial(blo_num_first)-1)*Block_size_orderblocks+Block_size_orderblocks,(ww_initial(blo_num_first)-1)*Block_size_orderblocks+1:(ww_initial(blo_num_first)-1)*Block_size_orderblocks+Block_size_orderblocks);
    [ch1, n]=MP_Generation_for_orderblocks(img_g1);
  
    if (n~=0)
         [img, text1_temp, c_b]=Embedding_orderblocks(ch1,text1_temp,img);
         s=img_t((hh_initial(blo_num_first)-1)*Block_size_orderblocks+1:(hh_initial(blo_num_first)-1)*Block_size_orderblocks+Block_size_orderblocks,(ww_initial(blo_num_first)-1)*Block_size_orderblocks+1:(ww_initial(blo_num_first)-1)*Block_size_orderblocks+Block_size_orderblocks,1:2);
         s(:,:,3)=img;
    end
    b1_first((hh_initial(blo_num_first)-1)*Block_size_orderblocks+1:(hh_initial(blo_num_first)-1)*Block_size_orderblocks+Block_size_orderblocks,(ww_initial(blo_num_first)-1)*Block_size_orderblocks+1:(ww_initial(blo_num_first)-1)*Block_size_orderblocks+Block_size_orderblocks)=img;
    blo_num_first=blo_num_first+1;
    end
end
Cover_Image(:,:,3)=b1_first;

text=Secret_Message;
ltxt=length(text);
img_t=Cover_Image;
b=img_t(:,:,3);
b1=img_t(:,:,3);
blo_num=1;
c_b=1;
useful_block=0;
test_work=0;

capacity=length(w); % number of blocks chosen for hidding
while ((~isempty(text) || c_b==0)&& blo_num ~=capacity+1 )
    test_work=test_work+1
   % if (test_work==56)
    %    display('Test');
    %end
    img=b((h(blo_num)-1)*Block_size+1:(h(blo_num)-1)*Block_size+Block_size,(w(blo_num)-1)*Block_size+1:(w(blo_num)-1)*Block_size+Block_size);
    img_g2=img_g((h(blo_num)-1)*Block_size+1:(h(blo_num)-1)*Block_size+Block_size,(w(blo_num)-1)*Block_size+1:(w(blo_num)-1)*Block_size+Block_size);
   [ch1, n]=MP_Generation(img_g2,MP_size_row,MP_size_column);
    
   if (n~=0) 
        useful_block=useful_block+1;
        [img, text, c_b]=Embedding(ch1,text,img,MP_size_row,MP_size_column);
        s=Cover_Image((h(blo_num)-1)*Block_size+1:(h(blo_num)-1)*Block_size+Block_size,(w(blo_num)-1)*Block_size+1:(w(blo_num)-1)*Block_size+Block_size,1:2);
        s(:,:,3)=img;
    end
    b1((h(blo_num)-1)*Block_size+1:(h(blo_num)-1)*Block_size+Block_size,(w(blo_num)-1)*Block_size+1:(w(blo_num)-1)*Block_size+Block_size)=img;
    blo_num=blo_num+1;
end

if  ~isempty(text)
     numb_of_hidd_char=ltxt-length(text);
     if numb_of_hidd_char==0 % in this case no character could be hidden in the cover image with selected valuse
         fprintf('Warning: No character is hidden in the selected image and sizes\n');
     else
         fprintf('Warning: There is not enough capacity for hiding whole text message\n');
         disp(['The number of hidden character is : ',num2str(numb_of_hidd_char)])
     end
    
else
    disp(['Whole characters are hidden, the number of hidden character is : ',num2str(ltxt)])
end

useful_block   
Stego_image=Cover_Image;
Stego_image(:,:,3)=b1;
imwrite(Stego_image,'Stego_Image.png');
folder='C:\Users\amirf\Desktop\desktop2\Desktop\adaptive_MP\Final_Code_and_Results of adaptive MP\GitHub Version_adaptiv_MP3_96char_4rd_5th_less_than_24\Final GitHub\Extracting Phase';
imwrite(Stego_image,fullfile(folder, 'Stego_Image.png'));
end
