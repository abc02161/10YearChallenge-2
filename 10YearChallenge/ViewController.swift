import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var peopleLabel: UILabel!
    @IBOutlet weak var showView: UIView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // 2010~2020 台灣人口(萬)
    let taiwanPeople = [2316,2322,2331,2337,2343,2349,2353,2357,2358,2360,2359]
    // 計時器
    var timer = Timer()
    // 初始年份
    var year = 2010
    
    let shapeLayer = CAShapeLayer()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        peopleLabel.text = "總人口數(萬): \(taiwanPeople[0])"
        
        // 預設datePicker的時間
        let dateComponents = DateComponents(calendar: Calendar.current, year: year, month: 06, day: 02, hour: 00, minute: 00, second: 00)

        let date = dateComponents.date
        
        datePicker.date = date!
        
        // datePicker顯示格式(可直接於StoryBoard設定)
        datePicker.datePickerMode = .date
        
        // 繪製初始氣溫
        drawLine()
    }
    
    func drawLine() {
        
        let yearSelect = year - 2010
        let path = UIBezierPath()
        
        peopleLabel.text = "總人口數(萬): \(taiwanPeople[yearSelect])"
        
        // 移除之前畫的曲線
        shapeLayer.removeFromSuperlayer()
        
        // 開始繪製曲線
        path.move(to: CGPoint(x: 0, y: 259))
        path.addLine(to: CGPoint(x: 1, y: 259))
        
        for i in 0...yearSelect {
            path.addLine(to: CGPoint(x: ((i + 1) * 30), y: 260 - (taiwanPeople[i] - 2316) * 5))
        }
        
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.blue.cgColor
        shapeLayer.lineWidth = 5
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        showView.layer.addSublayer(shapeLayer)
        
    }
    
    
    // 自動計時器重複執行內容
    @objc func timerAction() {
        
        if year < 2020 {
            year = year + 1
        } else {
            year = 2010
        }
        
        // 更改Label
        yearLabel.text = "\(year)"
        
        // 更改Slider(需轉為Float)
        slider.value = Float(year)
        
        // 更改datePicker時間
        let dateComponents = DateComponents(calendar: Calendar.current, year: year, month: 06, day: 02, hour: 00, minute: 00, second: 00)
        let date = dateComponents.date
        datePicker.date = date!
        
        // 人口曲線繪製
        drawLine()
        
    }
    

    // datePicker 切換
    @IBAction func datePickerSelect(_ sender: UIDatePicker) {
        
        // 設置要顯示在 UILabel 的日期時間格式
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        
        // 更改Label
        yearLabel.text = formatter.string(from: datePicker.date)
        
        // 取得所選的年份
        let imageYear = datePicker.date
        let dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: imageYear)
        let datePickerYear = dateComponents.year!
        year = datePickerYear
        
        
        // 更改Slider(需轉為Float)
        slider.value = Float(year)

        // 人口曲線繪製
        drawLine()
        
    }
    
    // Slider 切換
    @IBAction func sliderChange(_ sender: UISlider) {
        
        year = Int(sender.value)
        
        // 更改Label
        yearLabel.text = "\(year)"
        
        // 更改datePicker時間
        let dateComponents = DateComponents(calendar: Calendar.current, year: year, month: 06, day: 02, hour: 00, minute: 00, second: 00)
        let date = dateComponents.date
        datePicker.date = date!
        
        // 人口曲線繪製
        drawLine()
        
    }
        
    @IBAction func switchChange(_ sender: UISwitch) {
        
        if sender.isOn {
            // 啟動計時器
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        } else {
            // 關閉計時器
            timer.invalidate()
        }
    }
    
}

