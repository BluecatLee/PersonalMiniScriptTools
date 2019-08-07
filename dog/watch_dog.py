#!/bin/env python
# -*- coding: utf-8 -*-

# 看门狗 检测网站是否挂掉并发送提示邮件

import urllib2
import smtplib
from email.mime.text import MIMEText

URL_SITE='{看门网站}'
SMTP_SERVER='{smtp服务器}'
USERNAME='{发件人邮箱}'
PASSWORD='{发件人邮箱账户}'
SENDER='{发件人邮箱密码}'
RECEIVE=['{接收人邮箱1}','{接收人邮箱2..}']

def watch():
    try:
        reponse = urllib2.urlopen(URL_SITE, timeout = 3)
        code = reponse.getcode()
        if code != 200:
            send_mail()
    except urllib2.URLError, e:
        send_mail()

def send_mail():
    smtp = smtplib.SMTP_SSL(SMTP_SERVER, 465)
    # smtp.connect()
    smtp.login(USERNAME, PASSWORD)

    msg = MIMEText('%s 访问不了' % URL_SITE, 'plain', 'utf-8')
    msg['From'] = u'{网站名}[看门狗发来信息]'
    msg['To'] = u'所有人'
    msg['Subject'] = u'官网首页访问不了，请尽快处理！！'

    smtp.sendmail(SENDER, RECEIVE, msg.as_string())
    smtp.quit()


if __name__ == '__main__':
    watch()

