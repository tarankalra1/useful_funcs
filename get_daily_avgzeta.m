
t_final=length(zeta2);

    zeta_max= -10^10  ;
    zeta_min=  10^10 ;
for t=1:t_final
   count_24=mod(t,24)
   zeta_max=max(zeta2(t), zeta_max);
   zeta_min=min(zeta2(t), zeta_min);
   if (count_24==0)
     count=count+1   ;     % add counter after 24 hour
     zeta_max_daily(count)=zeta_max;
     zeta_min_daily(count)=zeta_min ;


    zeta_max= -10^10  ;
    zeta_min=  10^10 ;
   end
 end

for i=1:(count)
  mtr_daily(i)=zeta_max_daily(i)-zeta_min_daily(i);
end
mtr_avg=sum(mtr_daily)/(count);
~                                    
