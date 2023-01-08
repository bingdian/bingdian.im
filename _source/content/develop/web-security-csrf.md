---
title: "Web 安全系列 - CSRF 篇"
date: 2022-03-10T00:22:54+08:00 
draft: true
tags: ["Web安全","CSRF"]
---

## 一、什么是 CSRF

CSRF (Cross-Site Request Forgery，跨站请求伪造) 是一种 Web 安全漏洞，也被称为 one-click attack 或者 session riding。

攻击原理： http 是无状态的，服务端通过客户端 cookie 对当前请求鉴权。CSRF 就是利用的是网站对用户客户端的信任进行攻击。
对服务器来说这个请求是完全合法的，但是却完成了攻击者所期望的一个操作，比如以受害者身份发邮件、发消息，甚至于购买商品、虚拟货币转账等。

<img style="padding: 10px 0;" src="/images/develop/web-security/web-security-csrf.png" alt="csrf" width="1024" />

## 二、常见 CSRF 攻击

### GET 类型 CSRF

如果有接口可以直接通过 GET 请可以进行敏感操作，攻击者可以直接通过页面加载图片的方式进行攻击，浏览器会自动发送 `https://bank.com/withdraw?amount=1000&for=hacker`，从达到攻击效果。

```
<img src="https://bank.com/withdraw?amount=1000&for=hacker" />
```

### POST 类型 CSRF

这种类型攻击通常是使用表单的方式进行的：

```
 <form action="http://bank.example/withdraw" method=POST>
    <input type="hidden" name="account" value="xiaoming" />
    <input type="hidden" name="amount" value="1000" />
    <input type="hidden" name="for" value="hacker" />
</form>
<script> document.forms[0].submit(); </script> 
```

访问页面后，表单会自动提交，从而达成攻击效果。


## 三 、CSRF 防范

### referer

通过服务端校验请求 referer，阻止非信任域访问。referer属性是可以修改的，所以在服务器端校验 referer 属性并不可靠。

### CSRF Token

1. 生成 CSRF token - 用户访问页面，服务端生成一个 CSRF Token 发送给浏览器
   - Synchronizer Tokens：通过响应页面时将 token 渲染到页面上，在 form 表单提交的时候通过隐藏域提交上来。
   - Double Cookie Defense：将 token 设置在 Cookie 中，在提交（POST、PUT、PATCH、DELETE 等）请求时提交 Cookie，并通过 header 或者 body 带上 Cookie 中的 token，服务端进行对比校验。
2. 浏览器请求时携带 CSRF Token
3. 服务器收到请求后，验证 CSRF token 是否合法，如果不合法拒绝请求

## 参考文档

- [https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Request_Forgery_Prevention_Cheat_Sheet.html](https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Request_Forgery_Prevention_Cheat_Sheet.html)
- [https://www.freebuf.com/articles/web/224446.html]( https://www.freebuf.com/articles/web/224446.html)
- [(https://www.davidairey.com/google-gmail-security-hijack/](https://www.davidairey.com/google-gmail-security-hijack/)

