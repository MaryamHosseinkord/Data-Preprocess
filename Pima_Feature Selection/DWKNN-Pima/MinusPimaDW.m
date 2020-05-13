%Sequential Backward Elimination:


function [ExistingList,res]= MinusPimaDW(ExistingList,R)


for count=1:R
       Acc=[];   
       for q=1:8
           
           TemporalExistingList = ExistingList;
          if TemporalExistingList(q)==1
            TemporalExistingList(q)=0;
            
            [Acc(q),res]=DWPimaSel(TemporalExistingList);
          else
              Acc(q)=-1;
          end
            
                     
       end
      
            winner = find(Acc==max(Acc));
            ExistingList(winner(1,1))=0;
            disp('----Feature Deleted:');
            disp(winner(1,1));
end