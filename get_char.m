function [txt]=get_char(charac,img,t,t_c)
if nargin==2
t=3;
t_c=3;
end
%h=n+1;w=1;
h=1;w=1;
[hh,ww]=size(img);
z=zeros(t,t_c);
t_test='aa';
txt='';

%ch_num=floor((hh-(n*t))/t)*floor(ww/t_c);
ch_num=floor(hh/t)*floor(ww/t_c);
num=ch_num;

    while (num~=0)
        
        im=img((h-1)*t+1:(h-1)*t+t,(w-1)*t_c+1:(w-1)*t_c+t_c);

        test1=im;
        test1=reshape(test1,1,t*t_c);
        test1=dec2bin(test1,8);
        for j=1:t*t_c, test1(j,6:end)='0';end
        test1=bin2dec(test1);
        test1=reshape(test1,t,t_c);
        for i=2:t
            for j=1:t_c
                mat(i,j)=int16(test1(i,j)-test1(i-1,j));
            end
        end
        if(mat==z)
        else
      %  if(mat==charac(1).mat),     break;  end
        if(mat==charac(1).mat) 
            txt=[txt '***eof***'];   break;  
        end
        
        for j=2:length(charac)
            if (charac(j).mat==mat)
                txt=[txt charac(j).ch];
                 t_test(1)=t_test(2);
                 t_test(2)=charac(j).ch;
              %  if (t_test== 'qr')
               %    t_test
                %end
                break;
            end
        end
        end

        w=w+1;
        num=num-1;

        if w*t_c>ww
            w=1;h=h+1;
        end
    end

end