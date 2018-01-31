Stego_Image=imread('Stego_Image.png');
Block_size_orderblocks=64;
h1=[];
w1=[];
ob=0;
ww1=[];
hh1=[];
w=[];
h=[];
text='         ';
b_s1='';
mp_s1='';
mp_s_c1='';
area11=[];
area12=[];
area21=[];
area22=[];
flag=0;

im_g=Stego_Image(:,:,2);
b=Stego_Image(:,:,3);


[hh_init,ww_init]=size(b);

nh_initial=fix(hh_init/Block_size_orderblocks);
nw_initial=fix(ww_init/Block_size_orderblocks);

for i=1:nh_initial
    for j=1:nw_initial
        h1=[h1 i];
        w1=[w1 j];
    end
end


for blo_num=1:length(w1)
    img=b((h1(blo_num)-1)*Block_size_orderblocks+1:(h1(blo_num)-1)*Block_size_orderblocks+Block_size_orderblocks,(w1(blo_num)-1)*Block_size_orderblocks+1:(w1(blo_num)-1)*Block_size_orderblocks+Block_size_orderblocks);
    img_g=im_g((h1(blo_num)-1)*Block_size_orderblocks+1:(h1(blo_num)-1)*Block_size_orderblocks+Block_size_orderblocks,(w1(blo_num)-1)*Block_size_orderblocks+1:(w1(blo_num)-1)*Block_size_orderblocks+Block_size_orderblocks);
    [ch1 n]=set_char_sequence_block(img_g); 
   if (n~=0)  
        [txt]=detect_initial(ch1,img);
        text=[text txt];
        ww1=[ww1 w1(blo_num)];
        hh1=[hh1 h1(blo_num)];
        area11=[area11 (h1(blo_num)-1)*Block_size_orderblocks+1]% the location of the beginning row
        area21=[area21 (h1(blo_num)-1)*Block_size_orderblocks+Block_size_orderblocks]% the location of the end row
        area12=[area12 (w1(blo_num)-1)*Block_size_orderblocks+1] % the beginning of the first column
        area22=[area22 (w1(blo_num)-1)*Block_size_orderblocks + Block_size_orderblocks] % the location of the end column
   end
     
    
    if(strcmp(text((end-8):end),'***eof***')),  text((end-8):end)='';text(1:9)='';
        break;      
    end
    
end

t_text=[];
MP_queue=[];
Count=0;
   L_text=length(text);
   for i=1:L_text
       t_text=[t_text text(i)];
       if t_text(end)== ']'
           Count=Count+1;
           if Count==1
               b_s1=t_text(1:(end-1));
               b_s=str2num(b_s1);
               t_text='';
           elseif Count==2
               mp_s1=t_text(1:(end-1));
               mp_s=str2num(mp_s1);
                 t_text='';
           elseif Count==3
               mp_s_c1=t_text(1:(end-1));
              mp_s_c=str2num(mp_s_c1);
                 t_text='';
           else
                t_MP_queue=str2num(t_text(1:(end-1)));
                MP_queue=[MP_queue t_MP_queue];
                 t_text='';              
           end
       end
   end
   
   
   
text='         ';
b=Stego_Image(:,:,3);

[hh_real,ww_real]=size(b);

nw_real=fix(ww_real/b_s);
h_mp_queue=[];
w_mp_queue=[];

for i=1:length(MP_queue)
   h_mp_q= (fix((MP_queue(i)-1)/nw_real))+1;
   if rem(MP_queue(i),nw_real)~=0
   w_mp_q=(rem(MP_queue(i),nw_real)-1)+1;
   else
       w_mp_q=(nw_real-1) +1;
   end
   
  h_mp_queue=[h_mp_queue h_mp_q];
  w_mp_queue=[w_mp_queue w_mp_q];    
end
h=h_mp_queue;
w=w_mp_queue;




for blo_num=1:length(w)
    img=b((h(blo_num)-1)*b_s+1:(h(blo_num)-1)*b_s+b_s,(w(blo_num)-1)*b_s+1:(w(blo_num)-1)*b_s+b_s);
    img_g4=im_g((h(blo_num)-1)*b_s+1:(h(blo_num)-1)*b_s+b_s,(w(blo_num)-1)*b_s+1:(w(blo_num)-1)*b_s+b_s);
    [ch1 n]=set_char(img_g4,mp_s,mp_s_c);

    if (n~=0)
        [txt]=get_char(ch1,img,mp_s,mp_s_c);
        text=[text txt];  
       
    end
    
    if(strcmp(text((end-8):end),'***eof***'))
        text((end-8):end)='';
        break;  
    end
    
end
text(1:9)='';
fid=fopen('Extracted_Secret_Message.txt','wt');
%fprintf(fid, [ text '\n']);
fprintf(fid, '%s', text)
fclose(fid);
num_detect=length(text);
num_detect
text