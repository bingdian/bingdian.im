---
title: "Web 安全系列 - XSS 篇"
date: 2022-03-08T21:49:56+08:00
draft: true
tags:[ "Web安全", "XSS"]
---

## 一、 什么是 XSS

XSS (Cross-site scripting) 是一种网站应用程序的安全漏洞，是代码注入的一种，攻击者可以利用漏洞在网站上注入恶意代码。

当被攻击者访问被攻击的网站时就会自动运行这些恶意代码，攻击者可以突破网站的访问权限，以当前页面的访问用†户的身份，执行前端可执行的操作或窃取用户信息，对当前用户造成影响。

    <img src="http://domain/not_exist.png" onerror="alert('evil')">

## 二、XSS 类型

### 反射型 XSS (Reflected XSS)

反射型的 XSS 攻击，主要是由于服务端接收到客户端的不安全输入，在客户端触发执行从而发起 Web 攻击。

下图是常见的反射型 XSS 攻击过程图：

<img style="padding: 10px 0;" src="/image/develop/web-security/web-security-reflected-XSS.png" alt="反射型 XSS" width="1024" />

### 存储型 XSS (Stored XSS)

基于存储的 XSS 攻击，是通过提交带有恶意脚本的内容存储在服务器上，当其他人看到这些内容时发起 Web 攻击。一般提交的内容都是通过一些富文本编辑器编辑的，很容易插入危险代码。

以下是常见的存储型 XSS 攻击过程图：

<img style="padding: 10px 0;" src="/image/develop/web-security/web-security-stored-XSS.png" alt="反射型 XSS" width="1024" />

## 三、 XSS 的危害

### 窃取 cookie

攻击者通过注入代码发送 http 请求窃取用户 cookie

    <script>
        const adr = '../evil?cakemonster=' + escape(document.cookie);
    </script>

### 执行未授权操作

利用注入 Javascript 脚本，以用户身份执行未授权操作。例如，在一些有 XSS 漏洞的社交网站，进行加好友、发私信等操作。

#### 按键记录

注入代码，记录用户键盘输入信息，并通过 http 请求发送到攻击者指定服务器。

### DDos 攻击

在一些访问量大网站上 XSS 可以攻击一些小型网站，实现 DDoS 攻击效果。

### 钓鱼

攻击者可以利用漏洞注入 DOM，伪造登录框，诱导用户在本不需要登录的页面，去输入自己的用户名和密码。

### 四、XSS 防范

### 4.1 编码防范

    编码防范核心原则：

    一切用户输入皆不可信
    一切用户输入皆不可信
    一切用户输入皆不可信

#### 编码过滤内容

- html 转义 - 前端 html 模板渲染（服务端模板和客户端 JS 模板）, html 转义是最常用的转义方式，转义后的数据，在 HTML 上下文中正常显示。
- 富文本过滤 - 富文本编辑器内容过滤，可以参考 [https://github.com/leizongmin/js-xss/blob/master/lib/default.js#L12-L76](https://github.com/leizongmin/js-xss/blob/master/lib/default.js#L12-L76) 和 [https://github.com/leizongmin/js-css-filter/blob/master/dist/cssfilter.js#L120-465](https://github.com/leizongmin/js-css-filter/blob/master/dist/cssfilter.js#L120-465)
- escapeJson - JS 中输出 json 数据。如果 json 数据未转义，有可能会被注入。

#### 编码过滤时机(输入还是输出时处理?)

在输出时处理会有以下一些问题：

1. 无法保存用户的原始输入信息
2. 当出现了 Bug 或者想要对黑客行为进行溯源时，你只能“推断”，而不能准确地获取用户的原始输入
3. html 在输入时处理，输出再处理的话会导致二次转义

因此，**推荐在需要输出的时候进行处理**。

### 4.2 浏览器防范

浏览器有一定针对各种攻击的防范能力，一般是通过开启 Web 安全头生效的。 浏览器提供的 XSS 保护并不完美，但是开启后有助于提升攻击难度。

1. CSP( Content Security Policy，内容安全策略)
2. X-Download-Options:noopen - 禁用 IE 下下载框 Open 按钮
3. X-Content-Type-Options:nosniff - 禁用 IE8 自动嗅探 mime 功能
4. X-XSS-Protection - IE 提供的一些 XSS 检测与防范

## 参考文档

- [https://owasp.org/www-project-top-ten/OWASP_Top_Ten_2017/Top_10-2017_A7-Cross-Site_Scripting_(XSS)](https://owasp.org/www-project-top-ten/OWASP_Top_Ten_2017/Top_10-2017_A7-Cross-Site_Scripting_(XSS)) 
- [https://developer.mozilla.org/zh-CN/docs/Glossary/Cross-site_scripting](https://developer.mozilla.org/zh-CN/docs/Glossary/Cross-site_scripting)
