# GJChart

最简单的图表，暂时只支持折线图，条状图。<br>
所有功能自动化，你只需要告诉你要画几条和所有需要的点数据。<br>
你能看到的属性基本都能自定义。<br>
自定义是否自动判断最大最小值、坐标尺个数。<br>

## 简单效果
![](https://github.com/MinorUncle/GJImageCache/raw/master/GJChart/F77F8EB6-D4A6-4975-A792-2978E59A790C.png)
你只需要实现以下几个代理：
图表组数，如一条折线和一组条状图分别为1个。 必实现
-(NSInteger)numberOfSectionsInCoordinateView:(GJChartView *)coordinateView;
每组数据，一个NSValue数组，里面包装CGPoint,代表x,y。必实现
-(NSArray<NSValue *> *)GJChartView:(GJChartView *)view dataForSection:(NSInteger)section
对应每一组的类型，默认是线条，可选代理，
-(CoordinateViewSectionType)GJChartView:(GJChartView *)view typeWithSection:(NSInteger)section；
对应每组的左上角提示符，不实现则不现实
-(NSString *)GJChartView:(GJChartView *)view tipTitleForSection:(NSInteger)section；
每组的每个值的提示符，不实现则直接提示该值浮点数，
-(NSString *)GJChartView:(GJChartView *)view titleWithValue:(CGPoint)point inSection:(NSInteger)section；

自定义x,y轴坐标提示符
-(NSString *)GJCoordinateLayer:(GJCoordinateLayer *)view titleWithXValue:(CGFloat)value
-(NSString *)GJCoordinateLayer:(GJCoordinateLayer *)view titleWithYValue:(CGFloat)value

略略略。。。。。