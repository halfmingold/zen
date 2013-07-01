#建立次级目录文件和文件夹 并在xml文件中写入内容
function copydir() {
mkdir ../$1
cp index.php ../$1
cp index.xml ../$1/$1.xml
#sed index.xml
LINK="./$1/"

THEME=`sed '1s/<[^<]*>//g' ../doc/$1/readme|head -1`
CONTENT=`sed '2s/<[^<]*>//g' ../doc/$1/readme|head -2|tail -1`
DATE=`date`
sed -i "3i</data>" ../index.xml
sed -i "3i<content>$CONTENT</content>" ../index.xml
sed -i "3i<theme>$THEME</theme>" ../index.xml
sed -i "3i<link>$LINK</link>" ../index.xml
sed -i "3i<data>" ../index.xml

sed -i "2s/index.xml/$1.xml/g" ../$1/index.php
}

#遍历doc目录
for i in `ls ../doc`
do
echo $i
  if  [ -d ../$i ];
  then 
    echo "yes"
  else
    copydir $i
    echo "add $i index"
  fi
done
#生成临时文件
cp -r ../doc ../tmp
#将doc下的文件添加tag 做好链接
function cphtml(){
	LINK="../$2/$1.php"
	THEME=`sed '1s/<[^<]*>//g' ../tmp/$2/$1|head -1`
	CONTENT=`sed '2s/<[^<]*>//g' ../tmp/$2/$1|head -2|tail -1`
	DATE=`date`
	
	sed -i "3i</data>" ../$2/$2.xml
	sed -i "3i<content>$CONTENT</content>" ../$2/$2.xml
	sed -i "3i<theme>$THEME</theme>" ../$2/$2.xml
	sed -i "3i<link>$LINK</link>" ../$2/$2.xml
	sed -i "3i<data>" ../$2/$2.xml

	sed -i "s/^$/<\/p><p>/g" ../tmp/$2/$1
	sed -i "s/$/<br \/>/g" ../tmp/$2/$1
	sed -i "s/<p><br \/>/<p>/g" ../tmp/$2/$1
	sed -i "1s/^/<h1>/g" ../tmp/$2/$1
	sed -i "1s/<br \/>/<\/h1>/g" ../tmp/$2/$1
	sed -i "2s/^/<p>/g" ../tmp/$2/$1
	sed -i "2s/<br \/>/<\/p><p>/g" ../tmp/$2/$1
	sed -i '$a</p>' ../tmp/$2/$1
	
	sed -i "1i<?php include \"../head.php\" ?>" ../tmp/$2/$1
	sed -i '$a<?php include \"../footer.php\" ?>' ../tmp/$2/$1

	cp -f ../tmp/$2/$1 ../$2/$1.php 
}
#文件存在的话 不写入xml
function updatehtml(){
	DATE=`date`
	
		sed -i "s/^$/<\/p><p>/g" ../tmp/$2/$1
	sed -i "s/$/<br \/>/g" ../tmp/$2/$1
	sed -i "s/<p><br \/>/<p>/g" ../tmp/$2/$1
	sed -i "1s/^/<h1>/g" ../tmp/$2/$1
	sed -i "1s/<br \/>/<\/h1>/g" ../tmp/$2/$1
	sed -i "2s/^/<p>/g" ../tmp/$2/$1
	sed -i "2s/<br \/>/<\/p><p>/g" ../tmp/$2/$1
	sed -i '$a</p>' ../tmp/$2/$1
	
	sed -i "1i<?php include \"../head.php\" ?>" ../tmp/$2/$1
	sed -i '$a<?php include \"../footer.php\" ?>' ../tmp/$2/$1
for p in `diff ../tmp/$2/$1 ../$2/$1.php`
do
	cp -f ../tmp/$2/$1 ../$2/$1.php
        sed -i "16i<p>$DATE update $j -> $i</p>" ../log.html
	break
done 	
}
#遍历doc下所有文件
for i in `ls ../doc`
do
  for j in `ls ../doc/$i/ | sed "s/readme//g"`
  do
    if [ -e ../$i/$j.php ];
    then
#这里可以比较两个文件内容（未实现）    
      updatehtml $j $i
      echo "yes"
    else
      cphtml $j $i
      echo "$j -> $i"
      sed -i "16i<p>$DATE add $j -> $i</p>" ../log.html    
      echo "no"
    fi
  done
done
rm -rf ../tmp
