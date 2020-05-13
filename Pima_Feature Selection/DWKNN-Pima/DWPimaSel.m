% K-Nearest Neighbor
% Done by Maryam Hosseinkord
% Date: 20/12/2013

function[Mean,Result]= DWKNN(Existinglist)

%Existinglist=[1 1 1 1 1 1 1 1 1];
AttributeCount=sum(Existinglist);
ind = find(Existinglist);
 
K=5;
load pima.dat
[m,n] = size(pima);


% Dataset re-arrangement
Vect =  randperm(768);%load('test vector.txt');
DataSet = zeros(m,n);
for i=1:m
    DataSet(i,:)=pima(Vect(i),:);
    
end

DataSet=DataSet(:,ind);

% 10 fold cross validation
Part= 77;

for i=1:10 %run
tic

    FP=0;
    FN=0;
    TP=0;
    TN=0;
    
    TrainSet = DataSet;
    if i==10
        TestSet= DataSet(692:768, :);
    else
        TestSet = DataSet(Part*(i-1)+1 :Part*i, :);
    end
    TestInput = TestSet(:,1:AttributeCount-1);
    TestTarget = TestSet(:,AttributeCount);
    
    if i==10
        TrainSet(692 :768, :)=[];
    else
        TrainSet(Part*(i-1)+1 :Part*i, :)=[];
    end
    
    TrainInput = TrainSet(:,1:AttributeCount-1);
    TrainTarget = TrainSet(:,AttributeCount);
    
    for j= 1:77 
        
          for z= 1: 691
              diff= TestInput(j,:)- TrainInput(z,:);
              Distance(z)=sqrt(sum(diff .^2));
          end
        
          Dist=Distance;
          for k=1: K
              a=min(Dist);
              Weight(k)= 1/(a +eps);
              temp=find(Distance(:,:)== min(Dist));
              Index(k)=temp(1,1);
              b = find(Dist(:,:)== min(Dist));
              Dist(:,b)=[];
          end
    
          DecisionGroup = TrainTarget(Index);
          Class=[0 0];
          for l=1: K
              switch DecisionGroup(l)
                   case 0
                      Class(1)=Class(1) + Weight(l);
                   case 1
                      Class(2)=Class(2) + Weight(l);
              end
          end
    
          Max=max(Class);
          Ind=find(Class(:,:)==Max);
          OutPut(j)=Ind(1,1)-1;
        
    end
        
     
   % Hypothesis Evaluation:
   AccVect=TestTarget-OutPut';
     
   for count= 1:77
       if AccVect(count)==-1
           FP=FP+1;
       elseif AccVect(count)==1
           FN=FN+1;
       elseif AccVect(count)==0
             if TestTarget(count)==1
                 TP=TP+1;
             else
                 TN=TN+1;
             end
       end
   end
   
   ti(i)=toc; 
   MCC(i)=((TP*TN)-(FP*FN))/sqrt((TP+FP)*(TP+FN)*(TN+FP)*(TN+FN));
   F1(i)= (2*TP)/((2*TP)+FP+FN);
   ACC(i)= (TP+TN)/(TP+FP+TN+FN);
   Sens(i)= TP/(TP+FN);
   Spec(i)= TN/(TN+FP);
   
end % end of run
   
Mean= mean(ACC);
STD=std(ACC);
Time= mean(ti);
MCC=mean(MCC);
F1=mean(F1);
Sensitivity=mean(Sens);
Specificity=mean(Spec);

Result=[Mean STD MCC F1 Sensitivity Specificity Time];
%disp('     Mean       Std       MCC       F1       Sens      Spec      Time');
%disp(Result)
