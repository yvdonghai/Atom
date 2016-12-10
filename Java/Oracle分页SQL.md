--1:无ORDER BY排序的写法。(效率最高)  
--(经过测试，此方法成本最低，只嵌套一层，速度最快！即使查询的数据量再大，也几乎不受影响，速度依然！)  
```SQL
SELECT *  
  FROM (SELECT ROWNUM AS rowno, t.*  
          FROM table_name t  
         WHERE ROWNUM <= 20) table_alias  
 WHERE table_alias.rowno >= 10;  
```
--2:有ORDER BY排序的写法。(效率最高)  
--(经过测试，此方法随着查询范围的扩大，速度也会越来越慢哦！)  
```SQL
SELECT *  
  FROM (SELECT tt.*, ROWNUM AS rowno  
          FROM (  SELECT t.*  
                    FROM table_name t  
                ORDER BY create_time DESC, table_id_no) tt  
         WHERE ROWNUM <= 20) table_alias  
 WHERE table_alias.rowno >= 10;  
 ```
 引用:http://blog.sina.com.cn/s/blog_8604ca230100vro9.html
