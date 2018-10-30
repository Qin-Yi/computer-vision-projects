from tqdm import tqdm
import numpy as np
from scipy.misc import imsave

# line count
num_points=sum(1 for line in open('SIST_000_oct0_01.xyz'))
fp=open('SIST_000_oct0_01.xyz')
keys=['x','y','z','r','g','b']
# load .xyz pointcloud with progress bar
points=[]
for line in tqdm(fp,total=num_points,desc='loading pointcloud'):
    # ignore empty lines
    if not line: continue
    row_list=line.split()
    elements=list(map(float,row_list[2:5]))+list(map(int,row_list[5:]))
    points.append(dict(zip(keys,elements)))

f = open("camera_photos.txt", "r").readlines()
for i in range(0,len(f),3):
    intrinsic=f[i+1].split(';')[:3]
    extrinsic=f[i+2].split(';')[:4]
    intrinsic=[intrinsic[j].split(',') for j in range(3)]
    for j in range(3): intrinsic[j].append('0')
    extrinsic=[extrinsic[j].split(',') for j in range(4)]

    M=[[0,0,0,0],[0,0,0,0],[0,0,0,0]]
    for l in range(3):
        for j in range(4):
            M[l][j]=sum(float(intrinsic[l][k])*float(extrinsic[k][j]) for k in range(4))


    projection=[]
    for pt in points:
        P=[pt['x'],pt['y'],pt['z'],1]
        lam=sum(M[2][k]*P[k] for k in range(4))
        if lam!=0:
            x=sum(M[0][k]*P[k] for k in range(4))/lam
            y=sum(M[1][k]*P[k] for k in range(4))/lam
            if projection==[]:
                projection.append([x,y,float(pt['r']/255),float(pt['g']/255),float(pt['b']/255)])
                max_x=x
                min_x=x
                max_y=y
                min_y=y
            else:
                projection.append([x,y,float(pt['r']/255),float(pt['g']/255),float(pt['b']/255)])
                max_x=max(projection[-1][0],max_x)
                min_x=min(projection[-1][0],min_x)
                max_y=max(projection[-1][1],max_y)
                min_y=min(projection[-1][1],min_y)

    print(len(points),len(projection))
    width = max_x - min_x
    height = max_y - min_y
    if (width>0) and (height>0):
        rate=5000/(max(width,height))
        img = [[[0,0,0] for j in range(5001)] for k in range(5001)]
        print(width,height)
        for pt in projection:
            try:
                img[round(rate*(pt[0]-min_x))][round(rate*(pt[1]-min_y))]=pt[2:]
            except:
                print(pt)
        print('img')
        imsave(f[i][:len(f[i])-1]+'.jpg',img)
