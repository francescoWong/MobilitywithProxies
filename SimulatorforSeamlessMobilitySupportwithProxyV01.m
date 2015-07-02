% Copyright (c) 2015 State Key Laboratory of Networking and Switching Technology, Beijing University of Posts and Telecommunications, Beijing, China
% Address: P.O. Box 206, No.10, Xi Tu Cheng Road, Haidian District, Beijing 100876, China. 
% Author: Haoqiu Huang (francesco@bupt.edu.cn) and Weiwei Zheng (zhengweiwei@bupt.edu.cn) 

%%%%%%%%% only a simple visualization MATLAB simulator for Testing !!!!  
%%%%%%%%% supporting the case of n-level proxies. A group consisting of 4
%%%%%%%%% proxies!!!  Random Topology independent of Connecting!

clear; clc;clf
X=rand(4,4)*10;
Y=rand(4,4);
S=[12,1];
X2=rand(1,4)*10;
Y2=rand(1,4);
X3=rand(1,1)*10;
Y3=rand(1,1)*10;
scatter(S(1),S(2), 100, 'ko','LineWidth',1.5,'MarkerEdgeColor','b','MarkerFaceColor','b');
figure(1)
proxiesIndex=1;
while proxiesIndex<=( size(X,2)*size(Y,2) )
    hold on 
    scatter(X(proxiesIndex),Y(proxiesIndex), 60, 'ko','LineWidth',1.5);
    proxiesIndex=proxiesIndex+1;
end
hold on 
proxiesIndex=1;
while proxiesIndex<=( size(X2,2) )
    hold on 
    scatter(X2(proxiesIndex),Y2(proxiesIndex), 80, 'ko','LineWidth',1.5,'MarkerEdgeColor','g');
    proxiesIndex=proxiesIndex+1;
