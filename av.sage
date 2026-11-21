load("frobs.sage")

class AV:
    def __init__(self, g, r=1, label="A"):
        self.g = g
        self.r = r
        self.label = label
        self.conditions = []
        self._frob = None
        self.End0 = None
    
    def dim(self):
        return self.g
    
    def base_field_deg(self):
        return self.r
    
    def __repr__(self):
        if self.r == 1:
            return f"{self.label}"
        else:
            return f"{self.label}/F_q^{self.r}"
    
    def __eq__(self, B):
        return (type(self), self.g, self.r, self.label) == (type(B), B.g, B.r, B.label)

    def conditions_str(self):
        if len(self.conditions) >= 0:
            return ", ".join(self.conditions)
        return ""
    
    def frob(self, ring=None):
        if self._frob != None:
            return self._frob

        var = self.label.lower()
        if ring == None:
            ring = init_ring(self.g, exts=[self.r], var=var)
        q0 = ring('q')
        self._frob = frob_pol(self.g, q0, ring, k=self.r, var=var)
        return self._frob
    
    def frob_label(self, var='T'):
        dg = self.base_field_deg()
        if dg == 1:
            return f"\\chi_{{{self},q}}({var})"
        else:
            return f"\\chi_{{{self},q^{dg}}}({var})"
