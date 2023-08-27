function [status,errmsg] = checkToolBox(name)
    [status,errmsg] = license('checkout',name);
   if status == 0
       error(errmsg);
   end
end