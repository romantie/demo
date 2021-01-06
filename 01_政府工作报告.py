# GovRptWordCloudv1.py
import jieba
import wordcloud

f = open("新时代中国特色社会主义.txt", "r", encoding="GB2312")

t = f.read()

ls = jieba.lcut(t)
f.close()
txt = " ".join(ls)
w = wordcloud.WordCloud( width=1000, height=700, background_color="white",font_path="msyh.ttc")
w.generate(txt)
w.to_file("grwordcloud.png")