end
box on
clear proxiesIndex
velocity=10000; 
%any curve for mobiles is available!!!
x=0:4*pi/velocity:4*pi;
y=( sin(x)+1) * 0.5;
plot(x, y, 'w')
axis([0, 4*pi, 0, 1.2])
h=line('color', 'black', 'marker', '.', 'markersize', 20, 'erasemode', 'xor');
currentLocal=1;
tempIndex=[];
optimalNum2=[];
tempP=0;
tempPP=[];
Dsource=0;
Dsubset=0;
DMidsubset=0;
DTopsubset=0;
%adjusting available!!!!!
cCache=1;
cCacheMid=4; 
cCacheTop=30;
% cCache=2;
% cCache=20;
% cCacheMid=2;
% cCacheMid=10;
% cCacheMid=20;
% cCacheMid=200;
% cCacheTop=30;
% cCacheTop=40;
% cCacheTop=50;
% cCacheTop=200;
%adjusting available!!!!!
pik={0.5,0.25,0.15,0.1};
% pik={0.4,0.3,0.2,0.1}
% pik={0.25,0.25,0.25,0.25}
% pik={0.5,0.25,0.15,0.10}
num=0;
indexI=1;
indexJ=1;
indexK=1;
indexL=1;
label=1;
while 1
    if 0==mod(currentLocal,1000)   
        if ~isempty(tempIndex)
            for  i=1:1:num
                scatter( X( tempIndex(i) ),Y( tempIndex(i) ),60,'ko','erasemode', 'xor','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 1 1],'LineWidth',1.5);
            end
            num=0;
        end
        for proxiesIndex=1:1:16
            dist(proxiesIndex) = sqrt( (X(proxiesIndex)-x(currentLocal))^2+(Y(proxiesIndex)-y(currentLocal))^2 );
        end      
        for proxiesIndex=1:1:4
            dist2(proxiesIndex) = sqrt( (X2(proxiesIndex)-x(currentLocal))^2+(Y2(proxiesIndex)-y(currentLocal))^2 );
        end
        [dist_sort,ind]=sort(dist,'descend');
        Tempstart=dist([ind(end-(4-1):end)]);
        [dist_sort,ind]=sort(dist2,'descend');
        Tempstart2=dist2([ind(end:end)]);
        DMidsubset(indexJ)=Tempstart2;
        for k=1:1:4
            Dsubset(k)=Tempstart(k);
        end
        fullCachingCost(indexJ)=sum((sum(Tempstart))')+4*cCache;    
        Dsource=sqrt( ( S(1)-x(currentLocal) )^2+( S(2)-y(currentLocal) )^2 );
        for i=1:1:4
            if Dsource>Dsubset(i)
                 P= ( cCache/Dsubset(i) ) / ( ( Dsource/Dsubset(i) )-1 );                
                 if pik{i}>P
                       num=num+1;
                 end
                numTemp=num;   
                if num>=1
                    [dist_sort,ind]=sort(dist,'descend');
                    Sstart=dist([ind(end-(num-1):end)]);                                  
                    selectedIndex=1;
                    for  proxiesIndex=1:1:16
                        for  selectedIndex=1:1:num
                              if Sstart(selectedIndex)==sqrt( (X(proxiesIndex)-x(currentLocal))^2+(Y(proxiesIndex)-y(currentLocal))^2 )
                                   scatter(X(proxiesIndex),Y(proxiesIndex),60,'ko','erasemode', 'xor','MarkerEdgeColor',[1 0 0],'MarkerFaceColor',[1 0 0],'LineWidth',1.5);
                                   tempIndex(selectedIndex)=proxiesIndex;
                              end
                        end
                    end                   
                end                
            end      
        end
         for i=1:1:4
            if Dsource>Dsubset(i)
                P= ( cCache/Dsubset(i) ) / ( ( Dsource/Dsubset(i) )-1 ); 
                tempP=tempP+P;
            end
         end
        tempPP(indexL)=tempP;
        indexL=indexL+1;
        L(indexI)=x(currentLocal);
        CM(indexI)=4*Dsource+4*cCache;
         if numTemp==1
             CH(indexI)=Sstart(1)*pik{1}+3*(1-pik{1})*Dsource+numTemp*cCache;
         end
         if numTemp==2
            CH(indexI)=Sstart(1)*pik{1}+Sstart(2)*pik{2}+2*( 1-pik{2}-pik{1} )*Dsource+numTemp*cCache;
         end
         if numTemp==3
            CH(indexI)=Sstart(1)*pik{1}+Sstart(2)*pik{2}+Sstart(3)*pik{3}+1*(1-pik{1}-pik{2}-pik{3})*Dsource+numTemp*cCache;
         end
        if numTemp==4
            CH(indexI)=Sstart(1)*pik{1}+Sstart(2)*pik{2}+Sstart(3)*pik{3}+Sstart(4)*pik{4}+numTemp*cCache;
        end       
        if size(CH,2)==indexI       
           if CH(indexI)> ( DMidsubset(indexJ)+cCacheMid )
                disp('2-Layer Response!!!')
                disp(L(indexI))
               CH2(indexI)=DMidsubset(indexJ)+cCacheMid;
               optimalNum2(indexI)=1;
               optimalNum(indexI)=0;
               label=0;               
              for proxiesIndex=1:1:4
                distTemp(proxiesIndex) = sqrt( (X2(proxiesIndex)-x(currentLocal))^2+(Y2(proxiesIndex)-y(currentLocal))^2 );
             end
                [dist_sort,ind]=sort(distTemp,'descend');
                tempStart2=distTemp([ind(end:end)]);            
             for  proxiesIndex=1:1:4
                    if tempStart2==sqrt( (X2(proxiesIndex)-x(currentLocal))^2+(Y2(proxiesIndex)-y(currentLocal))^2 )
                            scatter(X2(proxiesIndex),Y2(proxiesIndex),80,'ko','erasemode', 'xor','MarkerEdgeColor',[0 1 0],'MarkerFaceColor',[0 1 0],'LineWidth',1.5);    
                            tempIndex2(proxiesIndex)=proxiesIndex; 
                           if ~isempty(tempIndex)
                                   for  i=1:1:num
                                         scatter( X( tempIndex(i) ),Y( tempIndex(i) ),60,'ko','erasemode', 'xor','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 1 1],'LineWidth',1.5);
                                   end
                                   num=0;
                           end                  
                    end
             end                 
           end  
        end
        if  label==0
            optimalNum(indexI)=0;
            label=1;
        else
            optimalNum(indexI)=numTemp;
        end          
        indexI=indexI+1;   
        indexJ=indexJ+1;            
    end 
    set(h,'xdata', x(currentLocal),'ydata', y(currentLocal));
    drawnow;
    currentLocal=currentLocal+1;
    if currentLocal>size(x, 2)
         for  i=1:1:num
                scatter( X( tempIndex(i) ),Y( tempIndex(i) ), 60, 'ko','erasemode', 'xor','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 1 1],'LineWidth',1.5);
         end
        break
    end
end
totalCH=sum((sum(CH))');
totalCM=sum((sum(CM))');

figure(2)
for i=size(CH,2):1:size(CM,2)
    CH(i)=0;
    fullCachingCost(i)=0;
end
totalFullCachingCost=sum((sum(fullCachingCost))');
plot(L,CM)
hold on
plot(L,fullCachingCost)
hold on
plot(L,CH)
hold on
legend( 'No Caching at Level 1','Full Caching at Level 1','CMLP at Level 1');
ylabel('Total Cost');
xlabel('Distance (m)')
set(gcf,'color','white')

figure(3)
bar(optimalNum,1);
axis([0 13 0 5]);
set(gca,'YTick',0:1:5);
legend('ONSP at Level 1');
xlabel('Distance (m)');
ylabel('Number of Proxies');
set(gca,'ygrid','on')
set(gca,'XTickLabel',{L(1),L(2),L(3),L(4),L(5),L(6),L(7),L(8),L(9),L(10)});
set(gca,'YTickLabel',{'0','1','2','3','4','5'})
set(gcf,'color','white')
if ~isempty(tempPP)
        figure(4)
        plot(L,tempPP)
        hold on
        box on
        legend(' T_{P} ');
        ylabel('Right-hand Side of Eq.(2)');
        xlabel('Distance (m)')
        set(gcf,'color','white')
end

figure(5)
for i=size(CH,2):1:size(CM,2)
    CH(i)=0;
    fullCachingCost(i)=0;
end
totalFullCachingCost=sum((sum(fullCachingCost))');
plot(L,CM)
hold on
plot(L,fullCachingCost)
hold on
plot(L,CH)
hold on

for i=size(CH,2):1:size(CM,2)
    CH2(i)=0;
end
for i=1:1:size(CM,2)
    if CH2(i)==0
        CH2(i)=CH(i)
    end
end
totalCH2=sum((sum(CH2))');
plot(L,CH2)
hold on
legend( 'No Caching at Level 1','Full Caching at Level 1','CMLP at Level 1','CMLP at Level 2');
ylabel('Total Cost');
xlabel('Distance (m)')
set(gcf,'color','white')
if ~isempty(optimalNum2)   
        figure(6)
        if size(optimalNum,2)>=size(optimalNum2,2)
            for i=size(optimalNum2,2)+1:1:size(optimalNum,2)
                optimalNum2(i)=0;
            end
        end
        dataT=zeros(10,2);
        for j=1:1:2
            if j==1
                for i=1:1:size(dataT,1)
                    dataT(i,j)=optimalNum(i);
                end
            end
            if j==2
                 for i=1:1:size(dataT,1)
                    dataT(i,j)=optimalNum2(i);
                end
            end
        end
        bar(dataT,1);
        hold on 
        axis([0 13 0 5]);
        set(gca,'YTick',0:1:5);
        legend('ONSP at Level 1','ONSP at Level 2');
        xlabel('Distance (m)');
        ylabel('Number of Proxies');
        set(gca,'ygrid','on')
        set(gca,'XTickLabel',{L(1),L(2),L(3),L(4),L(5),L(6),L(7),L(8),L(9),L(10)});
        set(gca,'YTickLabel',{'0','1','2','3','4','5'})
        set(gcf,'color','white')
end

if ~isempty(optimalNum2)
    figure(7)
    data = [totalCM 0 0 0;0 totalFullCachingCost 0 0; 0 0 totalCH 0;0 0 0 totalCH2];
    bar(data,1);
    axis([0 6 0.0 400]);
    legend('No Caching','Full Caching','CMLP at Level 1','CMLP at Level 2');
    ylabel('Total Cost');
    set(gca,'ygrid','on')
    set(gca,'XTickLabel',{'No Caching','Full Caching','CMLP at Level 1','CMLP at Level 2'});
    set(gcf,'color','white')
end


%%%%end!!












