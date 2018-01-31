%choose pattern for the block 
%function [charac2 ch valid]=set_char_del_thr_block_size(img,t)
function [charac2, ch]=set_char_sequence_block(img,t)
if nargin==1, t=3; t_c=2; end
%valid=1;
load charac2;
[hh,ww]=size(img);
z=zeros(t,t_c);

cha=1;
ch=1;
cw=1;
c1=0;
%flag=0;

while cha~=(length(charac2)+1)
   % if cha==44
    %    disp('hi');
    %end
    %im =img((ch-1)*t+1:(ch-1)*t+t,cw:cw+t_c-1);
    im =img(ch:ch+t-1,cw:cw+t_c-1);
    test1=im;
    test1=reshape(test1,1,t*t_c);
    test1=dec2bin(test1,8);
    for j=1:t*t_c, test1(j,6:end)='0';end
    
    test1=bin2dec(test1);
    test1=reshape(test1,t,t_c);
    
    for i=2:t
        for j=1:t_c
            test(i,j)=int16(test1(i,j)-test1(i-1,j));
            if (abs( test(i,j))>24)
                c1=1;
            end
        end
    end
    if(test==z)
            c1=1;
    else
    for i=1:cha-1
        test2=charac2(i).mat;
        if(test2==test), c1=1;break;end
    end
    end

    if c1==0
        charac2(cha).mat =test;
        cha=cha+1;
    end
    c1=0;
    %flag=0;
    
    cw=cw+1;
    if cw+t_c-1>ww
        cw=1;ch=ch+1;
    end

    if ((ch+t-1) > hh), ch=0;return; end
    
end  
end