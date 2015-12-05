function [delaycost, proxy_b] = approach03(occur_t, handover_t, sim_t, m_a, a_b, ab_p, content_num)
%% initialize

m_b=m_a
point_t=ab_p:ab_p:content_num*ab_p
count_up=0
for index_up=1:size(point_t, 2)
    if point_t(index_up)<occur_t
        count_up=count_up+1;
    else
         index_up=index_up-1;
        break;
    end
end

%% capture the handover

handover_finish=occur_t+handover_t
count_down=0
count_middle=0
for index_down=1:size(point_t, 2)
    if point_t(index_down)<=handover_finish
        count_down=count_down+1;
    else
         index_down=index_down-1;
        break;
    end
end
count_middle=count_down-count_up
temp=occur_t:handover_finish
count_middle_temp=0
for i=1:ab_p:size(temp, 2)
    if temp(i)<=handover_finish
        count_middle_temp=count_middle_temp+1;
    end
end
if count_middle_temp>(content_num-count_down)
    count_middle_temp=content_num-count_down
end

%% calculate the corresponding costs

if occur_t<=ab_p
    index_up=1
end
if  ((occur_t-point_t(index_up))<m_b)   &&  ( (occur_t-point_t(index_up) )>0 )
    count_middle=count_middle+1
    delaycost=(content_num-count_down-count_middle_temp)*ab_p+(count_middle+count_middle_temp)*m_b
    proxy_b=count_middle+count_middle_temp
else
    delaycost=(content_num-count_down-count_middle_temp)*ab_p+(count_middle+count_middle_temp)*m_b
    proxy_b=count_middle+count_middle_temp
end
if (handover_t==0)
   delaycost=(content_num-count_down)*ab_p+(content_num-count_down+count_middle)*m_b+ count_middle*a_b
   proxy_b=count_middle
   
   
end






















