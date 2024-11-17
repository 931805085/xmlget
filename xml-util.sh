#!/bin/bash
# author: ZCH
# date:  2024/11/16
# usage: 获取指定的XML节点或属性值
# param1: 需要获取的xml的位置描述，每个选择器以“/”分隔，可选以下分隔器
#   <TAG>        标签选择器，选择所有<TAG>标签
#   [ATTR="VAL"] 属性过滤器，用于过滤已经选择的标签，搭配<TAG>实现精确定位节点
#   [ATTR]       属性选择器，当遍历到它时，将直接返回ATTR属性的值
#   TEXT         内容选择器，当遍历到它时，将直接返回当前选择的节点的内容
# example: get_xml '<http-listener>/[name="admin-listener"]/<http-protocol>/<property>/[name="requestCharacterEncoding"]/[value]' /data/dev/xml/server.config;
#         获取/data/dev/xml/server.config中name属性的值为admin-listener的http-listener节点的http-protocol节点下的name属性值为"requestCharacterEncoding"的property节点的value属性值
# param2: 被读取的xml文件路径,可选，可以使用管道符输入
xmlget(){
cat $2|awk -v selector="$1" 'BEGIN{RS=SUBSEP;ORS="\n"}
{xml=$0;gsub(/[\r\n\t ]+/," ",xml);gsub(/> </,"><",xml);split(selector,paths,"/");get_node(xml,1)}
function get_node(xml,i,bp,ep,xmlc,bf,ef){if((i in paths)==0){print xml;return;}bf=paths[i];ef=paths[i];
if (substr(bf,1,1)=="<"){bf=substr(paths[i],0,length(paths[i])-1);ef=paths[i];sub("<","</",ef);
while((bp=index(xml,bf))!=0){if((ep=index(substr(xml,bp),">"))==0)break;
if(substr(xml,bp+ep-2,1)=="/"){get_node(substr(xml,bp,ep),i+1);xml=substr(xml,bp+ep);}
else{ep=index(substr(xml,bp),ef);get_node(substr(xml,bp,ep+length(ef)-1),i+1);xml=substr(xml,bp+ep+length(ef)-1);}}
}else if(substr(bf,1,1)=="["){bf=substr(bf,2,length(bf)-2);bp=index(xml,"<");ep=index(xml,">");
if(bp<ep){xmlc=substr(xml,bp,ep);if (index(bf,"=")==0){bf=" " bf "=\"";bp=index(xmlc,bf);
if(bp!=0){ep=index(xmlc=substr(xmlc,bp+length(bf)),"\"")-1;print substr(xmlc,0,ep);}}else{if(index(xmlc,bf)!=0)get_node(xml,i+1);}}
}else if(bf=="TEXT"){xmlc=substr(xml,index(xml,"<")+1);bp=index(xmlc,">");ep=index(xmlc," ");
if(ep==0||ep>bp)ep=bp;bf=substr(xmlc,0,ep-1);ep=index(xmlc=substr(xmlc,bp+1),"</"bf">");print substr(xmlc,0,ep-1);
}}'
}
