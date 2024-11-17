# xmlget
纯Shell实现的xml节点定位

## usage 
获取指定的XML节点或属性值

调用方式：xmlget &lt;selector&gt; [input_file] 

参数1: 需要获取的xml的位置描述，每个选择器以“/”分隔，可选以下分隔器
| 格式         | 描述                                                          |
| ------------ | ------------------------------------------------------------- |
| &lt;TAG&gt;  | 标签选择器，选择所有<TAG>标签                                 |
| [ATTR="VAL"] | 属性过滤器，用于过滤已经选择的标签，搭配<TAG>实现精确定位节点 |
| [ATTR]       | 属性选择器，当遍历到它时，将直接返回ATTR属性的值              |
| TEXT         | 内容选择器，当遍历到它时，将直接返回当前选择的节点的内容      |

参数2: 被读取的xml文件路径，可选，可以使用管道符输入

## example:
获取/data/dev/xml/server.config中name属性的值为admin-listener的http-listener节点的http-protocol节点下的name属性值为"requestCharacterEncoding"的property节点的value属性值，以下三种写法等价
``` shell
xmlget '<http-listener>/[name="admin-listener"]/<http-protocol>/<property>/[name="requestCharacterEncoding"]/[value]' /data/dev/xml/server.config;

xmlget '<http-listener>/[name="admin-listener"]/<http-protocol>/<property>/[name="requestCharacterEncoding"]/[value]' < /data/dev/xml/server.config;

cat "/data/dev/xml/server.config"|xmlget '<http-listener>/[name="admin-listener"]/<http-protocol>/<property>/[name="requestCharacterEncoding"]/[value]'
```

