function tree::init, x
    compile_opt idl2, logical_predicate
    
    self.elem = x
    
    return, !true
    
end

pro tree::add, x
    compile_opt idl2, logical_predicate
    
    if x lt self.elem $
        then if obj_valid(self.lower) $
            then self.lower.add, x $
            else self.lower = tree(x) $
        else if obj_valid(self.upper) $
            then self.upper.add, x $
            else self.upper = tree(x)
    
end

pro tree__define
    compile_opt idl2, logical_predicate

    define = {tree, $
        elem: 0, $
        lower: obj_new(), $
        upper: obj_new() $
    }

end
