function b = subsref(s,index)
switch index(1).type
case '()'
   return
case '{}'
   return
case '.'
   switch index(1).subs
   case 'a'
      if length(index)==2
         switch index(2).type
         case '{}'
            return
         case '.'
            return
         case '()'
            b = s.a(index(2).subs{1},index(2).subs{2});
         end
      else
         b = s.a;
      end 
   case 'b'
      if length(index)==2
         switch index(2).type
         case '{}'
            return
         case '.'
            return
         case '()'
            b = s.b(index(2).subs{1},index(2).subs{2});
         end
      else
         b = s.b;
      end 
   case 'c'
      if length(index)==2
         switch index(2).type
         case '{}'
            return
         case '.'
            return
         case '()'
            b = s.c(index(2).subs{1},index(2).subs{2});
         end
      else
         b = s.c;
      end
   case 'd'
      if length(index)==2
         switch index(2).type
         case '{}'
            return
         case '.'
            return
         case '()'
            b = s.d(index(2).subs{1},index(2).subs{2});
         end
      else
         b = s.d;
      end
   case 'NumStates'
         b = s.NumStates; 
   case 'NumInputs'
         b = s.NumInputs;
   case 'NumOutputs'
         b = s.NumOutputs;
   end
end