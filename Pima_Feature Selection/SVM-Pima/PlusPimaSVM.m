%Sequential Forward Selection


function[ExistingList,res]= PlusPimaSVM(ExistingList,I)

for count=1:I
       Acc=[];   
       for q=1:8
           
           TemporalExistingList = ExistingList;
          if TemporalExistingList(q)==0
            TemporalExistingList(q)=1;
            
            [Acc(q),res]=SVMPimaSel(TemporalExistingList);
          else
              Acc(q)=-1;
          end
            
                     
       end
      
            winner = find(Acc==max(Acc));
            ExistingList(winner(1,1))=1;
            disp('----Feature Added:');
            disp(winner(1,1));
end