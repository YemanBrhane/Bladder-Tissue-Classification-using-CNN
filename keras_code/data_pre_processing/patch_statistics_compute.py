# -*- coding: utf-8 -*-
"""
Created on Wed Aug 16 16:44:00 2017

@author: ybhagos
"""
import numpy as np
num = 50000

def compute_percentage():
    
   # patches after rotating 45 degree
   patches = np.load('patch_45_stat.npz')
   num_muscle = patches['num_muscle']
   num_cancer = patches['num_cancer']
   num_normal = patches['num_normal']

   # patches from orginal images
   patches = np.load('patch_0_stat.npz')
   num_muscle_ = patches['num_muscle']
   num_cancer_ = patches['num_cancer']
   num_normal_ = patches['num_normal']

   num_muscle = num_muscle + 2 * num_muscle_
   num_cancer = num_cancer + 2 * num_cancer_
   num_normal = num_normal + 2 * num_normal_
   
   return num_muscle, num_cancer, num_normal

if __name__=='__main__':
    
    num_muscle, num_cancer, num_normal = compute_percentage()
    muscle_percent = num/num_muscle
    normal_percent = num/num_normal
    cancer_percent = num/num_cancer
    total  = round(muscle_percent * num_muscle + normal_percent* num_normal + cancer_percent*num_cancer)
    print(muscle_percent)
    print(normal_percent)
    print(cancer_percent)
    print(total)






