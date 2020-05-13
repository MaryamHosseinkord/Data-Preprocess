


function[Mean,Result]= RBFPimaSel(Existinglist)

%Existinglist=[1 0 0 1 1 0 1 0 1];
AttributeCount=sum(Existinglist);
ind = find(Existinglist);
data = load('pima.dat');

data=data(:,ind);


inputData = data(:,1:end-1);
targetData = data(:,end);
fSpace = size(inputData,2);

indices = crossvalind('Kfold',targetData,10);

for i = 1:10
    t=tic;
    test = (indices == i); train = ~test;
    
    dataTrain = inputData(train,:);
    trainSize = size(dataTrain,1);
    dataTest = inputData(test,:);
    testSize = size(dataTest,1);
    centers = randi(trainSize,[1,fSpace]);
  
    for j=1:fSpace
        for k=1:fSpace
            dictanceCenter(j,k) =pdist2(dataTrain(centers(j),:),dataTrain(centers(k),:));
        end
    end
    dictanceCenter = triu(dictanceCenter);
    
    mDistance = max(max(dictanceCenter));
    
    sigma = mDistance / sqrt(fSpace);
    
    phi = zeros(trainSize,fSpace);
    for j=1:trainSize
        for k=1:fSpace
            phi(j,k) = exp(((-fSpace/mDistance.^2)*(pdist2(dataTrain(j,:),dataTrain(centers(k),:)).^2)));
        end
    end
        
    w = pinv(phi)*targetData(train);
    
    phiTest = zeros(testSize,fSpace);
    for j=1:testSize
        for k=1:fSpace
            phiTest(j,k) = exp(((-fSpace/mDistance.^2)*(pdist2(dataTest(j,:),dataTrain(centers(k),:)).^2)));
        end
    end
    
    yTest = zeros(1,testSize);
    for j=1:testSize
        for k=1:fSpace
            yTest(j) = sum(w(k)*phiTest(j,k));
        end
    end

    yTestNormal = zeros(1,testSize);
    for j=1:testSize
        yTestNormal(j) =round((yTest(j) - min(yTest))/(max(yTest) - min(yTest)));
    end
    
    timeVar(i) = toc(t);
    tableVar(i,:) = valueTable(yTestNormal,targetData(test));
    accVar(i) = ACC(tableVar(i,4) , tableVar(i,2) , tableVar(i,3) , tableVar(i,1));
    sensitivityVar(i) = sensitivity(tableVar(i,4) , tableVar(i,1));
    specificityVar(i) = specificity(tableVar(i,3) , tableVar(i,2));
    mccVar(i) = MCC(tableVar(i,4) , tableVar(i,2) , tableVar(i,3) , tableVar(i,1));
    f1Var(i) = F1_Score(tableVar(i,4) , tableVar(i,2) , tableVar(i,1));
   
 end

mean_acc = mean(accVar);
std_acc = std(accVar);
mean_mcc = mean(mccVar);
mean_f1 = mean(f1Var);
mean_sensitivity = mean(sensitivityVar);
mean_specificity = mean(specificityVar);
mean_time = mean(timeVar);

Mean=mean_acc;

Result=[mean_acc std_acc mean_mcc mean_f1 mean_sensitivity mean_specificity mean_time];
%disp('     Mean       Std       MCC       F1       Sens      Spec      Time');
%disp(Result)
