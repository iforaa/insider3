//
//  PIGraph.swift
//  Insider 3
//
//  Created by Игорь Кузнецов on 18.11.15.
//  Copyright © 2015 PKMR. All rights reserved.
//


import Charts

class PIGraph:ChartViewDelegate {
    let contentView:UIView = UIView()
    
    var chartView:LineChartView = LineChartView()
    var yAxis:ChartYAxis =  ChartYAxis()
    var xAxis:ChartXAxis =  ChartXAxis()
    
    init () {
        self.chartView = LineChartView.init(frame: CGRectZero)
        self.chartView.delegate = self
        
        contentView.addSubview(self.chartView)
        self.chartView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(contentView)
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.bottom.equalTo(contentView)
            
        }
        
        self.chartView.descriptionText = ""
        self.chartView.noDataTextDescription = "You need to provide data for the chart."
        self.chartView.backgroundColor = UIColor(red: 20/255, green: 21/255, blue: 22/255, alpha: 1)
        self.chartView.dragEnabled = true
        self.chartView.setScaleEnabled(true)
        self.chartView.pinchZoomEnabled = true
        self.chartView.drawGridBackgroundEnabled = false
        
        
        self.yAxis = self.chartView.leftAxis;
        
        yAxis.startAtZeroEnabled = false;
        yAxis.gridLineDashLengths = [5.0, 5.0]
        yAxis.drawLimitLinesBehindDataEnabled = false;
        yAxis.labelTextColor = UIColor.whiteColor()
        
        
        self.xAxis = self.chartView.xAxis;
        xAxis.gridLineDashLengths = [5.0, 5.0]
        xAxis.drawLimitLinesBehindDataEnabled = false;
        xAxis.labelTextColor = UIColor.whiteColor()
        
        self.chartView.rightAxis.enabled = false;
        self.chartView.xAxis.enabled = true
        
        self.chartView.viewPortHandler.setMaximumScaleY(4.0)
        self.chartView.viewPortHandler.setMaximumScaleX(4.0)

        
        
        let marker:BalloonMarker = BalloonMarker.init(color: UIColor.whiteColor(), font: UIFont.systemFontOfSize(12.0), insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0))
        
        marker.minimumSize = CGSizeMake(80.0, 40.0)
        self.chartView.marker = marker;
        
        self.chartView.legend.form = .Line
        self.chartView.legend.textColor = UIColor.whiteColor()
        self.chartView.legend.textHeightMax = 16

    }
    
    
    func setDataCount(manager:PISectionManager) {
        
        if (manager.settings.section == .BondsSection) {
            return
        }

        
//      self.chartView.animate(xAxisDuration: 0.5, easingOption: ChartEasingOption.EaseInOutQuart)
        self.chartView.animate(xAxisDuration: 0.5, yAxisDuration: 0.4, easingOption: ChartEasingOption.EaseInOutQuart)
        
        var xVals:[NSDate] = []
        
        for i in 0..<manager.fetchedTickerItemsCount() {
            let val:NSDate = manager.fetchedDate(i)
            xVals.append(val)
        }
        
        var yVals: [ChartDataEntry] = []
        for i in 0..<manager.fetchedTickerItemsCount()
        {
            let val:Double = Double(manager.fetchedRate(i))
            yVals.append(ChartDataEntry.init(value: val, xIndex: i))
        }
        
        
        let set1:LineChartDataSet = LineChartDataSet.init(yVals: yVals, label: manager.fetchedTitle())
        set1.drawCubicEnabled = true
        set1.drawCirclesEnabled = false
        set1.cubicIntensity = 0.2
      //  set1.lineDashLengths = [5.0, 2.5]
      //  set1.highlightLineDashLengths = [5.0, 2.5]
        set1.setColor(UIColor.whiteColor())
        set1.lineWidth = 1.0
        set1.circleRadius = 3.0
        set1.valueFont = UIFont.systemFontOfSize(9.0)
        set1.valueTextColor = UIColor.whiteColor()
        set1.setCircleColor(UIColor.whiteColor())
        set1.drawValuesEnabled = false
        
//        set1.fillAlpha = 65.0/255.0
//        set1.fillColor = UIColor.blackColor()

        var dataSets:[ChartDataSet] = []
        dataSets.append(set1)
        let data:LineChartData = LineChartData.init(xVals: xVals, dataSets: dataSets)
        
        self.chartView.data = data;
        
    }

}
