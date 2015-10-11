#!/bin/bash

fix_paths(){
 x=$(otool -L $i |grep loader_path|awk '{print $1}'|cut -d"/" -f2) 
 echo $x 
 for y in $x ;do 
  install_name_tool -id @executable_path/$y $i 
  install_name_tool -change @loader_path/$y @executable_path/$y $i
 done
}
fix_plugins(){
 x=$(otool -L $p |grep loader_path|awk '{print $1}'| awk -F "/" '{print $NF}' )
 echo $x 
 for y in $x ;do 
  install_name_tool -id @executable_path/../../$y $p
  install_name_tool -change @loader_path/../../$y @executable_path/../../$y $p
 done
}
top(){
for i in * ; do 
  test -f ${i} && fix_paths
done
}
 
top
cd qt4_plugins
for dir in * ; do 
 cd $dir
 for p in * ; do 
  fix_plugins
 done
 cd ..
done
cd ..


