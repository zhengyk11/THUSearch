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
  - 多关键词检索
  - 搜索关键词高亮
  - 逻辑查询：AND / OR / NOT
  - 模糊查询：query + “~”


- 待实现功能
  - 解析doc / pdf
  - 查询纠错和查询提示
  - 不同的score算法，目前没有考虑pagerank
  - 更好的前端风格和功能



