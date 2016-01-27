# Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2014 jeremie Bellec
#

class MatriceItem extends TreeItem
    constructor: ( ) ->
        
  
    m_get :(matrice,i,j)->
        return matrice.subset(math.index(i-1,j-1))
      
    m_set :(matrice,i,j,val)->
        return matrice.subset(math.index(i-1,j-1), val)
      
    m_length :(matrice)->   
        matrice_size = math.size(matrice)
        matrice_length = matrice_size.subset(math.index(0))
        return matrice_length
      
    m_change_rep :(m0,m1)->  
        m0_trans = math.transpose(m0) 
        k1 = math.multiply(m1, m0)
        m1_rep = math.multiply(m0_trans, k1)
        return m1_rep
     
    #copy for square matrix 
    m_copy :(m0)->  
        m1 = math.zeros(@m_length(m0), @m_length(m0))
        for i in [1 .. @m_length(m0) - 1 ]
            for j in [1 .. @m_length(m0) - 1 ]
                @m_set  m1, i, j, @m_get(m0,i,j)
        return m1
        