#openair 教學
#要先下載兩個packages
install.packages('openair')
install.packages('dplyr') #處理數據的function

# 下載region5air 的數據集 
install.packages('region5air')
# 使種方法能解決該數據集不支援R 3.6.3版本問題
install.packages('remotes')

remotes::install_github("NateByers/region5air")

#先看一下數據
library(region5air)
data(chicago_air)
head(chicago_air)

#檢查一下日期
class(chicago_air$date)
## [1] "character"  // 發現是character


# 使用as.POSIXct()來使日期變成YYYY-MM-DD // tz = time zone
chicago_air$date <- as.POSIXct(chicago_air$date, tz = "America/Chicago")

#------summaryPlot()------------------------------------

#匯入openair & dplyr // date:solar 代表只需要前4個column
#底部紅色區域顯示missing data 的時間段

library(openair)
library(dplyr)
summaryPlot(select(chicago_air, date:solar))

#如果圖的顯示有問題的話,可能是日期的關係
#建立一個新的csv檔 在把它讀取近來並設定日期格式
write.csv(chicago_air, file = "chicago_air.csv", row.names = FALSE)

chicago_air <- import(file = "chicago_air.csv", date.format = "%Y-%m-%d",
                      tzone = "America/Chicago")

summaryPlot(select(chicago_air, date:solar))

#------windRose()------------------------------------

#換查看風的資料
data(chicago_wind)
head(chicago_wind)

#馬上就看到warning 資料// 時間顯示超怪的
#再用一次as.POSIXct()
chicago_wind$datetime <- as.POSIXct(chicago_wind$datetime, format ="%Y%m%dT%H%M",
                                    tz = "America/Chicago")

#改好之後用dplyr的 rename()來重新命名(make writing code faster by using short,intuitive names)
chicago_wind <- rename(chicago_wind, date = datetime, ws = wind_speed, wd = wind_dir)

#畫圖八
windRose(chicago_wind, key.footer = "knots") # default is m/s

#可以更改顏色 用c("color1","color2","color3","color4")
# 可更改的顏色直接打colours() 來查看完整的list // 這邊提供一組範例
windRose(chicago_wind, key.footer = "knots",cols = c("yellow", "green", "blue", "black"))

# 也可以更改type來看時間更短的統計情況 // year,season,weekday
windRose(chicago_wind, type = "weekday", key.footer = "knots")


#------pollutionRose()------------------------------------

#跟剛剛的風向很像,只是改成呈現汙染物
# ozone = 臭氧 // breaks 可以設定顏色分層數值,這招同樣可以用在風速
pollutionRose(chicago_wind, pollutant = "ozone",      
              breaks = c(0, .02, .04, .06, .07, .08))

#break 風速範例 // 不過要考慮會不會有些數值會在你設定的最小值以下
windRose(chicago_wind, type = "season", key.footer = "knots",breaks = c(0,2,4,6,8,10,20))

#汙染也可以看每個月的發展
pollutionRose(chicago_wind, pollutant = "ozone", type = "month")

#------percentileRose()------------------------------------

#這個有點厲害,可以快速畫出視覺化的圖案,馬上了解汙染程度
percentileRose(chicago_wind, pollutant = "ozone", smooth  =TRUE)

#這邊提供一個特別一點顏色給大家參考
percentileRose(chicago_wind, pollutant = "ozone", smooth  =TRUE,col = "brewer1")

#------timePlot()------------------------------------

#大家最喜歡的time series
timePlot(chicago_air, pollutant = c("ozone", "temp", "solar"))

#可以增加group = TRUE來讓3條線畫在同一張圖中
timePlot(chicago_air, pollutant = c("ozone", "temp", "solar"),group = TRUE)

#一樣可以自訂顏色
timePlot(chicago_air, pollutant = c("ozone", "temp", "solar"),group=TRUE,cols = c("yellow", "green", "blue"))

#------calendarPlot()------------------------------------

#蠻酷的一個東西 可以在日曆上顯示風向和汙染
calendarPlot(chicago_air, pollutant = "ozone")

#annote後面可以接: ws / ws / date /value
#wd = 平均風速方向 / ws = 基於風速的平均風速方向
# date = 幾月幾號 / value = 日平均
calendarPlot(chicago_wind, pollutant = "ozone", annotate = "ws")

#顏色選擇可以有點變化 以下舉例
calendarPlot(chicago_wind, pollutant = "ozone", annotate = "wd",cols ="jet")
calendarPlot(chicago_wind, pollutant = "ozone", annotate = "wd",cols ="heat")
calendarPlot(chicago_wind, pollutant = "ozone", annotate = "wd",cols ="increment")


# R 語言 packages 都可以上 RDocumentation 這個網站上查用法
# 更多細節請去這個網站 : https://www.rdocumentation.org/packages/openair/versions/2.7-0/topics/windRose

































