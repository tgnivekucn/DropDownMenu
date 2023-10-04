//
//  DropDownMenu.swift
//  DropDownMenu
//
//  Created by SomnicsAndrew on 2023/10/4.
//
import UIKit

class CustomDropDownTableViewCell: UITableViewCell {
    static let cellId = "CustomTableViewCell"
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Arial", size: 20)
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    var text: String? {
        didSet {
            updateText(text: self.text)
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func setupUI() {
        label.frame = CGRect(x: 50, y: 10, width: 100, height: 50)
        self.addSubview(label)
    }
    
    func updateText(text: String?) {
        guard let text = text else {
            return
        }
        label.text = text
    }
}

class DropDownView: UIView {
    private var dropdownButton: UIButton!
    private var dropdownTable: UITableView!
    private let viewWidth = CGFloat(200)
    private let viewHeight = CGFloat(50)
    var items: [String] = ["1", "2", "3"]
    var dropdownButtonBgColor = UIColor.white
    var dropdownButtonTitleColor = UIColor.black
    var didSelectItem: ((Int) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        dropdownButton = UIButton(frame: CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight))
        dropdownButton.setTitle("Select Item", for: .normal)
        dropdownButton.setTitleColor(dropdownButtonTitleColor, for: .normal)
        dropdownButton.backgroundColor = dropdownButtonBgColor
        dropdownButton.layer.borderColor = UIColor.gray.cgColor
        dropdownButton.layer.borderWidth = 2
        dropdownButton.layer.cornerRadius = 5
        dropdownButton.addTarget(self, action: #selector(toggleDropdown), for: .touchUpInside)
        addSubview(dropdownButton)

        let rect = CGRect(x: 0,
                          y: viewHeight,
                          width: viewWidth,
                          height: 0)
        dropdownTable = UITableView(frame: rect)
        dropdownTable.delegate = self
        dropdownTable.dataSource = self
        dropdownTable.register(CustomDropDownTableViewCell.self, forCellReuseIdentifier: CustomDropDownTableViewCell.cellId)
        self.addSubview(dropdownTable)
    }

    @objc private func toggleDropdown() {
        if self.dropdownTable.frame.height == 0 {
            self.dropdownTable.contentOffset.y = self.getTableViewHeight()
        } else {
            self.dropdownTable.contentOffset.y = 0
        }

        UIView.animate(withDuration: 0.6, delay: 0, options: [.curveEaseOut]) {
            if self.dropdownTable.frame.height == 0 {
                let rect = CGRect(x: 0,
                                  y:  self.viewHeight,
                                  width: self.viewWidth,
                                  height: self.getTableViewHeight())
                self.dropdownTable.frame = rect
                self.dropdownTable.contentOffset.y = 0
            } else {
                let rect = CGRect(x: 0,
                                  y:  self.viewHeight,
                                  width: self.viewWidth,
                                  height: 0)
                self.dropdownTable.frame = rect
                self.dropdownTable.contentOffset.y = self.getTableViewHeight()
            }
        }
    }

    private func getTableViewHeight() -> CGFloat {
        let rowHeight = CGFloat(70)
        return rowHeight * CGFloat(items.count)
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == self {
            return nil
        }
        if dropdownButton.frame.contains(point) {
            return dropdownButton
        }
        if dropdownTable.frame.contains(point) {
            return dropdownTable
        }
        return nil
    }
}

extension DropDownView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomDropDownTableViewCell.cellId, for: indexPath)
  
        if let cell = cell as? CustomDropDownTableViewCell {
            cell.updateText(text: items[indexPath.row])
        }
        return cell
    }
}

extension DropDownView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(70)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("test11 tableView - didSelectRowAt indexPath: \(indexPath.row)")
        dropdownButton.setTitle(items[indexPath.row], for: .normal)
        toggleDropdown()
        didSelectItem?(indexPath.row)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("test11 tableView - didDeselectRowAt indexPath: \(indexPath.row)")
    }
}
