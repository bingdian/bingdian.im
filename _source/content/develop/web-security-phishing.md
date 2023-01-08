---
title: "Web 安全系列 - 钓鱼攻击篇"
date: 2022-03-21T21:57:00+08:00
draft: true
tags: ["Web安全"]
---

钓鱼攻击有有多种方式，本篇主要讲 Web 安全中常见的 url 钓鱼 iframe 钓鱼、401 钓鱼。

## 一、 url 钓鱼

用户在可信网站上点击链接，由于服务端未对传入的跳转 url 进行检查校验，可能导致可恶意构造任意一个恶意地址，诱导用户跳转到恶意网站。 由于是从可信的站点跳转出去的，用户会比较信任，通过转到恶意网站欺骗用户输入用户名和密码盗取用户信息，或欺骗用户进行金钱交易。

### 防范方式

跳转域名使用域名白名单，阻止非白名单域名跳转，或者跳转到非白名单域名时给用户提示。

## 二、 iframe 钓鱼

通过内嵌 iframe 到被攻击的网页中，攻击者可以引导用户去点击iframe 指向的危险网站，甚至遮盖，影响网站的正常功能，劫持用户的点击操作。

### 防范方式

使用 X-Frame-Options 响应头
- DENY - 页面不允许在 frame 中展示
- SAMEORIGIN - 页面可以在相同域名页面的 frame 中展示
- ALLOW-FROM https://example.com/ - 页面可以在指定来源的 frame 中展示

浏览器支持情况详见 https://caniuse.com/?search=X-Frame-Options

## 三、 401 钓鱼

如果允许用户向网页里插入未经验证的外链图片，就有可能出现钓鱼风险。攻击者在被攻击页面插入需要使用 Basic authentication 认证的资源。当用户访问被攻击页面时，页面会弹出输入框让用户输入帐号及密码，当用户输入之后，帐号及密码就存储到了黑客的服务器中。

攻击示例：

<img style="padding: 10px 0;" src="/images/develop/web-security/web-security-401-phishing.png" alt="401 钓鱼" width="480" />

### 防范方式

对用户插入页面的 url 资源进行白名单校验。
