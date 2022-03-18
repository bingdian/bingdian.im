---
title: "Web 安全系列 - 代码注入篇"
date: 2022-03-18T21:33:49+08:00
draft: true
tags: ["Web安全","CSRF"]
---

## 一、介绍

代码注入攻击指的是攻击者在应用程序中注入源代码，以改变程序的运行，这类攻击通常是由于缺乏对用户输入/输出数据验证和过滤导致的。


## 二、 XSS

XSS 是代码注入的一种，详见 [Web 安全系列 - XSS 篇](https://bingdian.io/develop/web-security-xss/)

## 三、SQL 注入

### 什么是 SQL 注入

SQL 注入攻击（SQL injection），是发生于数据库的安全漏洞，是 Web 开发中最常见的一种安全漏洞。

程序由于没有对用户输入数据的合法性进行验证和过滤，攻击者通过向服务器提交精心构造的恶意代码，程序将攻击者的输入作为查询语句的一部分执行，从而实现攻击。如增加、删除、查询、修改数据等及操作。

### SQL 注入危害

- 敏感数据泄露
- 数据被恶意修改或删除
- 在网页加入恶意链接、恶意代码以及 XSS 等

### SQL 注入示例

    // 网站登录代码:
    "SELECT * FROM users WHERE (username = '" + userName + "') and (password = '"+ passWord +"');"
    
    // 恶意输入
    username = "1' OR '1'='1";
    password = "1' OR '1'='1";
    
    // 实际上运行结果
    "SELECT * FROM users WHERE (username = '1' OR '1'='1') and (password = '1' OR '1'='1');"
    "SELECT * FROM users;"

### SQL 注入防范

防范核心原则：

    一切用户输入皆不可信
    一切用户输入皆不可信
    一切用户输入皆不可信

1. 使用 [参数化查询（Parameterized Query）](https://zh.wikipedia.org/wiki/%E5%8F%83%E6%95%B8%E5%8C%96%E6%9F%A5%E8%A9%A2) - 参数化的语句使用参数而不是将用户输入变量嵌入到SQL语句中，即不要直接拼接SQL语句。
2. Web 应用的数据库的操作权限最小化，减少注入攻击对数据库的危害 
3. 检查输入的数据是否具有所期望的数据格式，对进入数据库的特殊字符（ `'` `"` `\` `<` `>` `&` `*` `;` 等）进行转义处理，或编码转换。
4. 避免打印 SQL 错误信息，防止攻击者利用误信息进行 SQL 注入


## 四、动态代码注入

### 动态代码注入介绍

Web 应用允许用户输入在服务器端执行，从而导致的安全问题（等于给用户开放了服务器的完全控制权限）。如：

    // Node.js
    eval(evilString);
    new Function(evilString);
    
    // Python
    eval(evilString);
    exec(evilString);
    
    // Ruby
    eval 'evilString';
    
    // PHP
    eval(evilString);

### 动态代码注入危害

- 获取服务器上敏感内容
- 在服务器上运行恶意代码
- 获取服务器的控制权

### 动态代码注入防范

需要代码动态执行的地方，需要严格控制外部输入数据，确保外部输入为处理过的字符串。

## 参考文档

- [Code Injection](https://owasp.org/www-community/attacks/Code_Injection)
