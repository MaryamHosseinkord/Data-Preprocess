%Sequential Forward Selection

function[ExistingList,res]= PlusHeartDW(ExistingList,I)

for count= 1:I
       Acc=[];   
       for q=1:13
           
           TemporalExistingList = ExistingList;
          if TemporalExistingList(q)==0
            TemporalExistingList(q)=1;
            
            [Acc(q),res]=DWHeartSel(TemporalExistingList);
          else
              Acc(q)=-1;
          end
            
                     
       end
      
            winner = find(Acc==max(Acc));
            ExistingList(winner(1,1))=1;
            disp('----Feature Added:');
            disp(winner(1,1));
end