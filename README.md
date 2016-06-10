# GJChart

最简单的图表，暂时只支持折线图，条状图。<br>
所有功能自动化，你只需要告诉你要画几条和所有需要的点数据。<br>
你能看到的属性基本都能自定义。<br>
自定义是否自动判断最大最小值、坐标尺个数。<br>

## 简单效果
![](https://github.com/MinorUncle/GJImageCache/raw/master/GJChart/F77F8EB6-D4A6-4975-A792-2978E59A790C.png)<br>
你只需要实现以下几个代理：<br>
图表组数，如一条折线和一组条状图分别为1个。 必实现<br>
-(NSInteger)numberOfSectionsInCoordinateView:(GJChartView *)coordinateView;<br>
每组数据，一个NSValue数组，里面包装CGPoint,代表x,y。必实现<br>
-(NSArray<NSValue *> *)GJChartView:(GJChartView *)view dataForSection:(NSInteger)section<br>
对应每一组的类型，默认是线条，可选代理，<br>
-(CoordinateViewSectionType)GJChartView:(GJChartView *)view typeWithSection:(NSInteger)section；<br>
对应每组的左上角提示符，不实现则不现实<br>
-(NSString *)GJChartView:(GJChartView *)view tipTitleForSection:(NSInteger)section；<br>
每组的每个值的提示符，不实现则直接提示该值浮点数，<br>
-(NSString *)GJChartView:(GJChartView *)view titleWithValue:(CGPoint)point inSection:(NSInteger)section；<br>
自定义x,y轴坐标提示符<br>
-(NSString *)GJCoordinateLayer:(GJCoordinateLayer *)view titleWithXValue:(CGFloat)value<br>
-(NSString *)GJCoordinateLayer:(GJCoordinateLayer *)view titleWithYValue:(CGFloat)value<br>
<br>
略略略。。。。。