# -*- coding: utf-8 -*-
import requests
from bs4 import BeautifulSoup,element
import os
import re

headers_1 = {"user-agent": "Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; rv:11.0)like Gecko Core/1.70.3704.400 QQBrowser/10.4.3587.400",
             "referer": "http://www.shufazidian.com/",
             "Accept": "text/html, application/xhtml+xml, image/jxr, */*",
             "Accept-Encoding": "gzip, deflate",
             "Accept-Language": "zh-CN",
             "Cache-Control": "no-cache",
             "Connection": "Keep-Alive",
             "Content-Length": "19",
             "Content-Type": "application/x-www-form-urlencoded",
             "Cookie": "cookiesort=7; Hm_lvt_5ac259f575081df787744e91bb73f04e=1563974376,1564218809; Hm_lpvt_5ac259f575081df787744e91bb73f04e=1564226330",
             "Host": "www.shufazidian.com"}
#k os.mkdir("E:\\picture")
url1 = "http://www.shufazidian.com/"
dics = ['机','器','学','习','之']
#dics = ["情"]
for i in dics :
    n=1
    os.mkdir("E:\\picture\\{}".format(i))
    data = {'wd':i,'sort':7}
    response_url = requests.post(url1, data = data,headers=headers_1)
    soup = BeautifulSoup(response_url.text, "lxml")
    #print(soup)
    #for r in soup.find("div", attrs={'id': 'content'}).find("div", sttrs={'id':"woo-holder"}):
    pics =soup.find("div", attrs={'id': 'content'}).find("div", id="woo-holder").find("div", attrs={"class":"woo-swb"}).find("div", class_="woo-pcont woo-masned my-pic").find_all("div",class_="woo")
    for pic in pics[1:-2]:
        r1 = pic.find("div",class_="mbpho")
        if isinstance(r1,element.Tag):
            r = r1.find("a")
            url2 = r["href"]
            response = requests.get(url2,headers = headers_1)
            string = r["title"]
            if "·" in string:
                try:
                    name = eval(str(re.findall("·(.*)·",string)).replace('[','').replace(']','')).strip() + "({}).jpg".format(n)
                    print(name)
                except:
                    name = eval(str(re.findall("·(.*)",string)).replace('[','').replace(']','')).strip() + "({}).jpg".format(n)
                    print(name)
            else:
                name = str(string) + "({}).jpg".format(n)
                print(name)
            name = os.path.join("E:\\picture\\{}\\".format(i),name)
            with open(name,"wb") as f:
                f.write(response.content)
                n = n+1


        
'''
        url2 = url1[i] + "/{}".format(j)
        response_url1 = requests.get(url2, headers=headers_1)
        soup2 = BeautifulSoup(response_url1.text, "lxml")
        for r in soup2.find(name="div", attrs={'class': 'main'}).find(name="div", class_="content").find(name="div", class_="main-image").find(name="p").find(name="a", recursive=True):
            url3 = r["src"]
            response = requests.get(url3, headers=headers_1)
            name = r["alt"] + url3.split("/")[-1]
            print(name)
            name1 = os.path.join("e:\\图片", name)
            with open(name1, "wb") as f:
               f.write(response.content)

'''
# 报错记录：
# 1、将 url1[] 定义在了 for 循环里， 导致只可以爬取24条内容
# 2、网页解析最初使用了 soup2 = BeautifulSoup(response_url1.content, "lxml") 导致报错，用 text 可以完美运行。
#    但是，后来又重新尝试了下，又不报错了，不明白原因
# 3、最终程序可以完没运行，但是最后又报错：OSError: [Errno 22] Invalid argument：+ “正在爬取的文件名”
#    经过百度查询，是这种报错的原因大概有三种： (1)路径斜杠格式错误: 正确的是“/”或“\\”
#                                             (2)引用的路径过长
#                                             (3)平台的 bug， pycharm，Spyder 复制粘贴的路径都会报错，最好手动输入完整路径
#    而我使用了 os 合并了路径，赋值给了 name1，所以可能是由于（3）报错了。
