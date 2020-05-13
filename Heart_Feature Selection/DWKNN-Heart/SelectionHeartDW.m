
clear
clc

load Heart.dat
[m,n] = size(Heart);
featureSize=n-1;


I=randi(featureSize-8,1);
R=randi(featureSize-1,1);

while R==I
    R=randi(featureSize-1,1);
end

if I>R
    
    %Adding----starting with null
    ExistingList=[0,0,0,0,0,0,0,0,0,0,0,0,0,1];
    disp('Sequential Forward Selection');
    disp(I);
    disp('features will be added to Null selection.');
    [ExistingList,res]=PlusHeartDW(ExistingList,I);
    
    %Elimination--->
    disp('Sequential Backward Elimination');
    disp(R);
    disp('features will be deleted from existing selection.');
    [ExistingList,res]=MinusHeartDW(ExistingList,R);
else
    
    %Elimination----starting with fullSet
    ExistingList=[1,1,1,1,1,1,1,1,1,1,1,1,1,1];
    disp('Sequential Backward Elimination');
    disp(R);
    disp('features will be deleted from Full selection.');
    [ExistingList,res]=MinusHeartDW(ExistingList,R);
    
    %Addition--->
    disp('Sequential Forward Selection');
    disp(I);
    disp('features will be added  to existing selection.');
    [ExistingList,res]=PlusHeartDW(ExistingList,I);
    
end % if I>R 
disp('    *****************************************');      
disp('    * Features selected by Plus-i Minus-r:  *');
ExistingList(n)=0;
result=find(ExistingList);
disp(result);
disp('    *****************************************');
disp('    ');
disp('     Mean       Std       MCC       F1       Sens      Spec      Time');
disp(res)


TPR=res(1,5);
FPR=1-res(1,6);

figure;
x=0:0.01:1;
y=0:0.01:1;
plot(x,y,'-');
hold on;
plot(0,1,'or');
text(0,1, ['\leftarrow Perfect classification'])
hold on;

plot(FPR,TPR,'*r'); 
hold on;


axis([0 1 0 1]);
title('ROC Plot');
xlabel('FPR');
ylabel('TPR');
