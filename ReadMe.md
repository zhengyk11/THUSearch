# ReadMe

THU Search 

- 运行环境

  tomcat8 + InteliJ IDEA

- 配置方法

  - 下载庖丁解牛分词器，修改src目录下的paoding-dic-home.properties中对应分词器路径
  - 运行indexWriter生成索引，放到tomcat/bin目录下，随后运行tomcat即可


- 暂时实现的功能

  - 解析html / doc / pdf
  - 庖丁解牛 / IK分词
  - 搜索关键词在content中高亮
  - 基于lucene的高级查询：布尔查询、模糊查询、多域查询、区间查询
  - 使用lucene默认的score算法(VSM模型)，并考虑了PageRank
  - 特殊考虑了对url的检索，使用正则表达式
  - 查询纠错
  - 语音输入
  - 鼠标悬停预览

- 待实现功能
  - 查询提示
  - 不同的score算法(如bm25等)

