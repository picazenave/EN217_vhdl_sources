clc
close all
clear



i=2;
nb=1;

cnt=1;


while(nb<1200)
    clk=1;
    prime=true;
    while(i*i<nb)
        if(mod(nb,i)==0)
            prime=false;
            break;
        end
        i=i+1;
        clk=clk+1;
    end
    if prime
        fprintf("%d est prime\n",nb)
        clk=clk+17;
        clk=clk*12+5+7;%nombre d'instructions * boucle + statique pour chaque init
        clk_count(cnt,1)=clk;
        clk_count(cnt,2)=nb;
        cnt=cnt+1;
    end
    nb=nb+1;
    i=2;
    
end
plot(clk_count(:,2),clk_count(:,1))
%hist(clk_count(:,1))

