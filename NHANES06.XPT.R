#install.packages("tidyverse")
#install.packages("haven")
#install.packages("nhanesA")


#引用包
library(tidyverse)
library(haven)
library(nhanesA)

#设置工作目录
setwd("C:\\Users\\lexb\\Desktop\\NHANES\\06.XPT")

#读取数据注释文件
infoRT=read.table("ann.txt", header=T, sep="\t", check.names=F, quote="")
infoVar=c("SEQN", toupper(infoRT$Variable))
infoLabel=c("SEQN", paste0(infoRT$Label, "_", infoRT$Type))

#获取目录下所有XPT结尾的文件
allXPT=list.files(pattern="*.XPT$")

#对XPT文件进行循环
for(file in allXPT){
	#读取XPT文件中的信息
	i=gsub("\\.XPT$", "", file)
	xptData=read_xpt(file)
	write.csv(xptData, file=paste0("all.", i, ".csv"), row.names=F)
	
	#提取需要的变量
	sameVar=intersect(colnames(xptData), infoVar)
	xptData2=xptData[,sameVar,drop=F]
	xptData2=as.data.frame(xptData2)
	colnames(xptData2)=infoLabel[match(colnames(xptData2), infoVar)]

	#对分组的编码进行转换
	for(varName in colnames(xptData2)[-1]){
		infoRT2=infoRT[infoRT$Label==gsub("(.+)\\_(.+)", "\\1", varName),]
		if(unique(infoRT2$Type)=="discrete"){
			varCode=infoRT2$Code
			varValue=infoRT2$Value
			xptData2[,varName]=varValue[match(xptData2[,varName], varCode)]
		}
	}
	#输出结果文件
	write.csv(xptData2, file=paste0("data.", i, ".csv"), row.names=F)
}


######生信自学网: https://www.biowolf.cn/
######课程链接1: https://shop119322454.taobao.com
######课程链接2: https://ke.biowolf.cn
######课程链接3: https://ke.biowolf.cn/mobile
######光俊老师邮箱: seqbio@foxmail.com
######光俊老师微信: eduBio


