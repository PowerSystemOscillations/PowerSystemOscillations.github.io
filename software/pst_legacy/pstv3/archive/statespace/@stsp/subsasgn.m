function s = subsasgn(s,index,val)
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
            if length(index(2).subs)==1
                s.a(index(2).subs{1})=val;
            else
                s.a(index(2).subs{1},index(2).subs{2})=val;
            end
         end
      else
         s.a = val;
      end
      [nr,nc] = size(s.a);
      if nr~=nc
         error('the state matrix must be square')
      else
         s.NumStates = size(s.a,1);
      end
   case 'b'
      if length(index)==2
         switch index(2).type
         case '{}'
            return
         case '.'
            return
         case '()'
            if length(index(2).subs)==1
                s.b(index(2).subs{1})=val;
            else
                s.b(index(2).subs{1},index(2).subs{2})=val;
            end
         end
      else
         s.b = val;
      end
      [ns,ni]=size(s.b);
      if ns~=s.NumStates
         error('b must have the same number of rows as a')
      else
         s.NumInputs = ni;
      end
   case 'c'
      if length(index)==2
         switch index(2).type
         case '{}'
            return
         case '.'
            return
         case '()'
            if length(index(2).subs)==1
                s.c(index(2).subs{1})=val;
            else
                s.c(index(2).subs{1},index(2).subs{2})=val;
            end
         end
      else
         s.c = val;
      end 
      [no,ns]=size(s.c);
      if ns~=s.NumStates
         error('c must have the same number of columns as a')
      else
         s.NumOutputs = no;
      end
   case 'd'
      if length(index)==2
         switch index(2).type
         case '{}'
            return
         case '.'
            return
         case '()'
            if length(index(2).subs)==1
                s.d(index(2).subs{1})=val;
            else
                s.d(index(2).subs{1},index(2).subs{2})=val;
            end
         end
      else
         s.d = val;
      end 
      [no,ni]=size(s.d);
      if no~=s.NumOutputs
         error('d must have the same number of rows as c')
      elseif ni~=s.NumInputs
         error('d must have the same number of columns as b')
      else
         s.NumOutputs = no;
      end
   end
end