# ReadMe

THU Search 

- 运行环境

  tomcat8 + InteliJ IDEA

- 配置方法

  - 下载庖丁解牛分词器，修改src目录下的paoding-dic-home.properties中对应分词器路径
  - 运行indexWriter生成索引，放到tomcat/bin目录下，随后运行tomcat即可


- 暂时实现的功能

  - 解析html
  - 庖丁解牛分词
  - MutilField检索
  - 搜索关键词高亮
  - 逻辑查询：AND / OR / NOT
  - 模糊查询：query + “~”
  - 使用lucene默认的score算法(VSM模型)，并考虑了PageRank
  - 特殊考虑了对url的检索，使用正则表达式

- 待实现功能
  - 解析doc / pdf
  - 查询纠错和查询提示
  - 不同的score算法(如bm25等)
  - 更好的前端风格和功能：如鼠标悬停预览、语音输入等

